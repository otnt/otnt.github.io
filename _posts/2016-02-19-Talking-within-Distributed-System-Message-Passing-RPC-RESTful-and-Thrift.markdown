---
layout:     post
title:      "Talking within Distributed System"
subtitle:   "Message Passing, RPC, RESTful and Thrift"
date:       2016-02-19 14:41
author:     "Pufan Jiang"
header-img: "img/post-2016-02-11-poison-pill-pattern.jpg"
tags:
    - Distributed System
    - Network
    - Communication
    - Message Passing
    - RPC
    - Remote Procedure Call
    - RESTful
    - Thrift
---

> This is a short series about some important concepts in distributed system.

## TL;DR;

In this article, I first tried to explain what's difference between communication in distributed system and local machine. 

Then I talked about two most popular way to communicate within a distributed system, i.e. message passing and RPC, and analyzed the advantages and disadvantages of them. 

Finally, I introduced two most successful protocol using these two communication idea, i.e. RESTful and Thrift.

## Why talking within distributed system is different from local machine?

In a local machine, when process A is communicating with process B, it could be done in a synchronized fashion guaranteed by electrical circuit or the so-called bus built in your laptop or server. So the delivery time is always constant, corresponding to several clock cycles.

The fundamental difference of distributed system and local machine is due to network unreliability. When machine A is sending message to or call function at machine B, there is not such bus connecting them so that they could only communicate through network. So either machine A get an acknowledgement message and it could be sure that machine B receive the message, or it has to wait indefinitely since it could never tell whether the message is lost or it is network congestion.

So it is the case that I know what I know, but I don't know what others know, and I don't know what others know others know...

## An example

Through the next of this post, we will examine a simple common example ``distcp``. So the semantic of ``distcp`` is the same as ``cp`` (copy) method, it copies data from one location to another.

More specifically, when machine A runs ``distcp path1/file path2``, it copy ``file`` from ``path1`` to ``path2``.

## Message Passing

So message passing is actually the most straightforward and also most widely used way to implement distributed system communication (think about Internet!).

Message Passing defines two basic method, **send()** and **receive()**.  It sends the whole information including operator (in our case it is ``distcp``) and operands (in our case it is ``file`` and ``path``) through network. And when receiver receives the message, it lookups the operator and finds corresponding local method and then finishes the job.

**Advantages** 

It is straightforward/user-friendly.

**Disadvantages** 

However, despite the good point of message passing, this method leaves a lot of burden to application programmer. A common message passing is very like this:
On sender's side:

    MessageFactor.createMessage("distcp").setArgument(0, "path1/file").setArgument(1, "path2").send(ip of machine B)

On receiver's side:

	operator = receive().getOperator();
	switch(operator) {
		case "distcp": copy to path; break;
	}

There are two obvious problem.
1.Programmer needs to do lots of work to control the logic, especially on receiver's side.
2.The program could not make use of compile check to make sure the sending message is correct. This significantly increase the possibility of runtime error. 


## Remote Procedure Call (RPC)

So to reduce the burden of programmers and make our program more predictable, RPC is a good idea.

The core idea of RPC is to provide an interface for both local and remote procedure call, so that programmer could call remote function just like call local function.

So the RPC way of our function is very like to be this:

	register_path("path1", ip of machine A);
	register_path("path2", ip of machine B);
	dist("path1/file", "path2");
	

And it is done! How to find the file and how to bind the data is left to RPC service. After binding the path and machine, the programmer doesn't need to worry about the whole logic. Moreover, now we could at compile time check whether the programmer provides exactly two arguments , reducing runtime error.

Also, it a lot of distributed system, e.g. Hadoop platform, there's a master machine to take care of path binding, so the two ``register_path`` method could be avoided as well!

**Note** To understand how the RPC service is implemented, I encourage you to further read some posts online or this paper [Implementing remote procedure calls](http://doi.acm.org/10.1145/2080.357392) by Andrew and Bruce.

**Advantages**

1.RPC provide the abstraction of procedure call so that programmers could use these services easily just as using local methods.
2.It also helps reducing runtime errors.

**Disadvantages**
Now RPC may seems really attracting, it has one important disadvantages compared to message passing -- the service itself is much complicated.

Yes, the user/programmer is relieved from handling logic and data binding themselves, but the API provider/RPC service provider need to do a lot of work, including defining interface, implementing logic etc. The complication is significant when testing some new functions, since the API may change frequently during development.

## Real World Implementation

Now we scratched the surface of both two common communication ways, how and when do we prefer one to the other? Let's see two most widely used communication protocol in web service today.

### RESTful

I'm not going to talk about what is RESTful. I assume you have already know what it is and hopefully you have used it several times in your previous projects.

RESTful is a good example using the idea of message passing. For **send()** method, it supports four operators, i.e. GET, PUT, POST and DELETE, and nearly unlimited number of operands (within bound of network limit of course). And **receive()** method is handled by HTTP request.

**Advantages**
1.Lightweight. Since RESTful API is often used for implementing CRUD operations in database, so the message is generally short.
2.User-friendly. RESTful has same semantics with HTTP request, thus learning curve of RESTful is almost zero degree!
3.Language/Platform independence. Since RESTful is nothing but HTTP request, it has no constraints on language or system platform.

**Disadvantages**
The disadvantage of RESTful stems from HTTP protocol itself. 

One thing is RESTful does not support basic method other than HTTP's methods. Although one could put operator inside body of HTTP request, but that would lose the lightweight property of RESTful. 

Another disadvantage is HTTP request is expensive. Each HTTP request is generally a blocking process, harming the scalability of system. (This is said be overcome in HTTP 2.0, I'm not quite familiar with HTTP 2.0, but this disadvantage holds for HTTP 1.1).

### Thrift

My understanding of Thrift may not be correct and well-rounded, since I haven't use Thrift a lot. But generally, Thrift is a protocol based on RPC so that to simplify remote call process and with goal of a fast, reliable and safe communication.

To use Thrift, you need first define the RPC interface using Interface Definition Language (IDL). This interface is a constraint that both server and clients using the method should follow. After you defined the interface, it is Thrift that will take care of the underlying communication and compile time checking.

**Advantages**
1.Provide compile time checking. Thrift is much stricter than RESTful, but the goodness is it could help avoid lots of small errors.
2.It is faaaaast. RPC generally take advantages of UDP protocol and binding acknowledgement message with next request to avoid overhead and amount of exchanging data.

**Disadvantages**
It is obvious that Thrift is way complicated than RESTful API. It also doesn't have a universal method name (e.g. GET in RESTful). Therefore developers need to first learn the interface of different Thrift library then could they move on.

## Discussion

So how to choose among them? Like most design in computer science, there is no absolute yes or no to choose one protocol rather than the other.

It has been a consensus that, generally, when developing light-weight api, especially those similar with CRUD operations, and when your api is used by lots of users, then RESTful may be better choice. While developing api that is internally used, or logically complicated, or fast is your first priority, then Thrift may be better.

In comparison these protocol, here is a great [article](http://nordicapis.com/microservice-showdown-rest-vs-soap-vs-apache-thrift-and-why-it-matters/) by Kristopher  Sandoval. I quote part of the article here, but you should definitely read through that great post.

> REST, on the other hand, is like a pre-paid postcard. You’ve forgone the envelope in favor of a lightweight, succinct delivery device that is easy to interpret and handle, with your message quickly scribbled on the back. The postcard uses less material (bandwidth), is typically shorter in content, and might actually get to your neighbor faster because there’s less bulk to move around.

> Thrift is like a megaphone. When you point the megaphone at your neighbor, he implicitly knows you’re upset about something — and that you’re going to say it specifically to him. He knows what to do with the information, because the reaction a human has to a megaphone is pretty universal (assuming, of course, that your megaphone is louder than his drums). The message is sent in a lightweight but forceful manner that depends entirely on the receiver to properly process it, in this case your neighbor.
