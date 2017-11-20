---
title: "coursera 機械学習 5週目"
date: 2017-11-19T13:20:28+09:00
draft: false
---

ニューラルネットワーク(Neural Network)のコスト関数
==================================================

ロジスティック回帰のコスト関数は下記のように定義された。

$$
J(\theta) = - \frac{1}{m} \sum\_{i=1}^m \large[ y^{(i)}\ \log (h\_\theta (x^{(i)})) + (1 - y^{(i)})\ \log (1 - h\_\theta(x^{(i)}))\large] + \frac{\lambda}{2m}\sum\_{j=1}^n \theta_j^2 \\\\\\
$$

ニューラルネットワークのコスト関数は下記のように定義される。

$$
J(\Theta) = - \frac{1}{m} \large[ \sum\_{i=1}^m \sum\_{k=1}^K y\_{k}^{(i)} \log (h\_\theta (x^{(i)}))\_k + (1 - y^{(i)})\ \log (1 - (h\_\theta(x^{(i)}))_k) \large] + \frac{\lambda}{2m} \sum\_{l=1}^{L-1} \sum\_{i=1}^{s\_l}\sum\_{j=1}^{s\_l + 1}(\Theta\_{ji}^{(l)})^2 \\\\\\
L: レイア数 \\\\\\
s\_l: l層におけるユニット数
$$

バックプロパゲーション(Backpropagation)
=======================================

次に、線形回帰やロジスティック回帰と同様に、コスト関数を最小化することを考える。

これは、以下のように各レイアの重み$\Theta$の各要素で$J(\Theta)$を偏微分したもので表される。

$$
\dfrac{\partial}{\partial \Theta_{i,j}^{(l)}}J(\Theta)
$$

この偏微分を実行するために、__バックプロパゲーション(Backpropagation)__というアルゴリズムがある。

__バックプロパゲーション(Backpropagation)__の手順は下記のとおり。

* $\Delta\_{ij}^{(l)} = 0$で初期化(全てのi,j,l)
* レイア1の$a^{(1)}$を$a^{(1)} = x^{(i)}$とする($x^{(i)}$は入力値)
* __フォアワードプロパゲーション(Forwardpropagation)__で$a^{(l)} = g(z^{(l)}) = g(\Theta^{(l-1)}a^{(l-1)})$を求める
* L層の誤差、$\sigma^{(L)} = a^{(L)} - y^{(t)}$を求める
* L層より前の各レイアの誤差、$\sigma^{(l)} = ((\Theta^{(l)})^{\mathrm{ T }} \sigma^{(l+1)}) .* a^{(l)} .* (1 - a^{(l)})$
 * $a^{(l)} .* (1 - a^{(l)}$ は $g(z^{(l)})$を微分した値なので$g'(z^{(l)}) = a^{(l)} .* (1 - a^{(l)}$
* 偏微分値の更新$\Delta_(ij)^{(l)} := \Delta\_(ij)^{(l)} + a\_{j}^{l}\delta\_{i}^{l+1}$

最終的な偏微分の値は、$\Delta$の平均をとって正則したもので、下記のようになる。

$$
\begin{cases}
D^{(l)}\_{i,j} := \dfrac{1}{m}\left(\Delta^{(l)}\_{i,j} + \lambda\Theta^{(l)}\_{i,j}\right) & (j \ge 1) \\\\\\
D^{(l)}\_{i,j} := \dfrac{1}{m}\Delta^{(l)}\_{i,j} & (j = 1)
\end{cases}
$$

$$
D^{(l)}\_{i,j} := \dfrac{1}{m}\left(\Delta^{(l)}\_{i,j} + \lambda\Theta^{(l)}\_{i,j}\right) (j \ge 1) \\\\\\
$$

Gradient checking
=================

コスト関数$J(\Theta)$の偏微分の近似値と、__バックプロパゲーション(Backpropagation)__で求めた偏微分の値との比較を行うことで、__バックプロパゲーション(Backpropagation)__が機能しているか調べることができる。

$$
gradApprox = \frac {J(\Theta + \epsilon) - J(\Theta - \epsilon)} {2\epsilon} \approx  \dfrac{\partial}{\partial \Theta_{i,j}^{(l)}}J(\Theta)
$$

__Gradient checking__は遅いから、プログラムの検証が終わったら、チェックアルゴリズムは切ること。

ランダム初期化(Random initialization)
=====================================

線形回帰やロジスティクス回帰や$\Theta$を$0$を使って初期化したが、ニューラルネットワークでは機能しない。

$0$で初期化された$\Theta$をニューラルネットワークで利用すると、バックプロパゲーションすると、全てのノードで同じ値に更新されてしまう。

この問題を解決するために、ランダムな値で初期化した$\Theta$を生成し、利用する。

初期化に使われるランダムな値は $[-\epsilon,\epsilon]$ の間の値で生成し、$\Theta$は下記の式を使って初期化する。

```octave
Theta1 = rand(10,11) * (2 * INIT_EPSILON) - INIT_EPSILON;
Theta2 = rand(10,11) * (2 * INIT_EPSILON) - INIT_EPSILON;
Theta3 = rand(1,11) * (2 * INIT_EPSILON) - INIT_EPSILON;
```

まとめ
======

最初に隠れ層のユニット数、出力層のユニット数等のニューラルネットワークのレイアウトを選択する。

* 入力ユニットの数 = 説明変数$x^(i)$の次元
* 出力ユニットの数 = 分類するクラスの数
* 隠れ層のユニットの数 = 多ければ多いほど良いが、計算量が多くなるため、バランスを取るため入力ユニット数と同程度〜4倍程度まで
* 隠れ層の数は最初はは1つで、結果を見て多くしていく。複数の隠れ層がある場合は、全ての隠れ層は同じユニット数となることがオススメ

ニューラルネットワークを実装方法する

* ランダムなｋ値で重み$\Theta$を初期化する
* __フォワードプロパゲーション(Fowardpropagation)__を実装して、入力$x^{(i)}$に対する出力$h\_{\Theta}(x^{(i)})$を求める
* コスト関数を実装して$J(\Theta)$を求める
* __バックプロパゲーション(Backpropagation)__を実装してコスト関数の偏微分$\frac{\delta}{\delta\Theta\_{jk}^{(l)}}$を計算する
* __Gradient checking__を使ってコスト関数$J(\Theta)$の偏微分の近似値を求め、__バックプロパゲーション(Backpropagation)__を使って求めたコスト関数の偏微分$\frac{\delta}{\delta\Theta\_{jk}^{(l)}}$との比較を行い、__バックプロパゲーション(Backpropagation)__が機能していることを確認する
 * 確認できたら__Gradient checking__を切る
* 再急降下法などの勾配法を使って、コスト関数$J(\Theta)$を最小化する重み$\Theta$を求める
