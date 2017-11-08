---
title: "coursera 機械学習 4週目"
slug: "coursera-machine-learning-week4"
date: 2017-11-08T23:30:22+09:00
---

ニューラルネットワークが必要な背景
==================================

ロジスティック回帰によって非線形が可能になった。

ただ、膨大な数の説明変数(feature)が必要なものにロジスティック回帰を適用すると、ロジスティック回帰だと計算が追いつかなくなる。

膨大な数の説明変数(feature)の例としては、写真を見て「これが車であるか否かを判断する」する場合、$50 \times 50$ pixelのグレースケール画像でも、2,500変数で、2次式にしても約3,000,000個のパラメータを計算することになる。(RGBだとその3倍以上)。

そこで、よりよいアルゴリズムを有する人の脳にヒントを得たのが__ニューラルネットワーク(Neural Network)__。

ニューラルネットワーク(Neural Networks)
=======================================

下記は、入力X($x\_1$, $x\_2$, $x\_3$)に対して、出力Y($h\_\Theta(x)$)となる３層構造のニューラルネットワークの例である。

![ニューラルネットワークの表現の仕方の例](/img/20171103_coursera-machine-learning-week4/neural_network_ex1.png)


入力でもない、出力でもないレイアを__隠れ層(hidden layer)__といい、__隠れ層(hidden layer)__の各ノードを__アクティベーションユニット(activation units)__という。

$$
a\_i^{(j)} = \text{レイア $j$ のアクティベーションユニット $i$} \\\\\\
\Theta^{(j)} = \text{レイア $j$ から レイア $j+1$ に移る際に使う重み行列}
$$

上記の図の__アクティベーションユニット(activation units)__、及び出力は下記のように表現される。

$$
a\_1^{(2)} = g(\Theta\_{10}^{(1)}x\_0 + \Theta\_{11}^{(1)}x\_1 + \Theta\_{12}^{(1)}x\_2 + \Theta\_{13}^{(1)}x\_3) \\\\\\
a\_2^{(2)} = g(\Theta\_{20}^{(1)}x\_0 + \Theta\_{21}^{(1)}x\_1 + \Theta\_{22}^{(1)}x\_2 + \Theta\_{23}^{(1)}x\_3) \\\\\\
a\_3^{(2)} = g(\Theta\_{30}^{(1)}x\_0 + \Theta\_{31}^{(1)}x\_1 + \Theta\_{32}^{(1)}x\_2 + \Theta\_{33}^{(1)}x\_3) \\\\\\
h\_\Theta(x) = a\_1^{(3)} = g(\Theta\_{10}^{(2)}a\_0^{(2)} + \Theta\_{11}^{(2)}a\_1^{(2)} + \Theta\_{12}^{(2)}a\_2^{(2)} + \Theta\_{13}^{(2)}a\_3^{(2)})
$$

ベクトル化した表現は下記のようになる。

$$
a^{(2)} = g(\Theta^{(1)}a^{(1)}) \\\\\\\
h\_\Theta(x) = a^{(3)} = g(\Theta^{(2)}a^{(2)})
$$

つまり

$$
a^{(j)} = g(\Theta^{(j-1)}a^{(j-1)})
$$

レイヤ$j$からレイア$j+1$を計算する場合、下記のように表現できる。

$$
a^{(j+1)} = g(\Theta^{(j)}a^{(j)})
$$

これは、ロジスティック回帰と同じようなことを入力層から出力層に間で行っていることになる。

ニューラルネットワーク(Neural Networks)の例
===========================================

AND
---

$$
\boldsymbol{ \Theta } = \begin{bmatrix} -30 & 20 & 20 \end{bmatrix} \\\\\\
\boldsymbol{ X } = \begin{bmatrix} 1 \\\\\\ x\_1 \\\\\\ x\_2  \end{bmatrix} \\\\\\
$$

$$
h\_{ \Theta }(x) = g(\boldsymbol{ \Theta }\boldsymbol{ X }) = g(-30 + 20x\_1 + 20x\_2)
$$

$$
\begin{array}{c|c|c}
x\_1 & x\_2 & h\_\Theta(x) \\\\\\
\hline
0 & 0 & 0 \\\\\\
1 & 0 & 0 \\\\\\
0 & 1 & 0 \\\\\\
1 & 1 & 1 \\\\\\
\end{array}
$$

OR
--

$$
\boldsymbol{ \Theta } = \begin{bmatrix} -10 & 20 & 20 \end{bmatrix} \\\\\\
\boldsymbol{ X } = \begin{bmatrix} 1 \\\\\\ x\_1 \\\\\\ x\_2  \end{bmatrix} \\\\\\
$$

$$
h\_{ \Theta }(x) = g(\boldsymbol{ \Theta }\boldsymbol{ X }) = g(-10 + 20x\_1 + 20x\_2)
$$

$$
\begin{array}{c|c|c}
x\_1 & x\_2 & h\_\Theta(x) \\\\\\
\hline
0 & 0 & 0 \\\\\\
1 & 0 & 1 \\\\\\
0 & 1 & 1 \\\\\\
1 & 1 & 1 \\\\\\
\end{array}
$$

NOR
---

$$
\boldsymbol{ \Theta } = \begin{bmatrix} 10 & -20 & -20 \end{bmatrix} \\\\\\
\boldsymbol{ X } = \begin{bmatrix} 1 \\\\\\ x\_1 \\\\\\ x\_2  \end{bmatrix} \\\\\\
$$

$$
h\_{ \Theta }(x) = g(\boldsymbol{ \Theta }\boldsymbol{ X }) = g(10 - 20x\_1 - 20x\_2)
$$

$$
\begin{array}{c|c|c}
x\_1 & x\_2 & h\_\Theta(x) \\\\\\
\hline
0 & 0 & 1 \\\\\\
1 & 0 & 0 \\\\\\
0 & 1 & 0 \\\\\\
1 & 1 & 0 \\\\\\
\end{array}
$$

XOR
---

レイア2に NAND と OR、レイア3に AND。

$$
\boldsymbol{ \Theta^{(1)} } = \begin{bmatrix} 30 & -20 & -20 \\\\ -10 & 20 & 20 \end{bmatrix} \\\\\\
\boldsymbol{ \Theta^{(2)} } = \begin{bmatrix} -30 & 20 & 20 \end{bmatrix} \\\\\\
\boldsymbol{ X } = \begin{bmatrix} 1 \\\\\\ x\_1 \\\\\\ x\_2  \end{bmatrix} \\\\\\
$$

$$
a^{(2)} = g(\boldsymbol{ \Theta^{(1)} }\boldsymbol{ X }) \\\\\\
a^{(3)} = g(\boldsymbol{ \Theta^{(2)} }\boldsymbol{ a^{(2)} }) \\\\\\
h\_{ \Theta }(x) = a^{(3)}
$$

$$
\begin{array}{c|c|c|c|c}
x\_1 & x\_2 & a\_{1}^{(2)} & a\_{2}^{(2)} & h\_\Theta(x) \\\\\\
\hline
0 & 0 & 1 & 0 & 0 \\\\\\
1 & 0 & 1 & 1 & 1 \\\\\\
0 & 1 & 1 & 1 & 1 \\\\\\
1 & 1 & 0 & 1 & 0 \\\\\\
\end{array}
$$

XNOR
----

レイア2に AND と (NOT $x\_1$) AND (NOT $x\_2$)、レイア3に OR。

$$
\boldsymbol{ \Theta^{(1)} } = \begin{bmatrix} -30 & 20 & 20 \\\\ 10 & -20 & -20 \end{bmatrix} \\\\\\
\boldsymbol{ \Theta^{(2)} } = \begin{bmatrix} -10 & 20 & 20 \end{bmatrix} \\\\\\
\boldsymbol{ X } = \begin{bmatrix} 1 \\\\\\ x\_1 \\\\\\ x\_2  \end{bmatrix} \\\\\\
$$

$$
a^{(2)} = g(\boldsymbol{ \Theta^{(1)} }\boldsymbol{ X }) \\\\\\
a^{(3)} = g(\boldsymbol{ \Theta^{(2)} }\boldsymbol{ a^{(2)} }) \\\\\\
h\_{ \Theta }(x) = a^{(3)}
$$

$$
\begin{array}{c|c|c|c|c}
x\_1 & x\_2 & a\_{1}^{(2)} & a\_{2}^{(2)} & h\_\Theta(x) \\\\\\
\hline
0 & 0 & 0 & 1 & 1 \\\\\\
1 & 0 & 0 & 0 & 0 \\\\\\
0 & 1 & 0 & 0 & 0 \\\\\\
1 & 1 & 1 & 0 & 1 \\\\\\
\end{array}
$$

多クラス分類(Multiclass Classification)
=======================================

__多クラス分類(Multiclass Classification)__の場合は、出力が下記のように複数持つようになり、該当要素だけを$1$にする。

$$
{h\_\Theta(x) \approx \begin{pmatrix}
1\\\\\\
0\\\\\\
0\\\\\\
0
\end{pmatrix}
,
\hspace{10px}
h\_\Theta(x) \approx \begin{pmatrix}
0\\\\\\
1\\\\\\
0\\\\\\
0
\end{pmatrix}
,
\hspace{10px}
h\_\Theta(x) \approx \begin{pmatrix}
0\\\\\\
0\\\\\\
1\\\\\\
0
\end{pmatrix}
,
\hspace{10px}
\hspace{10px}
h\_\Theta(x) \approx \begin{pmatrix}
0\\\\\\
0\\\\\\
0\\\\\\
1
\end{pmatrix}
}
$$
