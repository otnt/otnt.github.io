---
layout:     post
title:      "一道题分析动态规划"
subtitle:   ""
date:       2016-04-29 11:50 
author:     "Pufan Jiang"
header-img: "img/post-bg.jpg"
tags:
    - Algorithm
    - Dynamic Programming
---

动态规划（Dynamic Programming）是面试算法常见考点。能够同时考察抽象总结以及归纳能力（需要计算递推公式，要知道递推在美国人眼里是很高级的技巧），以及coding的能力（动态规划一般要设计二维数组，以及复杂容易出错的index）。

这篇博客，我试图通过求解Leetcode经典题目，[Best Time to Buy and Sell Stock IV](https://leetcode.com/problems/best-time-to-buy-and-sell-stock-iv/), 来分析一下DP的总体思路。欢迎拍砖。

## 背景

一句话总结，动态规划是一个算法技巧，要解决大而复杂的问题，先解决小一点简单一点的问题，直到最简单的情况是可以直接得出结果，那么就能一步步反推出最终答案。

听着和Conquer and Division很像，他们的差别是：

1. C&D一般是递归做法，DP一般是迭代做法
2. C&D一般对应二分，而DP一般对应递推。

## DP几大要素：

个人经验，认为DP有以下要素：

1. 识别DP
2. 找递推关系
3. 边界划分
4. 初始化
5. 例子验算
6. 优化

#### 识别DP

引自九章算法：

如果题目目的是求最大值，最短距离，路径数量 etc. 而非求具体组合，具体点，每一条路径，那么很可能是DP。（求某一个组合，可能是DP+backtracking，求所有组合，则一般不是DP）

#### 找递推关系

递推关系没有固定的套路，但简单地说有两种，一种是从头开始递推，一种是从尾部开始递推。思考的时候都要想到。

从头开始递推例子：Best Time to Buy and Sell Stock [1](https://leetcode.com/problems/best-time-to-buy-and-sell-stock/), [3](https://leetcode.com/problems/best-time-to-buy-and-sell-stock-iii/), [4](https://leetcode.com/problems/best-time-to-buy-and-sell-stock-iv/)

从尾部开始递推例子: [Best Time to Buy and Sell Stock with Cooldown](https://leetcode.com/problems/best-time-to-buy-and-sell-stock-with-cooldown/)

另一点是必须把递推关系写出来，可以从中找优化，并且可以帮助写code。

#### 边界划分

边界划分是分析，如果dp[k][i]表示第k层dp，位置从0到i范围，求取得到的最大值/最短距离 etc， 那么这个i表示的是什么。是一定要用到第i个数字吗，还是只需要是这个范围内的最大值。

具体体验可以做 best stock [4](https://leetcode.com/problems/best-time-to-buy-and-sell-stock-iv/), 以及括号匹配数量(链接待补充)。

#### 初始化

顾名思义，最开始的值是多少。一般会有一行、一列辅助值，帮助初始化。

#### 例子验算(重要)

在实际写dp算法时，强烈建议先有一个演算好的例子，这样在写具体代码，尤其是index时，会清晰很多。另外DP常常需要保存中间变量，这个也在例子演算中标示出来会比较好。

#### 优化

这里优化指的是最后一步细节上的优化，总体时间复杂度已经无法再下降了。

常见的优化有：

 - 滚动数组，节省空间
 - 剪枝，提早结束dp过程
 - 特殊情况使用另一种更高效的算法

## 例子分析

如前所述，使用Leetcode经典题目，[Best Time to Buy and Sell Stock IV](https://leetcode.com/problems/best-time-to-buy-and-sell-stock-iv/), 来分析一下DP的总体思路。

#### 识别DP

求最大price，符合DP条件。

#### 找递推关系 & 边界划分

递推关系的思考套路是，如果我已经知道1是怎么样，那么2是怎么样也知道，那么3是什么样也知道 etc

在这里，转化成两个思考问题：

1. 如果我知道只有1笔transaction的结果，能否算出2笔transaction的结果？
2. 如果我知道给定[0, i]范围交易结果，能否算出[0, i+1]的交易结果？

这道题如果研究清楚这两个递推关系，就算解决问题。

*1笔transaction推导2笔transaction*

不难想到，如果我们知道[0, 1], [0,2], ... , [0, i]的1笔transaction的交易结果，那么[0, i]的2笔transaction的交易结果，就是[0,1] - price[1]+price[i], …, [0, i-1] - price[i-1]+price[i]中的最大值。

*[0, i]推导[0, i+1]*

这个只要思考1笔transaction时是怎么样，其他情况类似。也不难想到，这个就是price[i+1] - min(price[0...i])和[0, i]中取较大值。

关于边界划分，这里我当时犯了个错误，导致耽误了不少时间。就是[0, i]是表示必须以price[i]卖出呢，还是给定price[0, i]算出一个最大值，即[0, i]是一个单调递增序列。

通过上面的结论我们已经得出，应该是第二种情况，但是实际思考时，都要想一下。

另外值得一提，这道题要求是最多交易K笔，所以算出2笔transaction的结果，实际上表示是最多2笔transaction的结果，即如果1笔的结果更高，就保留1笔。

最后推导递推公式。（实际上，这一步可以在例子验算之后进行）

f(k)(i) = max(f(k)(i-1), max(f(k-1)(j)-price[j]+price[i]) where j=0...i-1)

这里通过递推公式我们发现，每次计算f(k)(i) 一个0到i-1的j合集，这导致复杂度上升一个数量级。但是仔细观察，我们可以发现max(f(k-1)(j)-price[j]+price[i])中price[i]这一项是不变量，可以提取出来。即

f(k)(i) = max(f(k)(i-1), price[i] + max(f(k-1)(j)-price[j]) where j=0...i-1)

而max(f(k-1)(j)-price[j]) 这一项是可以在遍历时候维护的，因此每个f(k)(i)的计算复杂度为O(1)。

总的时间复杂度为O(kN)


#### 例子验算

例子验算对DP非常重要:
 - 验证正确性
 - 将coding过程直观化

我们以[lintcode上的股票例子](http://www.lintcode.com/zh-cn/problem/best-time-to-buy-and-sell-stock-iv/)为例:

[4,4,6,1,1,4,2,5] k = 2, ans = 6
 
这是price list

[]()|   |   |   |   |   |   |   |
 ---|---|---|---|---|---|---|---|
  4 | 4 | 6 | 1 | 1 | 4 | 2 | 5 |

这里每行k每列i是交易k次，并且给定[0, i]的price list，最多能成多少钱。

另外根据上面的分析，我们需要一个变量（maxSub）来保存max(f(k-1)(j)-price[j])

回顾递推公式：f(k)(i) = max(f(k)(i-1), price[i] + max(f(k-1)(j)-price[j]) where j=0...i-1)


|i=0|i=1|i=2|i=3|i=4|i=5|i=6|i=7|
|---|---|---|---|---|---|---|---|
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
|0 maxSub = -4|0 maxSub = -4|2 maxSub = -4| 2 maxSub = -1 | 2 maxSub = -1 | 3 maxSub = -1 | 3 maxSub = -1 | 4 maxSub = -1 |
|0 maxSub = -4|0 maxSub = -4|2 maxSub = -4| 2 maxSub = 1 | 2 maxSub = 1 | 5 maxSub = 1 | 5 maxSub = 1 | 6 maxSub = 1 |

通过这个例子验算，我们在具体coding的时候，更容易写出bug free的代码。

#### 初始化

这题有三个初始化，前两个是k为0的时候，以及i为0的时候 dp矩阵的值。不难理解都应该是0.

另一个更重要的是maxSub的初始化，由于交易至少需要2个记录，因此i=0的时候可以算作买入的初始化。这样每次i从1开始遍历，而不是从0开始。

#### 优化

本体可以有不少优化。

1. 滚动数组

由于每次只需要上一行的值，因此保留两行即可。（没有实现这个优化，建议可以用两个arraylist，每次结束后指针互换）

2. 剪枝

如果发现dp[k][7] < dp[k-1][7],则可以结束。因为多了一笔交易不会变好，再多一笔也无济于事。

3. 特殊情况

这个是被leetcode逼的，不得不说leetcode的检测数据比lintcode不知道高到哪里去了。

当K非常大，大到比price数量还多的时候，完全可以用[任意次交易算法](https://leetcode.com/problems/best-time-to-buy-and-sell-stock-iii/) 来O(N)时间完成。

## 总结

写了这么多，也只是举了一个栗子，具体还要多多体会。

总结DP思路：

1. 发现是DP（成功的开始）
2. 初步寻找递推关系和边界条件。思考并写出递推关系式子。注意，这一步不要求最优，如果只是一些地方需要反复扫描，导致O(N)变成O(N^2)完全没问题。(进入DP大门)
3. 演算，验证递推关系的正确性。
4. 核心优化。如果第二步的推导不是最优，比如有明显的反复扫描，就要思考能不能把这个过程抹去，常见的是在扫描的过程中维护若干变量。(DP优化难点，面试的重点)
5. 补充演算，验证优化的正确性。
6. coding
7. 优化


