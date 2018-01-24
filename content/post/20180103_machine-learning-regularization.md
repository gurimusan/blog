---
title: "機械学習 正則化"
slug: "machine-learning-regularization"
date: 2018-01-03T01:26:12+09:00
draft: true
---

正則化(Regularization)
======================

正則化は回帰モデルの過学習を防ぎ、汎化能力を高めるために使われる、回帰モデルに対して追加の項を導入する手法である。正則化項は次の式で与えられる。

$$
\lambda \frac{1}{p} \|\Theta\|\_{p}^{p} = \lambda \frac{1}{p} \sum\_{j}^{n} |\theta\_{j}|^{p}
$$

$\Theta$はパラメータベクトルで、$\|\cdot\|\_{p}$はL1ノルム($p=1$)やL2ノルム($p=2$)などである。$\lambda$は正の定数となるハイパーパラメータで、大きくするほど正則化の効果が強くなる。

機械学習において最も一般的なのは、$p=1$の時の__L1正則化__と$p=2$の時の__L2正則化__などである。線形回帰モデルに利用した場合は、L1の場合は__ラッソ回帰(Lasso Regression)__、L2の場合は__リッジ回帰(Ridge Regression)__と呼ぶ。

リッジ回帰(Ridge Regression)
----------------------------

コスト関数に正則化項を足したものを下記のように定義する。

$$
J(\theta) = \frac{1}{2m} \sum\_{i=1}^{m}(h\_{\theta}(x^{(i)}) - y^{(i)})^{2} + \lambda \frac{1}{2} \sum\_{j}^{n} |\theta\_{j}|^{2}
$$

コスト関数を$\theta$で偏微分すると、リッジ回帰はパラーメータに比例した分だけ、0に近づけることに意味する。

$$
\frac{\partial J(\theta)}{\partial \theta\_{j}} = \frac{1}{m} \sum\_{i=1}^{m}(h\_{\theta}(x^{(i)}) - y^{(i)})x^{(i)} + \lambda \theta\_{j}
$$

ラッソ回帰(Lasso Regression)
----------------------------

__リッジ回帰(Ridge Regression)__と同様にコスト関数に正則化項を足したものを下記のように定義する。

$$
J(\theta) = \frac{1}{2m} \sum\_{i=1}^{m}(h\_{\theta}(x^{(i)}) - y^{(i)})^{2} + \lambda \sum\_{j}^{n} |\theta\_{j}|
$$

__リッジ回帰(Ridge Regression)__と同様に$\theta$で偏微分したいところだが、正則化項が$\theta$で偏微分できない。座標降下法(Coordinate Descent)といった推定アルゴリズムを使って解くらしいが、ここではその結果を下記に記す。

$$
\frac{\partial J(\theta)}{\partial \theta\_{j}} = \frac{1}{m} \sum\_{i=1}^{m}(h\_{\theta}(x^{(i)}) - y^{(i)})x^{(i)} + \lambda sgn(\theta\_{j})
$$

__ラッソ回帰(Lasso Regression)__を使用すると、いくつかのパラメータを$0$にすることができる。こういった行列をスパースモデルといい、高速な計算が可能になる。
