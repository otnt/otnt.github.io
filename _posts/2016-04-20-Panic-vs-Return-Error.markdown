---
layout:     post
title:      "Exception handling: panic/exception v.s. return error"
subtitle:   ""
post-date:       2016-04-20 16:17 
update-date:       2016-04-20 16:17 
tags:
    - Go
    - Panic
---

There are two common ways to handle errors:

- throw exception
	- e.g. ```panic``` in Golang
- return error code
	- return 0 or -1 in Unix system calls

Here is one point of view to decide which method to go with.

<!-- excerpt -->
---
---

> The rule is simple: if your function is in any way likely to fail, it should return an error code. When I'm calling some other package, if it is well written I don't have to worry about panics, except for, well, truly exceptional conditions, things I shouldn't be expected to handle.

To know more. Here is a [short discussion](https://plus.google.com/+RussCox-rsc/posts/iqAiKAwP6Ce) by Ross Cox, where he suggested these two articles:

- [Cleaner, more elegant, and wrong](https://blogs.msdn.microsoft.com/oldnewthing/20040422-00/?p=39683/)
- [Cleaner, more elegant, and harder to recognize](https://blogs.msdn.microsoft.com/oldnewthing/20050114-00/?p=36693/)
