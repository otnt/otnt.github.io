---
layout:     post
title:      "DP分析之最长回文子串"
subtitle:   ""
date:       2016-05-21 12:25 
author:     "Pufan Jiang"
header-img: ""
tags:
    - algorithm
    - interview 
---

最长回文子串(Longest Palindrome Substring)

Leetcode描述[在此](https://leetcode.com/problems/longest-palindromic-substring/)

DP四步骤：

1.寻找最优子结构

首先直接想到的是，如果知道i到j范围内的最优解，能否得知i到j+1的最优解。然而发现，可能最优解是i+1到j。联想到回文是一个头尾都要考虑的结构，所以修改子结构为，已知i到j-1内的最优解，以及i+1到j内的最优解，能否得到i到j内的最优解。

思考后发现是可以的。如果i和j相同，那么最优解就是i+1到j-1的最优解在加上i和j。如果不同，则比较i+1到j，和i到j-1，看哪个更长。

2.写出递推公式

f(i, j)表示i到j内的最优解（包括i和j）

f(i, j) = 1 //if i == j
          2 + f(i+1, j-1) //if word[i] = word[j]
          max(f(i+1, j), f(i, j-1)) //if word[i] != word[j]

3.算法实现

参考[github](https://github.com/otnt/CodeChallenge/blob/master/Algorithm/DynamicProgramming/LongestPalindromeSubsequence.java)

4.反推最优结果

这个非常直观，在维护最优解的长度时，同时维护具体内容即可。

s(i, j) = word[i] //if i == j
          word[i] + s(i+1, j-1) + word[j] //if word[i] = word[j]
          max(s(i+1, j), s(i, j-1)) //if word[i] != word[j]

5.优化

空间复杂度可优化到O(N)，当前是O(N^2)

