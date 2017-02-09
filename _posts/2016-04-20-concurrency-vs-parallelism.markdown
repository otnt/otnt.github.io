---
layout:     post
title:      "Concurrency vs. Parallelism"
subtitle:   ""
post-date:       2016-04-20 13:22 
update-date:       2016-04-20 13:22 
tags:
    - Go
    - Concurrency
    - Parallelism
---

Quoted from [Go Concurrency Patterns](https://www.youtube.com/watch?v=f6kdp27TYZs).

<!-- excerpt -->
---
---

### What is Concurrency

Programming as the composition of independently executing processes.

### What is Parallelism

Programming as the simultaneous execution of (possibly related) computations.

### Concurrency vs. Parallelism

Concurrency is about dealing with lots of things at once.

Parallelism is about doing lots of things at once.

One is about structure, one is about execution.

Concurrency provides a way to structure a solution to solve a problem that may (but not necessarily) be parallelizable.

