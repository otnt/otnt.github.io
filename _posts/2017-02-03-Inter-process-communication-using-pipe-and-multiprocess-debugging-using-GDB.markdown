---
layout:     post
title:      "Inter-process communication using pipe and multiprocess debugging using GDB"
subtitle:   ""
date:       2017-02-03 17:06
author:     "Pufan Jiang"
header-img: "img/post-bg.jpg"
tags:
    - c
    - unix
    - gdb
    - system 
---

In this article, we'll walk through a simple example showing

- how to use unix pipe for inter-process communication
- how to debug a program of three processes using GDB

<!-- excerpt -->
---
---

### Pre-requists

- experience using pipe in terminal/bash, and understand basic concept of pipe (checkout the video [Unix intro](https://www.youtube.com/watch?v=tc4ROCJYbm0))
- experience using GDB, know how to set breakpoints (checkout [GDB tutorial](https://sourceware.org/gdb/onlinedocs/gdb/index.html#Top))
- c language readability (espicially ```fork```, ```exec```)
- understand I/O redirect (checkout ```man dup```)

### The problem

The problem is to

1. load two pre-built programs
2. stream the output of the first program to the second one
3. print the result of the second program
4. print a finish sentence when both programs finish

For example, we want to mimic the action of such bash command:

```
/bin/ls | /bin/sort
```

### The first version

Our very first version almost works, it

1. sets up a pipe for later inter-process communication
2. forks two processes
3. modifies pipe for each process, so that the input/output is correctly redirected
4. loads the pre-built programs to the processes
5. prints the finish sentence

The C file is [here](https://github.com/otnt/inter-process-communication-using-pipe/blob/master/first.c).

Compile and run the program (assuming you have ```gcc``` installed). Notice you may need to modify positions for ```ls``` and ```sort``` programs if the belowing positions do not work.

```
gcc -o first first.c
./first /bin/ls /usr/bin/sort
```

Here is the output:

```
Run two programs succeeded!
README.md                                                                                                                                                                            
a.out
first
first.c
```

And this the output of pipe in terminal:

```
/bin/ls | /usr/bin/sort 

README.md
a.out
first
first.c
```

We see the two outputs are exactly the same! Congratulations... But the finish sentence appears on top of the output instead of at the end.

This is mainly because of printing a simple sentence usually runs much faster than loading and executing two small programs.

To fix the problem, let's move on to second version.

### The second version

At first glance, we may think it extremely easy to fix the problem: just add wait statement in the last ```else``` branch, so that the main program will print the finish sentence after child processes finish.

The second version is at [here](https://github.com/otnt/inter-process-communication-using-pipe/blob/master/second.c). Notice the only difference is two additional lines (105-106).

Compile and run:

```
gcc -o second second.c
./second /bin/ls /usr/bin/sort
```

We will find the program **never** finishes!

Instead of telling you why the program breaks, we will use GDB to find out the reason together.

Compile the program again with debug information and use GDB to execute the program:

```
gcc -g -O0 -o second second.c 
gdb --args second /bin/ls /usr/bin/sort
```

Before everything, let's set ```detach-on-fork``` environment variable of GDB to off.

```
set detach-on-fork off
```

By doint this, we could switch between processes easily. More details on this environment at [here](https://sourceware.org/gdb/onlinedocs/gdb/Forks.html).

Now let's set breakpoint at right before ```waitpid``` system call and run the program

```
(gdb) br second.c:105
Breakpoint 1 at 0x400b27: file second.c, line 105.
(gdb) r
...
Breakpoint 1, main (argc=3, argv=0x7fffffffe438) at second.c:105
105			waitpid(pid1, NULL, 0);
```

Now use ```next``` command of GDB to step through the functions.

```
(gdb) n
106			waitpid(pid2, NULL, 0);
(gdb) n
```

This means the first program finishes successfully, but the second one suspends and never returns!

In order to figure out why the second program never returns, let's run the program again, and use ```catch```, ```inferior``` commands to go to that child process instead of the parent process.

First, let GDB stops when a ```fork``` system call is called

```
(gdb) catch fork
Catchpoint 1 (fork)
```

Next, go to the fork statement at line 84.

```
(gdb) r
Starting program: second /bin/ls /usr/bin/sort

Catchpoint 1 (forked process 6134), 0x00007ffff7ad5ee4 in __libc_fork () at ../nptl/sysdeps/unix/sysv/linux/x86_64/../fork.c:130
130	../nptl/sysdeps/unix/sysv/linux/x86_64/../fork.c: No such file or directory.
(gdb) c
Continuing.
[New process 6134]

Catchpoint 1 (forked process 6147), 0x00007ffff7ad5ee4 in __libc_fork () at ../nptl/sysdeps/unix/sysv/linux/x86_64/../fork.c:130
130	in ../nptl/sysdeps/unix/sysv/linux/x86_64/../fork.c
(gdb) finish
Run till exit from #0  0x00007ffff7ad5ee4 in __libc_fork () at ../nptl/sysdeps/unix/sysv/linux/x86_64/../fork.c:130
[New process 6147]
0x0000000000400a79 in main (argc=3, argv=0x7fffffffe438) at second.c:84
84		else if (0 == (pid2 = fork()))
Value returned is $1 = 6147
```

Notice we meet two ```fork``` system calls. The first one corresponds to the one at line 67, and second one is what we're interested in.

GDB use the concept of *inferior* to refer to threads, processes etc. To see currently running processes, just run

```
(gdb) info inferiors 
  Num  Description       Executable        
  3    process 6147      second 
  2    process 6134      second 
* 1    process 6127      second
```

Notice both executable names of child processes are "second". This means the ```/bin/ls``` and ```/usr/bin/sort``` are not loaded yet. This is because by setting ```detach-on-fork``` off, the newly created processes will be suspended by default.

Let's switch to first program (inferior 2) and let it finish.

```
(gdb) inferior 2
...
(gdb) c
Continuing.
process 6134 is executing new program: /bin/ls
Reading symbols from /usr/lib/debug/lib/x86_64-linux-gnu/ld-2.19.so...done.
[Inferior 2 (process 6134) exited normally]
```

Now only two inferiors are left.

```
(gdb) info inferiors 
  Num  Description       Executable        
  3    process 6147      second 
* 2    <null>            /bin/ls           
  1    process 6127      second 
```

The process 6147 (inferior 1) is the one we're actually interested in. Let's figure out at which statement it stucks.

```
(gdb) inferior 3
...
(gdb) finish
Run till exit from #0  __libc_fork () at ../nptl/sysdeps/unix/sysv/linux/x86_64/../fork.c:137
0x0000000000400a79 in main (argc=3, argv=0x7fffffffe438) at second.c:84
84		else if (0 == (pid2 = fork()))
Value returned is $2 = 0
(gdb) n
88		    	if (-1 == close(pipefd[1])) {
(gdb) n
94		    	if (-1 == dup2(pipefd[0], STDIN_FILENO)) {
(gdb) n
98		    	run(program2);
(gdb) n

```

The program seems stuck when executing ```/usr/bin/sort```. A guess is input file is never closed. Let's check.

```
^Z
Program received signal SIGTSTP, Stopped (user).
0x00007ffff78e26b0 in __read_nocancel () at ../sysdeps/unix/syscall-template.S:81
81	in ../sysdeps/unix/syscall-template.S
(gdb) shell ls -l /proc/6147/fd
total 0
lr-x------ 1 parallels parallels 64 Feb  3 16:37 0 -> pipe:[91298]
lrwx------ 1 parallels parallels 64 Feb  3 16:37 1 -> /dev/pts/25
lrwx------ 1 parallels parallels 64 Feb  3 16:37 2 -> /dev/pts/25
lr-x------ 1 parallels parallels 64 Feb  3 16:37 3 -> pipe:[91298]
```

Exactly! The read end of pipe is still opening! The read end should close automatically when the write end closes. The write end is closed in the first program. But it is never been closed in the parent program! And now we find out the reason of the bug!

Just to make sure our guess is correct, let's examine open file descriptors in parent process.

```
(gdb) inferior 1
[Switching to inferior 1 [process 6127] (second)]
[Switching to thread 1 (process 6127)] 
#0  0x0000000000400a79 in main (argc=3, argv=0x7fffffffe438) at second.c:84
84		else if (0 == (pid2 = fork()))
(gdb) c
Continuing.
^Z
Program received signal SIGTSTP, Stopped (user).
0x00007ffff7ad5a0c in __libc_waitpid (pid=6147, stat_loc=0x0, options=0) at ../sysdeps/unix/sysv/linux/waitpid.c:31
31	../sysdeps/unix/sysv/linux/waitpid.c: No such file or directory.
(gdb) shell ls -l /proc/6127/fd
total 0
lrwx------ 1 parallels parallels 64 Feb  3 16:29 0 -> /dev/pts/25
lrwx------ 1 parallels parallels 64 Feb  3 16:29 1 -> /dev/pts/25
lrwx------ 1 parallels parallels 64 Feb  3 16:29 2 -> /dev/pts/25
lr-x------ 1 parallels parallels 64 Feb  3 16:29 3 -> pipe:[91298]
l-wx------ 1 parallels parallels 64 Feb  3 16:29 4 -> pipe:[91298]
```

And we know the pipe is indeed not closed in parent process. This leads us to third version.

### The third version

In order to fix the bug, we need to close both ends of pipe before waiting for child processes to terminate.

The third version is [here](https://github.com/otnt/inter-process-communication-using-pipe/blob/master/third.c).

Now let's test the program again.

```
gcc -o third third.c 
./third /bin/ls /usr/bin/sort
```

And here is the result on my machine,

```
README.md
first.c
second.c
third
third.c
Run two programs succeeded!
```

which is the same as the result of terminal.

### Conclusion

In this article, we walk through a simple example that create two processes and load one binary image for each process. Additionally, we use GDB for debugging a bug in multi-process environment.

We learnt

- C and Unix skills
	- pipe
	- fork
	- waitpid
	- dup
- GDB skills
	- catch
	- inferior
