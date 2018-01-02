---
title: "機械学習 最小二乗法"
slug: "machine-learning-least-squares"
date: 2018-01-02T08:49:32+09:00
draft: false
---

最小二乗法(Least Squares)
=========================

m個のデータ$(x\_{1}, y\_{1}),...,(x\_{m}, y\_{m})$を直線に当てはめたい。直線の方程式を下記のように置く。

$$
y = \theta\_{0}x + \theta\_{1}x
$$

もしm個のデータ$(x\_{1}, y\_{1}),...,(x\_{m}, y\_{m})$が直線$y^{i} = \theta\_{0}x^{i} + \theta\_{1}x^{i},\ i=1,...,m$となっていればデータ$(x^{i}, y^{i})$は全て直線$y = \theta\_{0}x + \theta\_{1}x$上にあるが、データは直線には一致しない。そこで

$$
y^{i} \approx \theta\_{0}x^{i} + \theta\_{1}x^{i}\\\\\\
i=1,...,m
$$

となるように近似して、直線のパラメータを定める。次の誤差の二乗和の最小化問題を解くことでパラメータ$\theta$を求める。

$$
min\ J = \frac{1}{2m} \sum\_{i=1}^{m}((\theta\_{0}x^{i} + \theta\_{1}x^{i}) - y^{i})^{2}
$$

これを__最小二乗法__と呼ぶ。

例
--

5点$(4, -17), (15, -4), (30, -7), (100, 50), (200, 70)$に最小二乗法で直線を当てはめる。

当てはめる直線を$y = \theta\_{0} + \theta\_{1}x$とすると、

$$
m = 5\\\\\\
J = \frac{1}{2m} \sum\_{i=1}^{m}((\theta\_{0}x^{i} + \theta\_{1}x^{i}) - y^{i})^{2}
$$

を最小にするようにパラメータ$\theta$を求める。

$\theta$で偏微分すると下記のようになる。

$$
\frac{\delta J}{\delta \theta^{i}} = \frac{1}{m} \sum\_{i=1}^{m}((\theta\_{0}x^{i} + \theta\_{1}x^{i}) - y^{i})x^{i}
$$


$\theta$をそれぞれで微分して$0$と置くと次のようになる。

$$
\begin{eqnarray}
\frac{\delta J}{\delta \theta\_{0}} &=& \frac{1}{5} \\{ ((\theta\_{0} + 4\theta\_{1}) - (-17))(1) + ((\theta\_{0} + 15\theta\_{1}) - (-4))(1) + ((\theta\_{0} + 30\theta\_{1}) - (-7))(1) + ((\theta\_{0} + 100\theta\_{1}) - (50))(1) + ((\theta\_{0} + 200\theta\_{1}) - (70))(1) \\} \\\\\\
&=& \frac{1}{5} \\{ \theta\_{0}(1+1+1+1+1) + \theta\_{1}(4+15+30+100+200) - ((-17)+(-4)+(-7)+(50)+(70)) \\} \\\\\\
&=& 0
\end{eqnarray}
$$

$$
\begin{eqnarray}
\frac{\delta J}{\delta \theta\_{1}} &=& \frac{1}{5} \\{ ((\theta\_{0} + 4\theta\_{1}) - (-17))(4) + ((\theta\_{0} + 15\theta\_{1}) - (-4))(15) + ((\theta\_{0} + 30\theta\_{1}) - (-7))(30) + ((\theta\_{0} + 100\theta\_{1}) - (50))(100) + ((\theta\_{0} + 200\theta\_{1}) - (70))(200) \\} \\\\\\
&=& \frac{1}{5} \\{ \theta\_{0}(4+15+30+100+200) + \theta\_{1}(4^{2}+15^{2}+30^{2}+100^{2}+200^{2}) - ((4 \cdot -17)+(15 \cdot -4)+(30 \cdot -7)+(100 \cdot 50)+(200 \cdot 70)) \\} \\\\\\
&=& 0
\end{eqnarray}
$$

これから、次の連立一次方程式を得る。

$$
\begin{eqnarray}
\left(
  \begin{array}{ccc}
    \frac{1}{5} (1+1+1+1+1) & \frac{1}{5} (4+15+30+100+200)\\\\\\
    \frac{1}{5} (4+15+30+100+200) & \frac{1}{5} (4^{2}+15^{2}+30^{2}+100^{2}+200^{2})
  \end{array}
\right)
\left(
  \begin{array}{cc}
    \theta\_{0} \\\\\\
    \theta\_{1}
  \end{array}
\right) &=&
\left(
  \begin{array}{cc}
    \frac{1}{5} ((-17)+(-4)+(-7)+(50)+(70))\\\\\\
    \frac{1}{5} (4 \cdot -17)+(15 \cdot -4)+(30 \cdot -7)+(100 \cdot 50)+(200 \cdot 70)
  \end{array}
\right)\\\\\\
\left(
  \begin{array}{ccc}
    5 & 349 \\\\\\
    349 & 51141
  \end{array}
\right)
\left(
  \begin{array}{cc}
    \theta\_{0} \\\\\\
    \theta\_{1}
  \end{array}
\right) &=&
\left(
  \begin{array}{cc}
    92\\\\\\
    18662
  \end{array}
\right)
\end{eqnarray}
$$

これを解いて

$$
\theta\_{0} = -13.503 \\\\\\
\theta\_{1} = 0.457
$$

を得る。

pythonでの実装
--------------

この解はsympyを使って連立方程式を解くと、下記のような解となる。

```python
>>> import sympy
>>>
>>> x = sympy.Symbol('x')
>>> y = sympy.Symbol('y')
>>>
>>> points = [(4, -17), (15, -4), (30, -7), (100, 50), (200, 70)]
>>> m = len(points)
>>> theta0, theta1 = sympy.symbols('theta0, theta1')
>>> j = (1.0/(2*m)) * ((theta0 + theta1*x) - y) ** 2
>>>
>>> j_theta0 = sympy.diff(j, theta0)
>>> j_theta1 = sympy.diff(j, theta1)
>>>
>>> sum_theta0 = sum([j_theta0.subs([(x, _x), (y, _y)]) for _x, _y in points]) / 2.
>>> sum_theta1 = sum([j_theta1.subs([(x, _x), (y, _y)]) for _x, _y in points]) / 2.
>>>
>>> sympy.solve([sum_theta0, sum_theta1], [theta0, theta1])
{theta0: -13.5027034293225, theta1: 0.457058788385709}
```

numpyの回帰関数``polyfit``を使うと下記のように書ける。

```python
>>> import numpy
>>> X = [4, 15, 30, 100, 200]
>>> Y = [-17, -4, -7, 50, 70]
>>> numpy.polyfit(X, Y, 1)
array([  0.45705879, -13.50270343])
```
