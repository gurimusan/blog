---
title: "coursera 機械学習 6週目"
slug: "coursera-machine-learning-week6"
date: 2017-11-26T13:59:39+09:00
draft: false
---

学習アルゴリズムの評価(Evaluation a Learning Algorithms)
========================================================

次に試すものを決める(Deeciding What to Try Next)
------------------------------------------------

誤差が大きい場合、検討すべき点は下記のとおり。

- もっと多くのトレーニングデータを得るか
- 説明変数を少なくするか
- 説明変数を多くするか
- 多次元の説明変数を加えるか
- $\lambda$を大きくするか
- $\lambda$を小さくするか

これらは勘で選ばれることが多い。

仮説の評価(Evaluating a Hypothesis)
-----------------------------------

仮説は誤差が少なければ良いというわけではなく、オーバーフィッティングしている可能性がある。

オーバーフィッティングしていないか検証する手段としては、2次までの線形回帰であればグラフにすれば分かるが、説明変数が多いとグラフ化できない。

データをトレーニングセットとテストセットの2つに分けて、トレーニングセットとテストセットの

- コスト関数
- 分類問題のミス率

を比較してオーバーフィッティングしていないか判断する。


モデルの選択とトレーニングセット/検証セット/テストセット
--------------------------------------------------------

データを学習用とテスト用とで分けるか？

これらを使って、どうやってモデルを選択するのか？


仮説が新しい学習用データを正確に予想するか、ということは意味しない。

データセットを下記のように分ける。

- トレーニングセット：60％
- クロス検証セット：20％
- テストセット：20％

これらのデータセットを使うことで、3つの別々のエラー値を計算できるようになる。

- 多項式次数毎にトレーニングセットを仕様して、$\Theta$のパラメータを最適する
- クロス検証セットを仕様して、最小誤差を有する多項式の次数$d$を決める
- テストセットを用いて、一般化誤差$J\_{test}^{\Theta^{(d)}}$を推定する

偏り vs 分散(Bias vs. Variance)
==================================

偏りか分散かを判断する(Diagnosing Bias vs. Variance)
----------------------------------------------------

目的関数がアンダーフィッティングしているのか、オーバーフィッティングしているのか調べる必要がある。

__高バイアス(hight bias)__はアンダーフィッティングしている状態で、__高分散(hight variance)__はオーバーフィッティングしている状態で、これらの黄金比を見つける必要がある。

トレニング誤差$J\_{train}(\Theta)$は、次数を増やせば増やすほど減少する傾向にある。

クロス検証誤差$J\_{CV}(\Theta)$は、ある地点までは次数を増やせば増やすほど減少していく傾向にあり、ある地点を超えると次数を増やせば増やすほど増加していく傾向にある、すなわち凸曲線になる。

- __高バイアス(hight bias)__: トレニング誤差$J\_{train}(\Theta)$とクロス検証誤差$J\_{CV}(\Theta)$が高い状態で$J\_{CV}(\Theta) \approx J\_{train}(\Theta)$
- __高分散(hight variance)__: トレニング誤差$J\_{train}(\Theta)$は低く、クロス検証誤差$J\_{CV}(\Theta)$が高い状態で$J\_{CV}(\Theta) \gt J\_{train}(\Theta)$

正規化と偏り／分散(Regularization and Bias/Variance)
----------------------------------------------------

ある目的関数とコスト関数。

$$
h\_{\theta}(x) = \theta\_0 + \theta\_1 x + \theta\_2 x^2 + \theta\_3 x^3 + \theta\_4 x^4 \\\\\\
J(\theta) = \frac{1}{2m} \sum\_{i=1}^m (h\_{\theta}(x^(i)))^2 + \frac{\lambda}{2m} \sum\_{j=1}^{m} \theta_{j}^{2}
$$

下記のような傾向がある。

- $\lambda$が$0$に近づくにつれて$\theta$が大きくなり__高分散(hight variance)__になる。
- $\lambda$が無限大に近づくにつれて$\theta$が小さくなり__高バイアス(hight bias)__になる。

適度な$\lambda$を選ぶ必要があり、$\lambda$を計算によって導き出す。

1. ラムダのリストを作成する($\{ \lambda \mid \lambda \in {0,0.01,0.02,0.04,0.08,0.16,0.32,0.64,1.28,2.56,5.12,10.24} \}$)
1. 異なる次数または他の説明変数を持つ目的関数を作成する
1. 全ての関数において$\lambda$を反復し、$\Theta$を得る
1. 学習済みの$\Theta$を使って、正規化項のない$J\_{cv}(\Theta)$上でのクロス検証誤差を算出する
1. クロスバリデーションの中で一番誤差が少ないベストな組み合わせを選択する
1. 最良の$\Theta$と$\lambda$を$J\_{test}(\Theta)$に適用して、一般化できているか確認する

学習曲線(Learning curves)
-------------------------

__高バイアス(hight bias)__の場合、トレーニングセットを多くすることは意味がない

- トレーニングセットが少ない場合、$J\_{train}(\Theta)$と$J\_{CV}(\Theta)$は共に高い
- トレーニングセットが多い場合、$J\_{train}(\Theta)$と$J\_{CV}(\Theta)$は共に高いままだが$J\_{train}(\Theta) \approx J\_{CV}(\Theta)$

__高分散(hight variance)__の場合、トレーニングセットを多くすることは意味がある

- トレーニングセットが少ない場合、$J\_{train}(\Theta)$は低く、$J\_{CV}(\Theta)$は高い
- トレーニングセットが多い場合、$J\_{train}(\Theta)$は増加し、$J\_{CV}(\Theta)$は減少しつづけるが、 $J\_{train}(\Theta)$と$J\_{CV}(\Theta)$の差は大きいまま。


Deciding What to Do Next Revisited
----------------------------------

- もっと多くのトレーニングデータを得るか
 - 高分散を解決する
- 説明変数を少なくするか
 - 高分散を解決する
- 説明変数を多くするか
 - 高バイアスを解決する
- 多次元の説明変数を加えるか
 - 高バイアスを解決する
- $\lambda$を大きくするか
 - 高バイアスを解決する
- $\lambda$を小さくするか
 - 高分散を解決する

スパム分類器の構築(Building a Spam Classifier)
==============================================

Prioritizing What to work on
----------------------------

何を優先すべきか？考える必要がある。

エラー分析(Error Analysis)
--------------------------

機械学習の問題を解決するための推奨されるアプローチは次のとおり。

- 簡単なアルゴリズムから始めて、すぐに実装し、早い段階でクロス検証データを使ってテストする
 - 高バイアス、高バリアンスかがわかる
- 学習曲線をプロットして、より多くのデータ、より多くの機能などが役立つかどうかを判断する
- クロス検証データ内のサンプルのエラーを手動で調べ、エラーが発生した傾向を見つける

エラー分析は、クロス検証の分類のエラーを人力で見る作業
- どのようなカテゴリについて分類を間違えているか
- どのような追加の説明変数があれば精度が上がるだろうか
手動で見ながら考える。

機械学習の実装をする際は、いろいろなアイデアが出てきて、試したくなるだろうが、そんな時にそのアイデアを導入した場合としなかった場合とで$J\_{CV}(\Theta)$の誤差を見てみる。

導入したら誤差が高まるようであれば入れなければいいし、低くなるのなら入れたほうが良い、と素早く意思決定ができるようになる。

スキューデータの扱い(Handling Skewed Data)
==========================================

Error metrics for skewed classes
--------------------------------

スキューデータ(Skewed Data)に対しては、別の評価指標を用いた方が良い。

例えばがん患者を分類する問題を考えよう。

99%の患者を正しく判断できていた、このモデルは好ましいだろうか？

そうとは限らない。なぜなら全体の1%ががん患者で、全員に対してがんでない、と判断しても99%の患者を正確に判断できていることになるから。

このような、陽性と陰性の割合が歪んでいるのを__スキュークラス(Skewed classes)__と呼ぶ。

このような場合、正確性を図る評価としては何を持つのが良いか。

下記に予測(Predict)と実施(Actual)の値を表にした。

| 予測\実際 | 1              | 0              |
|-----------|----------------|----------------|
| 1         | True Positive  | False Positive |
| 0         | False Negative | True Negative  |


適合率(Precision)は$y=1$と予測したもののうち、実際に$y=1$だったものの割合。

$$
P(recision) = True Positive / (True Positive + False Positive)
$$

再現率(Recall)は$y=1$と予測したもののうち、正しく$y=1$と予測できたものの割合。

$$
R(ecall) = True Positive / (True Positive + False Negative)
$$

これらは高ければ良い。

$y=1$に稀な__スキュークラス(Skewed classes)__を置く。

Trading Off Precision and Recall
--------------------------------

適合率(Precision)と再現率(Recall)はトレードオフな関係にある。

敷居値を上げると適合率(Precision)が上がり、再現率(Recall)は下がる。

敷居値を下げると適合率(Precision)が下がり、再現率(Recall)は上がる。

このような敷居値を決める方法に__Fスコア__という適合率(Precision)と再現率(Recall)の調和平均を取る指標を用いる。

$$
F Score = 2*(\frac {PR}{P+R})
$$

Fスコアが一番高くなる敷居値を選べば良い。


Uing Large Data sets
====================

Data for machine learning
-------------------------

機械学習のアルゴリズムの精度は、アルゴリズムの方式ではなくいかに大量のトレーニングセットを与えることができるかどうかということにかかっている。

大量のトレーニングセットがアルゴリズムの精度を上げることの前提は下記のおおり。

- 人間のエクスパートがyを予測できるだけのfeatureがあるか
- 大量のトレーニングデータを与えられ、パラメータをアルゴリズムが学習できるか