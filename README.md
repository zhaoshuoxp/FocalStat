# Focal length static scripts

-----
This repository contains three scripts for calculating the focal length of .jpg images and plotting histograms. The scripts are written in Shell, Python, or R. The focal length is adjusted based on the number of pixels in the image relative to the total pixels of the Nikon Z8 (45M, change this number to your camera pixels in the scripts), in case you crop the image due to the absence of a telephoto lens or merge images due to the lack of a wide lens.

 * Requirements:
   exiftool, gnuplot; R: exifr, ggplot; Python3: exifread, Pillow, matplotlib, numpy

[![996.icu](https://img.shields.io/badge/link-996.icu-red.svg)](https://996.icu) [![LICENSE](https://img.shields.io/badge/license-Anti%20996-blue.svg)](https://github.com/996icu/996.ICU/blob/master/LICENSE)

----

#### Usage

```
./FocalStat.py|R|sh /path/to/jpg/directory
```

#### Output

- histogram.png

GNUplot:
<<<<<<< Updated upstream
![GNUplot](https://raw.githubusercontent.com/zhaoshuoxp/FocalStat/refs/heads/main/gnuplot.png)

=======

<<<<<<< HEAD
![GNUplot](https://raw.githubusercontent.com/zhaoshuoxp/FocalStat/refs/heads/main/gnuplot.png?token=GHSAT0AAAAAACLAHG3EKNXP2MQ32MJPF3C4Z3EORWQ)
=======
![GNUplot](https://raw.githubusercontent.com/zhaoshuoxp/FocalStat/refs/heads/main/Python.png?token=GHSAT0AAAAAACLAHG3FK22UBDWTSQ7SYF56Z3EOQEA)
>>>>>>> Stashed changes
Python:
![python](https://raw.githubusercontent.com/zhaoshuoxp/FocalStat/refs/heads/main/Python.png)

R:
![python](https://raw.githubusercontent.com/zhaoshuoxp/FocalStat/refs/heads/main/R.png)


------

Author [@zhaoshuoxp](https://github.com/zhaoshuoxp)  
Dec 19 2024  

