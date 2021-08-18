
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dblp

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R-CMD-check](https://github.com/KTH-Library/dblp/workflows/R-CMD-check/badge.svg)](https://github.com/KTH-Library/dblp/actions)
<!-- badges: end -->

The dblp computer science bibliography at [dblp.org](https://dblp.org)
provides open bibliographic information on major computer science
journals and proceedings. Originally created at the University of Trier
in 1993, dblp is now operated and further developed by Schloss Dagstuhl.
This R package interfaces with the API, making data available to use
from R.

## Installation

You can install the development version of dblp from GitHub with:

``` r
#install.packages("devtools")
install_github("KTH-Library/dblp", dependencies = TRUE)
```

## Example

This is a basic example which shows you how make a search :

``` r
library(dblp)
library(knitr)
library(stringr)
suppressPackageStartupMessages(library(dplyr))

# search for publications

dblp_search("quantum computer")$content %>%
  select(starts_with("info")) %>%
  mutate(result = paste(`info.title`, `info.ee`, `info.url`)) %>%
  select(result) %>%
  slice(1:5) %>%
  kable()
```

| result                                                                                                                                                                                                          |
|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Quantum Computers and Quantum Computer Languages - Quantum Assembly Language and Quantum C Language <http://arxiv.org/abs/quant-ph/0201082> <https://dblp.org/rec/journals/corr/quant-ph-0201082>               |
| Design of a quantum repeater using quantum circuits and benchmarking its performance on an IBM quantum computer. <https://doi.org/10.1007/s11128-021-03189-8> <https://dblp.org/rec/journals/qip/DasRM21>       |
| Demonstration of minisuperspace quantum cosmology using quantum computational algorithms on IBM quantum computer. <https://doi.org/10.1007/s11128-021-03180-3> <https://dblp.org/rec/journals/qip/GangulyDBP21> |
| Implementation of quantum secret sharing and quantum binary voting protocol in the IBM quantum computer. <https://doi.org/10.1007/s11128-019-2531-z> <https://dblp.org/rec/journals/qip/JoySBP20>               |
| Quantum Computing for Computer Architects, Second Edition <https://doi.org/10.2200/S00331ED1V01Y201101CAC013> <https://dblp.org/rec/series/synthesis/2011Metodi>                                                |

``` r
# crawl when there are many pages of results


search <- dblp_crawl("Royal Institute")$content

# display results
search %>%
  filter(str_detect(`info.ee`, "kth:diva")) %>%
  arrange(desc(`info.year`)) %>%
  # rename and order some named and indexed columns
  select(DOI = `info.doi`, 9:4) %>%
  # add a HTML link by combining title and use DOI for href
  mutate(link = sprintf("<a href='https://doi.org/%s'>%s...</a>", 
    DOI, str_sub(`info.title`, 1, 50))) %>%
  # pick out a few columns to display in a HTML table
  select(link, 1:4, -c("DOI", "info.ee"), `info.year`) %>%
  slice(1:5) %>%
  kable()
```

| link                                                                                 | info.url                                               | info.key                        | info.year |
|:-------------------------------------------------------------------------------------|:-------------------------------------------------------|:--------------------------------|:----------|
| <a href='https://doi.org/NA'>Short-term Underground Mine Scheduling - An Indust…</a> | <https://dblp.org/rec/phd/basesearch/Astrand21>        | phd/basesearch/Astrand21        | 2021      |
| <a href='https://doi.org/NA'>Topological and geometrical methods in data analys…</a> | <https://dblp.org/rec/phd/basesearch/Gafvert21>        | phd/basesearch/Gafvert21        | 2021      |
| <a href='https://doi.org/NA'>Neural Network Architecture Design - Towards Low-c…</a> | <https://dblp.org/rec/phd/basesearch/Javid21>          | phd/basesearch/Javid21          | 2021      |
| <a href='https://doi.org/NA'>Mobile Network Operator Collaboration using Deep R…</a> | <https://dblp.org/rec/phd/basesearch/Karapantelakis21> | phd/basesearch/Karapantelakis21 | 2021      |
| <a href='https://doi.org/NA'>Decentralized Learning of Randomization-based Neur…</a> | <https://dblp.org/rec/phd/basesearch/Liang21>          | phd/basesearch/Liang21          | 2021      |

``` r
# search for venues

dblp_crawl("Europe", entity = "venues")$content %>%
  slice(1:5) %>%
  select(starts_with("info")) %>%
  kable()
```

| info.venue                                                                         | info.acronym | info.type              | info.url                                 |
|:-----------------------------------------------------------------------------------|:-------------|:-----------------------|:-----------------------------------------|
| Annual Conference of the European Association for Computer Graphics (Eurographics) | Eurographics | Conference or Workshop | <https://dblp.org/db/conf/eurographics/> |
| Applications and Theory of Petri Nets (Petri Nets)                                 | Petri Nets   | Conference or Workshop | <https://dblp.org/db/conf/apn/>          |
| Bulletin of the EATCS                                                              | NA           | Journal                | <https://dblp.org/db/journals/eatcs/>    |
| Central European Cybersecurity Conference (CECC)                                   | CECC         | Conference or Workshop | <https://dblp.org/db/conf/cecc/>         |
| Central European Functional Programming School (CEFP)                              | CEFP         | Conference or Workshop | <https://dblp.org/db/conf/cefp/>         |

``` r
# search for authors

dblp_crawl("maguire", entity = "authors")$content %>%
  select(starts_with("info")) %>%
  filter(stringr::str_starts(`info.author`, "Ger")) %>%
  kable()
```

| info.author           | info.url                             | info.aliases.alias | info.notes.note                                                    |
|:----------------------|:-------------------------------------|:-------------------|:-------------------------------------------------------------------|
| Gerald Q. Maguire Jr. | <https://dblp.org/pid/m/GQMaguireJr> | NULL               | affiliation , KTH Royal Institute of Technology, Stockholm, Sweden |
| Gerry Maguire         | <https://dblp.org/pid/255/3148>      | NULL               | NULL                                                               |
