---
title: "coursera 機械学習 3週目"
slug: "coursera-machine-learning-week3"
date: 2017-11-03T05:12:38Z
---

ロジスティック回帰モデル(Logistic Regression Model)
===================================================

分類
----

メール受け取った時、そのメールがスパムか否かを判断するようなことを分類問題という。

スパムの場合は$1$、スパムではない場合は$0$としする。

$0.5$より大きいすべての予測を$1$としてマッピングし、$0.5$未満をすべて0にマッピングする。

$$
h\_{ \theta }(x) \geqq 0.5 \to y = 1
$$

$$
h\_{ \theta }(x) \lt 0.5 \to y = 0
$$

このように$0$か$1$かのような分類するような問題に、線形回帰を用いて分類を行ったとして、直線への当てはまりが悪くうまくいかない。

そこで、仮説関数$h(x)$が$0 \leqq h(x) \leqq 1$となるような変形を行う。

ロジスティック回帰(Logistic Regression )による仮説関数の表現
------------------------------------------------------------

線形回帰の仮説関数は、$\theta$の転置行列にベクトル$\boldsymbol{ X }$を掛けたものであった。

$$
h(x) = \theta^{ \mathrm{ T } } \boldsymbol{ X }
$$

__ロジスティック回帰(Logistic regression)__の仮説関数は、$\theta$の転置行列にベクトル$\boldsymbol{ X }$を掛けたものをシグモイド関数(sigmoid function)に代入したものになる。

$$
h\_{ \theta }(x) = g(\theta^{ \mathrm{ T } } \boldsymbol{ X })
$$

シグモイド関数は下記のように表現される。

$$
g(z) = \frac{ 1 }{ 1 + e^{ -z } }
$$

シグモイド関数を使った仮定関数は下記のように表現される。
$$
h\_{\theta}(x) = g(\theta^{ \mathrm{ T } } \boldsymbol{ X }) = \frac{ 1 }{ 1 + e^{ -(\theta^{ \mathrm{ T } } \boldsymbol{ X }) } }
$$

スパムか否かを表現すると、

$$
スパムとなるのは(y = 1)、h\_{ \theta }(x) \geqq 0.5 、\theta^{ \mathrm{ T } } \boldsymbol{ X } \geqq 0 の時
$$

$$
スパムではないのは(y = 0)、h\_{ \theta }(x) \lt 0.5 、\theta^{ \mathrm{ T } } \boldsymbol{ X } \lt 0 の時
$$

のように表現される。

決定境界
--------

決定境界は、y = 0およびy = 1の領域を区切る線である。これは仮説関数によって作成される。

目的関数が下記として
$$
h_{ \theta }(x) = \theta_0 + \theta_1 x_1 + \theta_2 x_2
$$

$\theta$が分かっているとする。

$$\theta = \begin{pmatrix}5 \\\ -1 \\\ 0\end{pmatrix}$$

$h_{ \theta }(x)$に$\theta$を代入すると、

$$
\begin{align}
\theta_0 + \theta_1 x_1 + \theta_2 x_2
&= 5 + -1*x_1 + 0*x_2 \\\\\\
&= 5 + -x_1
\end{align}
$$

となり

$$
x_1 \leqq 5 の時、y = 1
$$

$$
x_1 \gt 5 の時、y = 0
$$

となる。

コスト関数
----------

__ロジスティック回帰(Logistic Regression )__のコスト関数(Cost function)は下記のように定義される。

$$
J(\theta) = \dfrac{1}{m} \sum\_{i=1}^m \mathrm{Cost}(h\_\theta(x^{(i)}),y^{(i)})
$$

$$
\begin{eqnarray}
Cost(h\_{ \theta }(x), y)
 =
  \begin{cases}
    -\log (h\_{\theta}(x)) & \text{if y = 1} \newline
    -\log (1 - h\_{\theta}(x)) & \text{if y = 0}
  \end{cases}
\end{eqnarray}
$$

このコスト関数は下記のような特徴がある。

* $y = 1$ の時
 * $h\_{ \theta }(x)$ が $0$ に近づくにつれコスト関数は無限に増大する
 * $h\_{ \theta }(x)$ が $1$ に近づくにつれコスト関数は0に近づく
* $y = 0$ の時
 * $h\_{ \theta }(x)$ が $0$ に近づくにつれコスト関数は0に近づく
 * $h\_{ \theta }(x)$ が $1$ に近づくにつれコスト関数は無限に増大する

このコスト関数を1つの式で表現すると下記のようになる。

$$
J(\theta) = - \frac{1}{m} \displaystyle \sum\_{i=1}^m [y^{(i)}\log (h\_\theta (x^{(i)})) + (1 - y^{(i)})\log (1 - h\_\theta(x^{(i)}))]
$$

ベクトル化された実装は次のとおり。

$$
\begin{align\*} & h = g(X\theta)\newline & J(\theta) = \frac{1}{m} \cdot \left(-y^{T}\log(h)-(1-y)^{T}\log(1-h)\right) \end{align\*}
$$

最急降下法
----------

線形回帰と同様。

$$
\begin{align\*}& Repeat \; \lbrace \newline & \;
\theta_j := \theta_j - \alpha \dfrac{\partial}{\partial \theta_j}J(\theta) \newline &
\rbrace\end{align\*}
$$

コスト関数を偏微分して展開すると下記のように表現できる。

$$
\begin{align\*} & Repeat \; \lbrace \newline & \; \theta\_j := \theta\_j - \frac{\alpha}{m} \sum_{i=1}^m (h\_\theta(x^{(i)}) - y^{(i)}) x\_j^{(i)} \newline & \rbrace \end{align\*}
$$

ベクトル化した実装は下記のとおり。

$$
\theta := \theta - \frac{\alpha}{m} X^{T} (g(X \theta ) - \vec{y})
$$

コスト関数の最適化アルゴリズム
------------------------------

最急降下法の他にもコスト関数を最小化するアルゴリズムがある。

- 共役勾配法(Conjugate gradient)
- BFGS法(BFGS)
- L-BFGS法(L-BFGS)

これらのアルゴリズムは、最急降下法と比較して下記のような特徴がある。

- $\alpha$を自分で選ぶ必要がない
- 最急降下法より速く収束する

複数クラス分類(Multiclass Classification)
=========================================

分類するクラスが複数になる場合、__One-vs-all__と方法を使って分類を行う。

__One-vs-all__は、1つのクラスを選択して、

- 選択したクラス
- 他のクラス

といった分類を行う__ロジスティック回帰(Logistic Regression )__$h\_{ \theta }^{ (i) }(x)$を適用する。これをクラスがn個あれば、n回行う。__ロジスティック回帰(Logistic Regression )__もn個作成して、これを全て適用し、このうち最も高い値を返したものを予測として使用する。

過学習(Overfitting)
===================

過学習の問題
------------

特定のデータセットに特化しすぎて、その結果、正確な予測ができなくなくなる状態のことを__過学習(Overfitting)__という。

回帰分析では、説明変数(feature)$x$の次数を増やせばデータへのフィット感がよくなるが、フィット感を良くしようと、説明変数(feature)$x$が多くしすぎると、仮説関数の精度が落ちる。

ちなみに、フィット感が足りない状態のことを__未学習(Underfitting)__といい、関数が単純すぎるか、説明変数(feature)$x$の次数が足りない場合に発生する。

__過学習(Overfitting)__を解決する方法は2つある。

* 説明変数(feature)の数を減らす
* 正則化

正則化したコスト関数
--------------------

正則化とは、$\theta$の値を小さくすれば、説明変数(feature)$x$による影響を小さくでき、__過学習(Overfitting)__しにくくするといった手法である。

正則化したコスト関数は下記のように定義される

$$
min\_\theta\ \dfrac{1}{2m}\  \sum\_{i=1}^m (h\_\theta(x^{(i)}) - y^{(i)})^2 + \lambda\ \sum\_{j=1}^n \theta\_j^2
$$

$\lambda$が大きすぎると、コスト関数を最小化するためには$\theta$の値を小さくする必要があり、結果$\theta$が$0$に近づくため、__未学習(Underfitting)__が発生する。

正則化した線形回帰(Regularized Linear Regression)
-------------------------------------------------

最急降下法(Gradient Descent)は下記のとおり。

$$
\theta\_j := \theta\_j(1 - \alpha\frac{\lambda}{m}) - \alpha\frac{1}{m}\sum\_{i=1}^m(h\_\theta(x^{(i)}) - y^{(i)})x\_j^{(i)}
$$

正規方程式(Normal Equation)は下記のとおり。

$$
\begin{align\*}& \theta = \left( X^TX + \lambda \cdot L \right)^{-1} X^Ty \newline& \text{where}\ \ L = \begin{bmatrix} 0 & & & & \newline & 1 & & & \newline & & 1 & & \newline & & & \ddots & \newline & & & & 1 \newline\end{bmatrix}\end{align\*}
$$

正則化したロジスティック回帰(Regularized Logistic Regression)
-------------------------------------------------------------

コスト関数は下記のとおり。

$$
J(\theta) = - \frac{1}{m} \sum\_{i=1}^m \large[ y^{(i)}\ \log (h\_\theta (x^{(i)})) + (1 - y^{(i)})\ \log (1 - h\_\theta(x^{(i)}))\large] + \frac{\lambda}{2m}\sum\_{j=1}^n \theta_j^2
$$

最急降下法(Gradient Descent)は線形回帰と変わらない。
