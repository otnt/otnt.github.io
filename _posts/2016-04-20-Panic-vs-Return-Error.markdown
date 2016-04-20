---
layout:     post
title:      "Panic vs. Return Error"
subtitle:   ""
date:       2016-04-20 16:17 
author:     "Pufan Jiang"
tags:
    - Go
    - Panic
---

但凡编写实用的程序，都需要处理错误异常。常见的方法有两种，一种是抛出异常(throw Exception), 类似于Go语言中的panic, 另一种是返回一个错误标示, 类似于Go语言中返回error, 或是C语言中返回-1。

常常有人讨论哪种做法更好。我认为以下观点值得参考。

The rule is simple: if your function is in any way likely to fail, it should return an error. When I'm calling some other package, if it is well written I don't have to worry about panics, except for, well, truly exceptional conditions, things I shouldn't be expected to handle.

Talk about error-code-style and exception-catch-style (Suggested by [Ross Cox](https://plus.google.com/+RussCox-rsc/posts/iqAiKAwP6Ce)):

[Blog 1](https://blogs.msdn.microsoft.com/oldnewthing/20040422-00/?p=39683/)

[Blog 2](https://blogs.msdn.microsoft.com/oldnewthing/20050114-00/?p=36693)

