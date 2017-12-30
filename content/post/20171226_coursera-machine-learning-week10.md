---
title: "coursera 機械学習 10週目"
slug: "coursera-machine-learning-week10"
date: 2017-12-19T13:19:51+09:00
draft: false
---

大規模な機械学習(Large Scale Machine Learning)
==============================================

大きなデータセットでの最急降下法(Gradient Descent with Large Datasets)
------------------------------------------------------------------------

### 大きなデータセットでの学習(Learning With Large Datasets)

線形回帰の最急降下法の更新ルールは下記のとおり。

$$
h\_{\theta}(x) = \sum\_{j=0}^{n}\theta\_{j}x\_{x} \\\\\\
J\_{train} = \frac{1}{2m} \sum\_{i=0}^{m} (h\_{\theta}(x^{(i)}) - y^{(i)})^{2} \\\\\\
Repeat \lbrace \\\\\\
\hspace{10pt} \theta\_{j} := \theta\_{j} - \alpha \frac{1}{m} \sum\_{i=1}^{m}(h\_{\theta}(x^{(i)} - y^{(i)}))x\_{j}^{(i)} \\\\\\
\hspace{10pt} (for\ every\ j=0,...,n) \\\\\\
\rbrace
$$

$m=100,000,000$となるトレーニングセットを扱う時、勾配が十分小さな値がとるまで間、最急降下法の1ステップにおいて、1億の和を計算する必要がある。

大規模データを扱う機械学習において、 計算量的にリーズナブルな、または効率的な方法を知りたい。

そこで主に2つのアイディアを紹介する。

1番目は確率的最急降下法(Stochastic Gradient Descent)、2番目はMap Reduceと呼ばれる物だ。

### 確率的最急降下法(Stochastic Gradient Descent)

確率的最急降下法(Stochastic Gradient Descent)は最急降下法の1ステップにおいて、1つのデータのみを扱い、パラメータを更新する手法である。

下記は確率的最急降下法(Stochastic Gradient Descent)のパラメータ更新のルールである。

$$
\theta\_{j} := \theta\_{j} - \alpha (h\_{\theta}(x^{(i)} - y^{(i)}))x\_{j}^{(i)}
$$

1. トレーニングセットをシャッフルして並び替えを行う
2. トレーニングセットの先頭のデータ$x^{(1)}$, $y^{(1)}$を取り出し、それぞれを$x^{(i)}$, $y^{(i)}$に代入する
3. $\theta\_{j} := \theta\_{j} - \alpha (h\_{\theta}(x^{(i)} - y^{(i)}))x\_{j}^{(i)}$でパラメータを更新する
4. トレーニングセットから次のデータを取り出し、それぞれを$x^{(i)}$, $y^{(i)}$に代入して3を実行する、なければ終了する

### ミニバッチ最急降下法(Mini-Batch Gradient Descent)

ミニバッチ最急降下法(Mini-Batch Gradient Descent)は、m個のトレーニングセットをb個に分けて、最急降下法の1stepにおいてb個のデータを使ってパラメータを更新する方法である。

$m=100$で、$b=10$の場合は下記のようになる。

$$
Repeat \lbrace \\\\\\
\hspace{10pt} for\ i=1,11,21,...,91 \lbrace \\\\\\
\hspace{20pt} \theta\_{j} := \theta\_{j} - \alpha \frac{1}{10} \sum\_{k=i}^{i+9}(h\_{\theta}(x^{(k)} - y^{(k)}))x\_{j}^{(k)} \\\\\\
\hspace{20pt} (for\ every\ j=0,...,n) \\\\\\
\hspace{10pt} \rbrace \\\\\\
\rbrace
$$

まとめると下記のとおり。

- (バッチ)最急降下法は1stepあたり、全ての($=m$個)のサンプルを使う
- 確率的最急降下法は1stepあたり、1個のサンプルを使う
- ミニバッチ最急降下法は1stepあたり、$b$個のサンプルを使う

### 確率的最急降下法の収束(Stochastic Gradient Descent Convergence)

確率的最急降下法(Stochastic Gradient Descent)はデータ1つ毎にパラメータ$\theta$を更新するため、常に目的関数が小さくなるとは限らない。

そのため、目的関数が収束しているのかチェックする必要がある。

目的関数が収束しているかチェックするために、任意の回数分のコストの平均値をとり、チェックする。

もし収束していない場合は、平均値をとる範囲を大きくすることで改善することがある。

確率的最急降下法(Stochastic Gradient Descent)は常に最小化するわけではないので、グローバル最小の近辺を行ったり来たりする可能性がある。

確実に収束させたい場合は、学習率$\alpha$を小さくする必要がある。

$$
\alpha = \frac{constant 1}{iterationNumber + constant 2}
$$

高度なトピック(Advanced Topics)
-------------------------------

### オンライン学習(Online Learning)

オンライン学習(Online Learning)は既存のモデルに新しいデータを1つ加えて更新しつづけるアルゴリズムである。
常にモデルを更新しつづけるため、1度更新されたモデルを再度使うことはない。
また、モデルを更新するのに1つだけしかデータを使わないので、1度にたくさんのデータを使う手法に比べて高速かつ省メモリであることが特徴である。

オンラインショッピングのレコメンド機能等の動的にモデルが変化するものを学習する場合にオンライン学習(Online Learning)は有効である。

オンライン学習(Online Learning)は最急降下法(Gradient Descent)のみだけではなく、ニューラルネットワーク(Neural Network,)やロジスティック回帰(Logistic Regression)等のアルゴリズムにも適用できる。

### マップリデュースとデータ並列性(Map Reduce and Data Parallelism)

マップレデュース(Map Reduce)とはデータを分割して計算して、最後に分割した計算結果を集約する手法である。

分割したデータを違うマシン、またはマルチコアのCPUであれば違うコアで処理することで大きなデータを効率的に処理することが可能である。

全データ$m=400$の時、$4$分割した時の場合は下記のとおり。

$$
temp^{(1)} = \sum\_{1}^{100}(h\_{\theta}(x^{(i)} - y^{(i)}))x\_{j}^{(i)}\\\\\\
temp^{(2)} = \sum\_{101}^{200}(h\_{\theta}(x^{(i)} - y^{(i)}))x\_{j}^{(i)}\\\\\\
temp^{(3)} = \sum\_{201}^{300}(h\_{\theta}(x^{(i)} - y^{(i)}))x\_{j}^{(i)}\\\\\\
temp^{(4)} = \sum\_{301}^{400}(h\_{\theta}(x^{(i)} - y^{(i)}))x\_{j}^{(i)}\\\\\\
\theta\_{j} := \theta\_{j} - \alpha \frac{1}{400} (temp^{(1)} + temp^{(2)} + temp^{(3)} + temp^{(4)})
$$
