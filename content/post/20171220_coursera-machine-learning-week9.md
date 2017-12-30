---
title: "coursera 機械学習 9週目"
slug: "coursera-machine-learning-week9"
date: 2017-12-11T13:33:15+09:00
draft: true
---

異常検知(Anomaly Detection)
===========================

密度推定(Density Estimation)
----------------------------

### 動機(Problem Motivation)

航空会社の製作者

エンジンの製作

QAしているとき

熱
振動

がフューチャーだとる。

 m個のエンジンを作った。


あのまりー検出は下記のような感じ。

テストをいくつかもつ。


### 正規分布(Gaussian Distribution)

### 異常検出のアルゴリズム(Algorithm)

1. 説明変数を見つける
2. $\mu\_{j} = \frac{1}{m} \sum\_{j=1}^{m}x\_{j}^{(i)}(\mu\_{1},...,\mu\_{n})$、$\sigma\_{j}^{2} = \frac{1}{m}\sum\_{i=1}^{m}(x\_{j}^{(i)}-\mu\_{j})^2(\sigma\_{1}^{2},...,\sigma\_{n}^{2})$を求める
3. $p(x) = \Pi^{n}\_{j=1} p(x\_j; \mu\_j, \sigma^2\_j) = \Pi^n\_{j=1} \frac{1}{\sqrt{2\pi} \sigma\_j} exp(-\frac{(x\_j - \mu\_j)^2}{2\sigma\_j^2})$を求める
4. $p(x) \lt \epsilon$なら異常

Building an Anomaly Detection System
-------------------------------------

### Developing and Evaluating an Anomaly Detection System

異常検知アルゴリズムの評価はどのように行えばよいだろうか？

10000のデータセットがあって、このうち20があのまりーだとする。

トレーニングセットを6000, CVを2000(内10がアノマリー)、テストセットを2000（内10があのまりー）というふうに6:2:2で分ける。

トレーニングセットを使って、正規分布の異常検出アルゴリズムモデルを作成する。

CVとテストセットで評価を行う。

$$
y = 1 (if p(x) \lt ε)
y = 0 (if p(x) \gte ε)
$$

上記の分類精度で評価を行うことは良い評価ではない。

なぜなら、歪んだデータだからだ。

なのでFスコアを使う。

### Anomaly Detection vs. Supervised Learning

なぜ、教師なし学習を使うのか？

異常データが少ない場合は、教師あり学習だと、異常である特徴を表現できないため、教師なし学習。

異常データが多い（正常と同数）の場合は、教師あり学習。

### 仕様する説明変数の選択(Choosing What Features to Use)

多変量正規分布(Multivariate Gaussian Distribution)
--------------------------------------------------

### 多変量正規分布(Multivariate Gaussian Distribution)

### 多変量ガウス分布を用いた異常検出(Anomaly Detection using the Multivariate Gaussian Distribution)

レコメンダーシステム(Recommender Systems)
=========================================

映画の評価を予測する(predicting movie ratings)
----------------------------------------------

### 定式化(problem formulation)

機械学習の重要な適用例として、レコメンダーシステムを学習する。

また、レコメンダーシステムを学ぶことで、これまで学習した内容の全体的な復習をする。

例として、ユーザが映画に対して0〜5段階の評価を行うシステムを考える。

映画に対する各ユーザの評価は下記のとおり。

| Movie/User            | Alice | Bob   | Carol | Dave  |
|:---------------------:|:-----:|:-----:|:-----:|:-----:|
| Love at last          | 5     | 5     | 0     | 0     |
| Romance forever       | 5     | ?     | ?     | 0     |
| Cute puppies of love  | 5     | 4     | 0     | 4     |
| Nonstop car chases    | 0     | 0     | 5     | 4     |
| Swords vs. karate     | 0     | 0     | 5     | ?     |

ここで、下記のような変数の定義を行う。

$$
n\_{u} = ユーザ数 \\\\\\
n\_{m} = 映画の数 \\\\\\
r(i, j) = 1の場合ユーザjは映画iを評価している \\\\\\
y(i, j) = ユーザjの映画iへの評価
$$

この例だと

- $n\_{u} = 4$
- $n\_{m} = 5$
- $r(i=3, j=3) = 1$
- $y(i=3, j=3) = 5$

となる。


### コンテンツベースのレコメンデーション(Content Based Recommendations)

協調フィルタリング(Collaborative Filtering)
-------------------------------------------

### 協調フィルタリング(Collaborative Filtering)

### 協調フィルタリング アルゴリズム(Collaborative Filtering Algorithm)

低ランク行列分解(Low Rank Matrix Factorization)
-----------------------------------------------

### ベクトル化: 低ランク行列分解(Vectorization: Low Rank Matrix Factorization)

### 実装の詳細: 平均正規化(Implementational Detail: Mean Normalization)
