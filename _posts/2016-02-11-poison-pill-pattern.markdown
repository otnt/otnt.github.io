---
layout:     post
title:      "Poison Pill"
subtitle:   "A decent way to stop service in producer consumer environment"
post-date:       2016-02-11 14:37
update-date:       2016-02-11 14:37
tags:
    - Design Pattern
    - Multi-thread
    - Producer Consumer
tldr: "How do producer(s) notify consumer(s) to stop? The producer can not simple kill the consumer, since there may be some jobs still in the queue. One solution is use poison pill -- a special value to notify consumer(s) the end of service."
---

### TL;DR

How do producer(s) notify consumer(s) to stop? The producer can not simple kill the consumer, since there may be some jobs still in the queue. One solution is use poison pill -- a special value to notify consumer(s) the end of service.

### How it works?
The idea is extremely simple. When producer wants to stop the service, it sends a special message (poison pill) into the queue and stops it self, when consumer gets this message, it closes it self as well.

### What if multiply producers and multiply consumers?
1. If only one producer and consumer, then it's totally fine. 
2. If there are several producers and one consumer, each producer could send a poison pill to consumer and stop itself. When consumer gets same number of poison pills, then it stop running.
3. If there are one producer and several consumers, then producer send poison pills of same number as consumers to queue. Each consumer stops itself when get a poison pill.
4. If there are multiple producers and multiple consumers, then each producer send poison pill of same number as consumers to queue. Each consumer stops itself when get poison pills of same number as producer.

### What is the problem?
This solution suppose producers and consumers know the quantity of each other.
Also, if we have N producers and M consumers, then number of poison pills will be N*M, which could be large.

### Alternative Solution
One alternative solution is we relax the constraints so that consumers could also offer messages into queue, but only when it is trying to stop the whole service.

On producers' side, when all producers are going to leave the service, the last producer send a poison pill to the queue. This could be done by several ways, one way is to elect a leader so the leader send the poison pill and then every producer leaves.

On consumers' side, when any of consumers get a poison pill, it first the poison pill back to queue and leave the service. So that all consumers will finally leave the service.

This solution is based on that producers know each other, and consumers know each other, but producers and consumers don't know each other, which makes more sense in real world.

### Reference
1.  "Poison Pill Shutdown" in Java Concurrency in Practice
