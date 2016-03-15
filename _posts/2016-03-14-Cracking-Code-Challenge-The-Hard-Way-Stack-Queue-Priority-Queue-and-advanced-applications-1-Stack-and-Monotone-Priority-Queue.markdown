---
layout:     post
title:      "Cracking Code Challenge The Hard Way - Stack, Queue, Priority Queue and advanced applications (1) -- Stack and Monotone Priority Queue"
subtitle:   ""
date:       2016-03-14 20:18 
author:     "Pufan Jiang"
header-img: "img/post-2016-02-11-poison-pill-pattern.jpg"
tags:
    - code challenge
    - stack
    - monotone priority queue
---

# Cracking Code Challenge The Hard Way - Stack, Queue, Priority Queue and advanced applications (1) -- Stack and Monotone Priority Queue

## TL;DR

Awww yah!

In these short series, I will cover basic data structures including Stack, Queue, and Priority Queue, and there mutations or advanced applications, including Priority Queue with log time complexity deletion, Monotone Priority Queue and Deque.

This article will cover Stack and Monotone Priority Queue.

These problems will be included in this article:

Stack

 1.[Binary Tree Preorder Traversal](https://leetcode.com/problems/binary-tree-preorder-traversal/)
 2.[Binary Tree Inorder Traversal](https://leetcode.com/problems/binary-tree-inorder-traversal/)
 3.[Binary Tree Postorder Traversal](https://leetcode.com/problems/binary-tree-postorder-traversal/)
 4.[Verify Preorder Sequence in Binary Search Tree](https://leetcode.com/problems/verify-preorder-sequence-in-binary-search-tree/)
 5.[Verify Preorder Serialization of a Binary Tree](https://leetcode.com/problems/verify-preorder-serialization-of-a-binary-tree/)
 6.[Evaluate Reverse Polish Notation](https://leetcode.com/problems/evaluate-reverse-polish-notation/)
 7.[Basic Calculator](https://leetcode.com/problems/basic-calculator/)
 8.[Basic Calculator II](https://leetcode.com/problems/basic-calculator-ii/)
  9.[Valid Parentheses](https://leetcode.com/problems/valid-parentheses/)
  10.[Longest Valid Parentheses](https://leetcode.com/problems/longest-valid-parentheses/)
  11.[Remove Invalid Parentheses](https://leetcode.com/problems/remove-invalid-parentheses/)
   12.[Largest Rectangle in Histogram](https://leetcode.com/problems/largest-rectangle-in-histogram/)
 13.[Max Tree](http://www.lintcode.com/en/problem/max-tree/#)


## Stack

### Key Idea

Stack is helpful when the problem could be solved in a format that every new incoming data/element, referencing formerly saved data/elements **sequentially and backwardly**, could produce something that is either useful for the next round iteration/recursion, or part of the answer.

In other words, Stack is used when:

Result is computed when data is coming sequentially. Also, if a part of result given by incoming data is dependent on formerly saved data, these formerly saved data could only be used sequentially, in a reverse order when they are pushed into the stack.

No worry if you don't fully understand this sentence know. Keep it in mind and let's crack some coding problem!

### Complexity Analysis

Generally speaking, an algorithm designed using stack has $O(N)$ time and space complexity.

The three most frequently used operation on stack -- push, pop and peek use $O(1)$/constant extra space and $O(1)$/constant time. More specifically, the push operation uses amortized $O(1)$ time if stack is implemented using array, since we have to extend array from time to time.

### Tree traversal (basic level)

Lots of problems related to tree traversal operation could be optimized using stack. By "optimized" I mean you could solve these problems without manage the stack yourselves, i.e. using system stack. 

But manage stack by yourselves has at least two advantages.

1. Self-managed stack is created in heap space, so that we are far less worried about if there is enough space. This is because stack is generally way smaller than heap (all system/process structure level).
2. When popping multiple elements from stack, it is more straightforward to do this in a while/for loop, instead of recursively going back.

Solve these problems in both recursive(stack managed by operation system) and iterative(stack managed by programmer) ways. Feel the simplicity of recursion method and manage basic skills using stack.

 1.[Binary Tree Preorder Traversal](https://leetcode.com/problems/binary-tree-preorder-traversal/)
 2.[Binary Tree Inorder Traversal](https://leetcode.com/problems/binary-tree-inorder-traversal/)
 3.[Binary Tree Postorder Traversal](https://leetcode.com/problems/binary-tree-postorder-traversal/)

 Be more familiar with stack and order in tree.
 
 4.[Verify Preorder Sequence in Binary Search Tree](https://leetcode.com/problems/verify-preorder-sequence-in-binary-search-tree/)
 5.[Verify Preorder Serialization of a Binary Tree](https://leetcode.com/problems/verify-preorder-serialization-of-a-binary-tree/)

### Indirect tree traversal (medium level)

Calculation tree problem is a good practice and application on top of tree traversal operation. They give you an insight of how a string-like expression could be conceptually translated to a tree, and solved using tree traversal.

 Jump to the second and third problem if you want to challenge yourself, otherwise check the first problem and [Reverse Polish notation](https://en.wikipedia.org/wiki/Reverse_Polish_notation) first.
 
 1.[Evaluate Reverse Polish Notation](https://leetcode.com/problems/evaluate-reverse-polish-notation/)
 2.[Basic Calculator](https://leetcode.com/problems/basic-calculator/)

 After solving the calculation tree problems, you should have idea to solve parenthesis problems. They partly share the same idea.
  
  4.[Valid Parentheses](https://leetcode.com/problems/valid-parentheses/)
  5.[Longest Valid Parentheses](https://leetcode.com/problems/longest-valid-parentheses/)
  6.[Remove Invalid Parentheses](https://leetcode.com/problems/remove-invalid-parentheses/)

### Stack as Monotone Priority Queue (advanced level)

Even though I put these problems in advanced level category, you may find them easy once you get the idea. 

**[Hint (don't read the following part unless you get stuck):]** 

The key idea for these two problems are the same: each new incoming data could help to calculate the final answer, combined with formerly saved data, but only part of them! Which part? Either the data that is larger than itself, or is smaller than itself. 

In this way, we could maintain the stack in a way that all data belong to this stack is monotonically increasing or decreasing. This idea is also called Monotone Priority Queue.
 
For more detailed hints and thoughts, see my answer to these problems.

 1.[Largest Rectangle in Histogram](https://leetcode.com/problems/largest-rectangle-in-histogram/)
 2.[Max Tree](http://www.lintcode.com/en/problem/max-tree/#)
