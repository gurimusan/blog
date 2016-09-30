+++
date = "2016-09-29T23:52:56+09:00"
title = "Raspberry PI で、ADCを使って温度を測定する"
slug = "raspberry-pi-how-to-measuring-temperature-using-adc"
tags = ["RaspberryPI", "iot"]

+++

# やりたいこと

アナログ温度センサを使って、Raspberry PIで測る。

# 使用する機器、及び部品

温度センサは MCP9700を利用する。

MCP9700はアナログセンサで、Raspberry PI のピンはデジタルな入力しかできないので、アナログ-デジタル変換を行うために、ADコンバータ MCP3008を利用する。

* Raspberry PI3 Model B
* [温度センサ MCP9700](http://akizukidenshi.com/catalog/g/gI-03286/)
* [ADコンバータ MCP3008](http://akizukidenshi.com/catalog/g/gI-09485/)
* [ブレッドボード EIC-801](http://akizukidenshi.com/catalog/g/gP-00315/)
* ジャンパワイア

# Raspberry PiでSPIをセットアップする

MCP3008は、SPIバスで接続する必要があるため、Raspberry PI のSPIを有効にする。

下記コマンドを実行。

    $ sudo raspi-config

Advanced Optionsで A6 SPIを選択して、下記の両方で Yes を選択。

* SPI interface to be enabled?
* SPI kernel module to be loaded by default?

再起動。

    $ sudo reboot

spi_bcm2835 がロードされていることを確認

    $ lsmod | grep spi

SPI通信に必要なPythonライブラリをインストール。

    $ sudo apt-get install python-pip
    $ sudo pip install spidev

# ブレッドボード配線

![ブレッドボードの配線](/img/20160930_raspberry_pi_how_to_measuring_temperature_using_adc/breadboard.jpg)

## 温度センサ MCP9700 の配線

[データシート1](http://akizukidenshi.com/download/MCP9701-ETO.pdf)

[データシート2](http://akizukidenshi.com/download/mcp9700.pdf)

* VDD -> Raspberry Pi 3.3V
* VOUT -> VOUT -> MCP3008 CH0
* GND -> Raspberry Pi GND

## MCP3008の配線

[データシート](http://akizukidenshi.com/download/ds/microchip/mcp3008.pdf)

* MCP3008 VDD -> Raspberry PI 3.3V
* MCP3008 VREF -> Raspberry PI 3.3V
* MCP3008 AGND -> Raspberry PI GND
* MCP3008 CLK -> Raspberry PI GPIO 11 (SCLK)
* MCP3008 DOUT -> Raspberry PI GPIO 9 (MISO)
* MCP3008 DIN -> Raspberry PI GPIO 10 (MOSI)
* MCP3008 CS/SHDN -> Raspberry PI GPIP 8 (CE0)
* MCP3008 DGND -> Raspberry PI GND

# スクリプト

下記を adc_tmp36.py というファイル名で保存。

```python
# -*- coding: utf-8 -*-

import sys

import time

import spidev

spi = spidev.SpiDev()
spi.open(0,0)


def analog_read(channel):
    r = spi.xfer2([1, (8 + channel) << 4, 0])
    adc_out = ((r[1]&3) << 8) + r[2]
    return adc_out


if __name__ == '__main__':
    try:
        while True:
            reading = analog_read(0)
            voltage = reading * 3.3 / 1024
            temp_c = voltage * 100 - 50
            print("Volts V=%f\tTemp C=%f" % (voltage, temp_c))
            time.sleep(1)
    except KeyboardInterrupt:
        pass
    finally:
        spi.close()

    sys.exit(0)
```

実行すると下記ように出力される。

    $ python adc_tmp36.py
    Volts V=0.802441	Temp C=30.244141
    Volts V=0.783105	Temp C=28.310547
    Volts V=0.795996	Temp C=29.599609
    Volts V=0.799219	Temp C=29.921875
    Volts V=0.799219	Temp C=29.921875
    Volts V=0.799219	Temp C=29.921875
    Volts V=0.799219	Temp C=29.921875
    Volts V=0.799219	Temp C=29.921875
    Volts V=0.802441	Temp C=30.244141

室温は25℃くらいだが、高く表示される。

精度は ±4℃ らしいので、その誤差の範囲なのか？

# スクリプトの説明

## analog_read

MCP3008の特定のチャネルへの送受信のやりとりをする関数。

CP3008のデータシートを見ると、MCP3008への送受信を行う方法が記載されている。

![CP3008の入力値と返り値](/img/20160930_raspberry_pi_how_to_measuring_temperature_using_adc/mcp3008_spi_communication.png)

送信データは、

    00000001 1xxx0000 00000000

のような24bitのデータとなる。

最初の 00000001 はスタートビット。

1xxx は 読み込みたいチャネルのよって変わる。

例えば、

* ch 0 なら 1000
* ch 1 なら 1001
* ch 2 なら 1010

のようになる。

プログラムコードに戻ると、

    r = spi.xfer2([1, (8 + channel) << 4, 0])

という処理では、xfer2という関数に3つの値を格納した配列を渡しているが、これが上記の24bitの送信データを表している。

つまり、xfer2という関数に渡している配列のうち

* 最初の要素は 1 は 00000001 を表す
* 2番目の要素の (8 + channel) << 4 は 1xxx0000 を表す
* 3癌目の要素は 00000000 を表す

xfer2からの返り値は

    [0, 0, 246]

のようなデータが返却される。

これも入力値と同様に24bitのデータを表す。

MCP3008からの受信データは、下位10bitがチャネルへ入力されたデータとなるため、

    adc_out = ((r[1]&3) << 8) + r[2]

という処理は、xfer2から返却された配列の

* 2番目の要素と3、00000011との論理積を取ることで、下位2bitを取得する
* 2番目の要素の下位2bitを8bit左にシフトして、3番目の要素との論理和をとることで、受信データの下位10bitが取得する

最後に、取得した下位10bitのデータを返却する。

## main

ここで行っている処理は、下記のとおり。

* analog_read関数を実行して、MCP3008のch 0のデータを読み取り、受信データの下位10bitを取得する
* analog_read関数の返り値を電圧に変換する
* 電圧を温度（摂氏）に変換する

電圧への変換方法は、MCP3008のEQUATION 4-2を見ると、

```
out = (1024 * Vin) / Vref
```

と記述があるので

```
Vin = (out * Vref) / 1024
```

で、MCP3008からの受信データからMPC9700から出力された電圧が求まる。

MPC9700のデータシートの4.0 活用情報」を見るとセンサーの変換関数が記載されている。

```
Vout = Tc1 * Ta + V0c

Ta = 周囲温度
Vout = センサー出力電圧
V0c = 0℃の時のセンサーの出力電圧(500mV)
Tc1 = 温度係数(10mV)
```

なので

```
Ta = Vout / Tc1 - V0c
```

で、温度が求まる。

# 参考にしたサイト

* [Raspberry PiのPythonからTMP36のアナログ温度センサとMCP3008のADコンバータを使う](http://qiita.com/masato/items/f089a17b1c9329eb7d03)
* [温度センサーを試す](http://pongsuke.hatenablog.com/entry/2016/01/08/111937)
* [Raspberry PI のピン配置](http://elinux.org/RPi_Low-level_peripherals#Model_A.2B.2C_B.2B_and_B2)
