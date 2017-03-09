+++
date = "2017-03-08T23:52:56+09:00"
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

そんな折、[MacBook Proを捨ててThinkpad T460sを買ってgentooを入れた](http://d.hatena.ne.jp/joker1007/20161125/1480069437)という記事をはてブで見つけて、gentooベースにすることにした。

PCはノートパソコンで英語配列のものを考え、thinkpadかvaioにしようかと思ったが、thinkpad t460sにした。

t460sには、もともとwindowsがインストールされているが、その上にGentoo Linux をインストールして、デュアルブート環境にする。

Gentoo歴
--------

6〜7年ほど前、家で1年ほど開発機として使っていた。その後、mac book買ったため、現在まで使っていない。

Thinkpad T460S
--------------

マシンスペック。

- CPU i7 6600U
- HDD NVMe対応SSD 512GB
- メモリ 24G
- 液晶 14型 WQHD 2560×1440
- キーボード 英語配列
- OS Windows 10 Home


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


Gentoo Linuxのインストール
--------------------------

作成したインストールメディアを起動して、Gentoo Linux をインストールする。

[ハンドブック:AMD64 - Gentoo Wiki](https://wiki.gentoo.org/wiki/Handbook:AMD64/ja) を見ながらインストールを行う。

### ディスクの準備

パーティション構成は下記のとおり。

前述のとおり、winのCドライブにあたるパーティションを縮小して、Gentoo Linux をインストールした領域を確保した。

    nvme0n1       477G
    ├─nvme0n1p1   260M      -- EFI
    ├─nvme0n1p2    16M      -- winの管理系？
    ├─nvme0n1p3  68.6G      -- win本体、Cドライブ
    ├─nvme0n1p4  1000M      -- winのリカバリ領域
    ├─nvme0n1p5    64G      -- / (ルート)
    └─nvme0n1p6 343.1G      -- /home (home)

新しい領域は

- /
- /home

の2つに分けた。

ファイルシステムをxfsを利用する。

    $ mkfs.xfs /dev/nvme0n1p5
    $ mkfs.xfs /dev/nvme0n1p6

フォーマットしたパーティションをマウントする。

    $ mount /dev/nvme0n1p5 /mnt/gentoo
    $ mkdir /mnt/gentoo/home /mnt/gentoo/boot
    $ mount /dev/nvme0n1p6 /mnt/gentoo/home
    $ mount /dev/nvme0n1p1 /mnt/gentoo/boot

### Gentooインストールファイルをインストール

時刻を合わせる。

    $ ntpd -q -g

Gentooミラーリストからstage tarballを取得する。

    $ cd /mnt/gentoo
    $ links https://www.gentoo.org/downloads/mirrors/

stage tarballを展開する。

    $ tar xvjpf stage3-*.tar.bz2 --xattrs

/mnt/gentoo/etc/portage/make.conf を編集してGentooコンパイルオプションを設定する。

CFLAGにはマシンアーキテクチャ（-march）と、最適化レベル（-O）を設定する。

    CFLAGS="-march=broadwell -mtune=broadwell -O2 -pipe"

-marchに skylakeの指定をするとコンパイル時にエラーとなった。

調べたところ、[Safe CFLAGS - Gentoo Wiki](https://wiki.gentoo.org/wiki/Safe_CFLAGS#Skylake) にskylakeの設定例があったため、broadwellに変更した。

MAKEOPTSでどれだけ並列してコンパイルを実施するか設定する。

    MAKEOPTS="-j4"

CPU_FLAGS_X86 でCPUの命令セットの指定を行う。

    CPU_FLAGS_X86="aes avx avx2 fma3 mmx mmxext popcnt sse sse2 sse3 sse4_1 sse4_2 ssse3"

    L10N="ja en"
    LINGUS="ja en"

### Gentooベースシステムのインストール

ミラーサーバを設定しておく。

    $ mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf

dnsのコピー

    $ cp -L /etc/resolv.conf /mnt/gentoo/etc/

必要なファイルシステムをマウントする。

    $ mount -t proc proc /mnt/gentoo/proc
    $ mount --rbind /sys /mnt/gentoo/sys
    $ mount --make-rslave /mnt/gentoo/sys
    $ mount --rbind /dev /mnt/gentoo/dev
    $ mount --make-rslave /mnt/gentoo/dev

chrootする。

    $ chroot /mnt/gentoo /bin/bash
    $ source /etc/profile
    $ export PS1='(chroot) $PS1'

Portageのリポジトリを更新する。

    $ emerge-webrsync
    $ emerge --sync

systemdが含んだプロファイルを選択する。

    $ eselect profile list
    Available profile symlink targets:
      [1]   default/linux/amd64/13.0
      [2]   default/linux/amd64/13.0/selinux
      [3]   default/linux/amd64/13.0/desktop
      [4]   default/linux/amd64/13.0/desktop/gnome
      [5]   default/linux/amd64/13.0/desktop/gnome/systemd
      [6]   default/linux/amd64/13.0/desktop/plasma
      [7]   default/linux/amd64/13.0/desktop/plasma/systemd
      [8]   default/linux/amd64/13.0/developer
      [9]   default/linux/amd64/13.0/no-multilib
      [10]  default/linux/amd64/13.0/systemd *
      [11]  default/linux/amd64/13.0/x32
      [12]  hardened/linux/amd64
      [13]  hardened/linux/amd64/selinux
      [14]  hardened/linux/amd64/no-multilib
      [15]  hardened/linux/amd64/no-multilib/selinux
      [16]  hardened/linux/amd64/x32
      [17]  hardened/linux/musl/amd64
      [18]  hardened/linux/musl/amd64/x32
      [19]  default/linux/uclibc/amd64
      [20]  hardened/linux/uclibc/amd64

    $ eselect profile set 10

/etc/portage/make.confのUSEフラグにsystemdを追加する。

systemd向けにパッケージを更新する。

    $ emerge -auDN @world

vim入れる。

    $ emerge -a app-editors/vim

タイムゾーンを設定する

    $ echo 'Asia/Tyokyo' > /etc/timezone
    $ emerge --config sys-libs/timezone-data

ロケールを設定する。

    $ vim /etc/locale.gen
    en_US ISO-8859-1
    en_US.UTF-8 UTF-8
    ja_JP.EUC-JP EUC-JP
    ja_JP.UTF-8 UTF-8
    ja_JP.SHIFT_JIS SHIFT_JIS

    $ locale-gen

    $ eselect locale list
    Available targets for the LANG variable:
      [1]   C
      [2]   en_US
      [3]   en_US.iso88591
      [4]   en_US.utf8 *
      [5]   ja_JP
      [6]   ja_JP.eucjp
      [7]   ja_JP.shiftjis
      [8]   ja_JP.ujis
      [9]   ja_JP.utf8
      [10]  japanese
      [11]  japanese.euc
      [12]  POSIX
      [ ]   (free form)

    $ eselect locale set 4

環境設定の再読み込み。

    $ env-update
    $ source /etc/profile
    $ export PS1="(chroot) $PS1"

### カーネルの設定

    $ emerge -a sys-kernel/gentoo-sources
    $ emerge -a sys-apps/pciutils
    $ cd /usr/src/linux
    $ make menuconfig
    $ make && make modules_install
    $ make install

### システムの設定

fstabの設定。

    $ cat /etc/fstab
    PARTUUID=5ce260de-80a3-4984-a4ea-758e917e3501		/boot			vfat	noauto,noatime					1	2
    PARTUUID=d193f1a5-edec-4c52-bbd0-5aa43de8f3be		/			xfs	noatime						0	1
    PARTUUID=acabd133-51ed-4b85-bbb2-b5add70bef5f		/home			xfs	noatime						0	2

grubはnvme未対応のため、利用できない。

なので、systemd-bootを利用する。

    $ bootctl --path=/boot install

    $ vim /boot/loader/loader.conf
    default	gentoo
    timeout	5
    editor	0

    $ vim /boot/loader/entries/gentoo.conf
    title	Gentoo Linux
    linux	/EFI/gentoo/vmlinuz-4.9.6-gentoo-r1
    options	root=PARTUUID=d193f1a5-edec-4c52-bbd0-5aa43de8f3be init=/usr/lib/systemd/systemd rw noefi

カーネルイメージの配置。

    $ mkdir /boot/EFI/gentoo
    $ cp /boot/vmlinuz-4.9.6-gentoo-r1 /boot/EFI/gentoo/.
    $ cp /boot/System.map-4.9.6-gentoo-r1 /boot/EFI/gentoo/.
    $ cp /boot/config-4.9.6-gentoo-r1 /boot/EFI/gentoo/.

rebootして起動できればOK。

    $ exit
    $ cd
    $ umount -R /mnt/gentoo
    $ shutdown -h now

インストール後の感想
--------------------

今のところ満足。やっぱり動作が軽快なのが良い。

日本語入力の候補がウィンドウの左下に出てくること以外は。。。

インストールしたもの
--------------------

- awesome
- rxvt-unicode
- slim
- zsh
- git
- chromium
- firefox
- neovim
- ranger
- spacefm
- feh
- fcitx
- mozc
- scrot
