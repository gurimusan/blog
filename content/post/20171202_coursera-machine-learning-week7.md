---
title: "coursera 機械学習 7週目"
date: 2017-12-02T14:07:58+09:00
draft: false
---

Large Margin Classification
===========================

Optimization objective
----------------------

ロジスティック回帰のコスト関数は下記であった。

$$
min\_\theta - \frac{1}{m} \sum\_{i=1}^m \large[ y^{(i)}\ \log (h\_\theta (x^{(i)})) + (1 - y^{(i)})\ \log (1 - h\_\theta(x^{(i)}))\large] + \frac{\lambda}{2m}\sum\_{j=1}^n \theta_j^2
$$

この目的関数を最小化するためには、$z=\theta^{T}x$として、下記の条件を満たす$\theta$を学習する必要があった。

- $y=1$のとき、$z \gg 0$
- $y=0$のとき、$z \ll 0$

__サポートベクターマシン(support vector machine, SVM)__のコスト関数では、

- $y=1$の時、$z \gt 1$は$0$
- $y=0$の時、$z \lt 1$は$0$

という前提条件をつける。

ロジスティック回帰のコスト関数との比較をグラフにすると下記のとおり。

$y=1$の時
![](/img/20171202_coursera-machine-learning-week7/svm_1.png)

$y=0$の時
![](/img/20171202_coursera-machine-learning-week7/svm_2.png)

コスト関数は下記のようになる。

$$
min_\theta\ \frac{1}{m} \sum^m\_{i=1} [y^{(i)} cost\_1 (\theta^{\mathrm{T}} x^{(i)}) + (1 - y^{(i)}) cost\_0 (\theta^{\mathrm{T}} x^{(i)})] + \frac{\lambda}{2m} \sum^n\_{i=1} \theta^2\_j
$$

$C=\frac{\lambda}{m}$とすると

$$
min_\theta\ C \sum^m\_{i=1} [y^{(i)} cost\_1 (\theta^{\mathrm{T}} x^{(i)}) + (1 - y^{(i)}) cost\_0 (\theta^{\mathrm{T}} x^{(i)})] + \frac{1}{2} \sum^n\_{i=1} \theta^2\_j
$$

このコスト関数は上記の前提条件

- $y=1$の時、$z \gt 1$は$0$
- $y=0$の時、$z \lt 1$は$0$

を踏まえて考えると

- $y^{(i)}=1$の時、$\theta^{T}x^{(i)} \geq 1$なら、$cost\_1=0$
- $y^{(i)}=0$の時、$\theta^{T}x^{(i)} \leq -1$なら、$cost\_0=0$

となり、この条件み満たすと第1項の$C$がついた項は$0$になるので、最小化問題で解くのは第2項のみでよくなる。

$$
min\_\theta\ \frac{1}{2}\sum\_{i=1}^{n}\theta\_{j}^{2} \\\\\\
s.t. \hspace{15pt} \theta^{\mathrm{T}}x^{(i)} \ge 1 \hspace{10pt} if \hspace{5pt}y^{(i)} = 1 \\\\\\
\hspace{30pt} \theta^{\mathrm{T}}x^{(i)} \le -1 \hspace{10pt} if \hspace{5pt}y^{(i)} = 0
$$

Large Margin Intuition
----------------------

決定境界(Decision Boundary)との距離をマージンという。

__SVM(サポートベクターマシン)__は、決定境界と各サンプルとの距離を最大化する$\theta$を選ぶことになる。

$C$の値が大きすぎると、1つの例外的なサンプルに合わせて、決定境界を過剰に変更しようとするが、$C$が適度な大きさであれば、最適な決定境界のままとなる。


Mathematics Behind Large Margin Classification
----------------------------------------------

ベクトルの内積は下記のように表現される。

$$
\vec{x} \cdot \vec{y} = \|x\|\|y\|\cos \theta
$$

上記の意味的には、「ベクトル$\vec{x}$の長さ」と「ベクトル$\vec{y}$をベクトル$\vec{x}$に射影したもの長さ」の積である、ということである。

ベクトル$\vec{x}$とベクトル$\vec{y}$のなす角が$90^{\circ}$の場合は下記のようになる。

$$
\vec{x} \cdot \vec{y} = \|x\|\|y\|\cos 90^{\circ} = \|x\|\|y\|
$$

__SVM(サポートベクターマシン)__の目的関数は$\theta$の数は2つだけだとすると下記のように表現できる。

$$
\frac{1}{2}\sum\_{i=1}^{2}\theta\_{j}^{2} = \frac{1}{2}(\theta\_{1}^{2} + \theta\_{2}^{2}) = \frac{1}{2}(\sqrt{\theta\_{1}^{2} + \theta\_{2}^{2}})^{2} = \frac{1}{2}\|\|\theta\|\|^{2}
$$

つまり、ベクトル$\vec{\theta}$の長さの2乗を最小化することを意味する。

$$
min\_\theta\ \frac{1}{2}\sum\_{i=1}^{n}\theta\_{j}^{2} = \frac{1}{2}\|\|\theta\|\|^{2} \\\\\\
s.t. \hspace{15pt} \theta^{\mathrm{T}}x^{(i)} \ge 1 \hspace{10pt} if \hspace{5pt}y^{(i)} = 1 \\\\\\
\hspace{30pt} \theta^{\mathrm{T}}x^{(i)} \le -1 \hspace{10pt} if \hspace{5pt}y^{(i)} = 0
$$

次に条件について理解を深めていく。

$$
\theta^{\mathrm{T}}x^{(i)} \ge 1 \hspace{10pt} if \hspace{5pt}y^{(i)} = 1 \\\\\\
\theta^{\mathrm{T}}x^{(i)} \le -1 \hspace{10pt} if \hspace{5pt}y^{(i)} = 0
$$

$\theta^{\mathrm{T}}x^{(i)}$はベクトル$\vec{\theta}$とベクトル$\vec{x^{(i)}}$の内積で、ベクトル$\vec{x^{(i)}}をベクトル$\vec{\theta}$を射影した長さを$p^{(i)}$とすると下記のように書ける。

$$
\theta^{\mathrm{T}} x^{(i)} = p^{(i)}||\theta||
$$

つまり条件は下記のように書ける。

$$
p^{(i)}||\theta|| \ge 1 \hspace{10pt} if \hspace{5pt}y^{(i)} = 1 \\\\\\
p^{(i)}||\theta|| \le -1 \hspace{10pt} if \hspace{5pt}y^{(i)} = 0
$$

目的関数$\frac{1}{2}\sum\_{i=1}^{n}\theta\_{j}^{2}$を最小化するためには、$\theta$を大きくするわけにはいかず、$p^{(i)}$を大きくする必要がある。

投射の長さ$p^{i}$は決定境界(Decision Boundary)との距離で、つまりはマージン最大化することになる。

Kernels
=======

KernelsⅠ
---------

__サポートベクターマシン(support vector machine, SVM)__では、__カーネル(Kernel)__を使うことで非線形分類を行うことが可能になる。

カーネル(Kernel)を使うと、2つの点の類似度(similarity)を計算することができる。

比較を行うための点$l^{(i)}$を__ランドマーク(landmark)__と呼ぶ。

今回は__ガウシアンカーネル(Gaussian Kernel)__という手法を使う。

__ガウシアンカーネル(Gaussian Kernel)__は下記のように定義される。

$$
f\_{i} = similarity(x,l^{(i)}) = exp(- \frac{\|\|x - l^{(i)}\|\|^2}{2\sigma^{2}})
$$

この関数は、$x$と$l^{i}$の距離が大きい場合$0$に近い値になり、距離が小さい場合は$1$に近い値になる。

$$
\begin{cases}
exp(- \frac{\|\|x - l^{(i)}\|\|^2}{2\sigma^{2}}) \approx 1 & (x \approx l^{(i)}) \\\\\\
exp(- \frac{\|\|x - l^{(i)}\|\|^2}{2\sigma^{2}}) \approx 0 & (x\ far\ from\ l^{(i)})
\end{cases}
$$

目的関数は、説明変数$x$を__カーネル(Kernels)__で計算した新たな説明変数$f\_{i}$を使って下記のようになる。

$$
\theta\_{0} + \theta\_{1}x\_{1} + \theta\_{2}x\_{2} + ... + + \theta\_{i}x\_{i}
$$

KernelsⅡ
---------

$__ランドマーク(landmark)__l^{i}$はトレーニングデータをそのまま使う。つまり、$l^{1}=x^{1}$, $l^{2}=x^{2}$,...,$l^{m}=x^{m}$となる。

__サポートベクターマシン(support vector machine, SVM)__と__カーネル(Kernels)__を組み合わせると、コスト関数は下記のように書ける。

$$
min_\theta\ C \sum^m\_{i=1} [y^{(i)} cost\_1 (\theta^{\mathrm{T}} f^{(i)}) + (1 - y^{(i)}) cost\_0 (\theta^{\mathrm{T}} f^{(i)})] + \frac{1}{2} \sum^n\_{i=1} \theta^2\_j \\\\\\
s.t. \hspace{15pt} \theta^{\mathrm{T}}f^{(i)} \ge 1 \hspace{10pt} if \hspace{5pt}y^{(i)} = 1 \\\\\\
\hspace{30pt} \theta^{\mathrm{T}}f^{(i)} \le -1 \hspace{10pt} if \hspace{5pt}y^{(i)} = 0
$$

各パラメータについての特徴。

パラメータ$C$は下記のような特徴がある。

- $C(=\frac{1}{\lambda})$が大きい時、偏り(bias)が小さくなり、分散(variance)が大きくなる。
- $C(=\frac{1}{\lambda})$が小さい時、偏り(bias)が大きくなり、分散(variance)が小さくなる。

パラメータ$\sigma^{2}$は下記のような特徴がある。

- $\sigma^{2}$が大きい時, 説明変数$f\_{i}$はなめらかになる。つまり、偏り(bias)が大きくなり、分散(variance)が小さくなる。
- $\sigma^{2}$が小さき時, 説明変数$f\_{i}$はなめらかではなくなる。つまり、偏り(bias)が小さくなり、分散(variance)が大きくなる。

SVMx in Practice
================

Using An SVM
------------

__線形カーネル(Linear Kernel, SVM withouot a Kernel)__と__ガウシアンカーネル(Gaussian Kernel)__がよく使われる。

それ以外のカーネルは下記のとおり。

- 多項式カーネル(Polynomial Kernel)
- 文字カーネル(String Kernel)
- カイの2乗カーネル(chi-square Kernel)
- ヒストグラムカーネル(histogram intersection Kernel)

どのアルゴリズムを使うべきか？

$n$を説明変数うの数、$m$をトレーニングセットの数だとすると

- $n$が大きい場合(n >=m, n=10000, m=1-1000)は、ロジスティック回帰、またはカーネルなしSVM(SVM without Kernel)
- $n$が小さく$m$が中間くらいの大きさの時(n=1-1000, m=10-10000)は、ガウシアンカーネルを使ったSVM(SVM with Gaussian Kernel)
- $n$が小さく$m$が大きい時(n=1-1000, m=50000+)は、より説明変数を加えた上で、ロジスティック回帰か、カーネルなしSVM(SVM without Kernel)
- ニューラルネットワークは上記のほとんどでうまくいく可能性があるが、トレーンニングが遅くなる可能性がある
