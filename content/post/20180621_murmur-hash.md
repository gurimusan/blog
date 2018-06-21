---
title: "Murmur ハッシュ関数"
slug: "murmur-hash-function"
date: 2018-06-21T01:58:20+09:00
draft: false
---

MurmurHash
==========

2008年にAustin Applebyという人が考案した非暗号ハッシュ。

fnvハッシュより高速なハッシュ関数。

fnvハッシュは1byteずつ処理を行っているのに対し、Murmurハッシュは4byteずつ処理を行い、一度に処理するバイト数が増えるので高速になるというわけである。

RubyのHashTableの実装に使われているらしい。

MurmurHashはMurmurHash3というのが一番新しく、32ビットまたは128ビットのハッシュを生成する。

MurmurHash2は古いバージョンで、32ビットまたは64ビットのハッシュを生成すし、64ビットのハッシュ値生成するソースには2つの変種がある。64ビットプロセッサ用に最適化された用のMurmurHash64Aと32ビットプロセッサ用に最適化されたMurmurHash64Bである。

MurmurHash1は現在は廃止されたバージョン。

Murmurハッシュの最初のバージョンの実装
--------------------------------------

下記のコードはMurmurハッシュの最初のバージョンの実装。

最初の実装なのでシンプル。

[MurmurHash](https://sites.google.com/site/murmurhash/)

[MurmurHash.cpp](https://sites.google.com/site/murmurhash/MurmurHash.cpp)

```c++
//-----------------------------------------------------------------------------
// MurmurHash, by Austin Appleby

// Note - This code makes a few assumptions about how your machine behaves -

// 1. We can read a 4-byte value from any address without crashing
// 2. sizeof(int) == 4

// And it has a few limitations -

// 1. It will not work incrementally.
// 2. It will not produce the same results on little-endian and big-endian
//    machines.


// Changing the seed value will totally change the output of the hash.
// If you don't have a preference, use a seed of 0.

unsigned int MurmurHash ( const void * key, int len, unsigned int seed )
{
    // 'm' and 'r' are mixing constants generated offline.
    // They're not really 'magic', they just happen to work well.

    const unsigned int m = 0xc6a4a793;
    const int r = 16;

    // Initialize the hash to a 'random' value

    unsigned int h = seed ^ (len * m);

    // Mix 4 bytes at a time into the hash

    const unsigned char * data = (const unsigned char *)key;

    while(len >= 4)
    {
        h += *(unsigned int *)data;
        h *= m;
        h ^= h >> r;

        data += 4;
        len -= 4;
    }

    // Handle the last few bytes of the input array

    switch(len)
    {
    case 3:
        h += data[2] << 16;
    case 2:
        h += data[1] << 8;
    case 1:
        h += data[0];
        h *= m;
        h ^= h >> r;
    };

    // Do a few final mixes of the hash to ensure the last few
    // bytes are well-incorporated.

    h *= m;
    h ^= h >> 10;
    h *= m;
    h ^= h >> 17;

    return h;
}
```

このコードで生成されるハッシュ値は32bit。

処理の流れは下記のとおり。

- ハッシュ値をランダムな値で初期化する
- キー値を4byteずつ取り出し、ハッシュ値に変換する
- ハッシュ値に最終処理を施す

### ハッシュ値をランダムな値で初期化する

```c++
    unsigned int h = seed ^ (len * m);
```

4byte(32bit)の定数mとキー値の長さを乗算して、その値とseedと非排他的論理和。

mは32bitな適当な値、値の意味はわからない。

```c++
    const unsigned int m = 0xc6a4a793;
```

### キー値を4byteずつ取り出し、ハッシュ値に変換する

```c++
    while(len >= 4)
    {
        h += *(unsigned int *)data;
        h *= m;
        h ^= h >> r;

        data += 4;
        len -= 4;
    }
```

- キー値へのポインタdataから4byte分取得して、その値をハッシュ値hに加算
- 定数mをハッシュ値hに乗算
- ハッシュ値hとハッシュ値hをr bit分右シフトした値との非排他的論理和をとる
- キー値へのポインタdataを4byte分進める、キー値の長さlを4減算する

```c++
    switch(len)
    {
    case 3:
        h += data[2] << 16;
    case 2:
        h += data[1] << 8;
    case 1:
        h += data[0];
        h *= m;
        h ^= h >> r;
    };

```

キー値の末尾、4byteずつで処理できない部分は、残りを取り出し、別途ハッシュ値に変換する。
中身はハッシュ値を計算する部分は一緒。

### ハッシュ値に最終処理を施す

```c++
    h *= m;
    h ^= h >> 10;
    h *= m;
    h ^= h >> 17;
```

- 定数mをハッシュ値hに乗算
- ハッシュ値hとハッシュ値hを10bit分右シフトした値との非排他的論理和をとる
- 定数mをハッシュ値hに乗算
- ハッシュ値hとハッシュ値hを17bit分右シフトした値との非排他的論理和をとる

アラインメントに対応したMurmurハッシュの実装
--------------------------------------------

4で割り切れないようなアドレスに格納されている場合は、1回のメモリアクセスで読み込み可能であるが、そうでない場合は複数のメモリアクセスになってしまう。

そこで、データの先頭アドレスを4の倍数にすることで、1回のメモリアクセスで読み書きできるようになる。

データの先頭アドレスを4の倍数にすることを「4byte境界にアラインする」という。

下記はアライメントに対応した実装である。

[MurmurHashAligned.cpp](https://sites.google.com/site/murmurhash/MurmurHashAligned.cpp)

[データ型のアラインメントとは何か，なぜ必要なのか？](http://www5d.biglobe.ne.jp/~noocyte/Programming/Alignment.html)

参考
----

[MurmurHash](https://sites.google.com/site/murmurhash/)

[Digest::MurmurHashリリース](https://ksss9.hatenablog.com/entry/2013/12/01/233837)
