---
layout:     post
title:      "Concurrency vs. Parallelism"
subtitle:   ""
date:       2016-04-20 13:22 
author:     "Pufan Jiang"
tags:
    - Go
    - Concurrency
    - Parallelism
---

These notes are quoted from [Go Concurrency Patterns](https://www.youtube.com/watch?v=f6kdp27TYZs).

### What is Concurrency

Programming as the composition of independently executing processes.

### What is Parallelism

Programming as the simultaneous execution of (possibly related) computations.

### Concurrency vs. Parallelism

Concurrency is about dealing with lots of things at once.

Parallelism is about doing lots of things at once.

One is about structure, one is about execution.

Concurrency provides a way to structure a solution to solve a problem that may (but not necessarily) be parallelizable.

