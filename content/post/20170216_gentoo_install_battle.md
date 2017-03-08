+++
date = "2017-02-16T23:52:56+09:00"
title = "Gentoo Linux をインストールする"
slug = "gentoo-install-battle"
tags = ["gentoo", "linux", "dual boot"]
+++

Gentoo Linux をインストールする
===============================

概要
----

転職し、新しい会社に入社した。

PCを支給してくれるいうことで、macにしようかなと思っていたのだが、折角なのでdockerをまともに使える環境が良いなと思い、linuxベースの開発環境を作ることにした。

そんな折、[acBook Proを捨ててThinkpad T460sを買ってgentooを入れた](http://d.hatena.ne.jp/joker1007/20161125/1480069437)という記事をはてブで見つけて、gentooベースにすることにした。

PCはノートパソコンで英語配列のものを考え、記事のとおりthinkpadか、vaioにしようかと思った。

結局記事のとおり、thinkpad t460sにした。

Gentoo歴
--------

昔、家で1年ほど開発機として使っていた。

ほぼ初心者。

Thinkpad T460S
--------------

マシンスペック。

- CPU i7 6600U
- HDD NVMe対応SSD 512GB
- メモリ 24G
- 液晶 14型 WQHD 2560×1440
- キーボード 英語配列
- OS Windows 10 Home

構想
----

もともとインストールされているwindowsとgentooのデュアルブート環境にする。

インストールメディアの作成
--------------------------

[ダウンロードページ](https://www.gentoo.org/downloads/)からLiveDVDをダンロードして、mac上でUSBにddして焼いた。

    $ diskutil unmountDisk /dev/disk2
    $ dd if=/Users/gurimusan/Downloads/livedvd-amd64-multilib-20160704.iso of=/dev/disk2 bs=1m
    $ diskutil eject /dev/disk2

インストール前にやること
------------------------

### UEFI のセキュアブートを切る

UEFIを操作してセキュアブートを切る。

- [Windows と Arch のデュアルブート](https://wiki.archlinuxjp.org/index.php/Windows_%E3%81%A8_Arch_%E3%81%AE%E3%83%87%E3%83%A5%E3%82%A2%E3%83%AB%E3%83%96%E3%83%BC%E3%83%88#UEFI_Secure_Boot)

### 高速スタートアップを無効化する

"コントロールパネル"→"ハードウェアとサウンド"→"電源オプション"→"カバーを閉じたときの動作を選択"から無効化する。


### Windows上でハードディスクのパーティションを分ける。

gentooをインストールする領域を確保するために、Cドライブが割り当てられているパーティションを縮小して領域を確保する。

Cドライブ上のデータを壊さなければ、windows上でやらなくても良い。



いんすとーるしたもの
--------------------

### rxvt-unicode
仮想端末


### slim
ログイン

### awesome
WM

### zsh
便利

### git
開発

### chromium
ブラウザ

### ranger
CUIのファイル管理

### feh
画像ビューア

### fcitx
IME

### mozc
日本語入力
