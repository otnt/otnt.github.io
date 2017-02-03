---
layout:     post
title:      "动态规划题目的一般化"
subtitle:   ""
date:       2016-05-21 12:22 
author:     "Pufan Jiang"
header-img: "img/post-bg.jpg"
tags:
    - algorithm
    - interview 
---

最近在实习，做题的时间非常有限。翻了下算法导论中动态规划一章，觉得讲的着实好。动态规划其实非常有迹可循，而面试算法考法更是有限。在此分享一下我读了算法导论这一章后对动规解题思路的理解（其中很多内容和我之前[一篇博文](http://otnt.github.io/2016/04/29/dynamic-programming/)中的思路不谋而合）。

### 1. DP要点

1.1 DP一般用于优化问题（optimization problem）。这类问题有很多解，DP能快速找到*一个最优解*（可能存在多个最优解）。 
1.2 DP适用于子问题有*Overlap*的情况，即子问题之间共享相同的子子问题，或者说，上层解会*反复*依赖已经计算过的下层解。而Divide-and-Conquer适用于子问题独立的情况，递归地去解决子问题。
1.3 存在*独立最优子结构*（independent optimal substructure）。即最优化结构要能够由最优子结构独立推导出，而不受其他最优化结构影响。

### 2.DP四步骤

3.1 找到最优子结构，即如何由optimal substructure推导出optimal structure.
3.2 寻找第一步推导的公式，一般用递归的思想去思考&定义。
3.3 设计算法实现。一般用bottom-up的方式去实现。
3.4 反推具体的最优解，一般通过同时维护另一个存储空间来实现。

### 3. DP Case Study

这里分享一些我做DP题目的四步骤。(不断更新)

[最长回文子串]()

