
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dblp

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
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

| result                                                                                                                                                                                                                                               |
| :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Implementation of quantum secret sharing and quantum binary voting protocol in the IBM quantum computer. <https://doi.org/10.1007/s11128-019-2531-z> <https://dblp.org/rec/journals/qip/JoySBP20>                                                    |
| Quantum Computing for Computer Architects, Second Edition <https://doi.org/10.2200/S00331ED1V01Y201101CAC013> <https://dblp.org/rec/series/synthesis/2011Metodi>                                                                                     |
| Quantum Communication and Quantum Networking, First International Conference, QuantumComm 2009, Naples, Italy, October 26-30, 2009, Revised Selected Papers <https://doi.org/10.1007/978-3-642-11731-2> <https://dblp.org/rec/conf/quantumcomm/2009> |
| Quantum Computer Science <https://doi.org/10.2200/S00159ED1V01Y200810QMC002> <https://dblp.org/rec/series/synthesis/2008Lanzagorta>                                                                                                                  |
| Quantum Walks for Computer Scientists <https://doi.org/10.2200/S00144ED1V01Y200808QMC001> <https://dblp.org/rec/series/synthesis/2008Venegas>                                                                                                        |

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

| link                                                                                 | info.url                                           | info.key                    | info.year |
| :----------------------------------------------------------------------------------- | :------------------------------------------------- | :-------------------------- | :-------- |
| <a href='https://doi.org/NA'>Data-driven Methods in Inverse Problems….</a>           | <https://dblp.org/rec/phd/basesearch/Adler19>      | phd/basesearch/Adler19      | 2019      |
| <a href='https://doi.org/NA'>Scalable Analysis of Large Datasets in Life Scienc…</a> | <https://dblp.org/rec/phd/basesearch/Ahmed19>      | phd/basesearch/Ahmed19      | 2019      |
| <a href='https://doi.org/NA'>Feasibility and Performance of Dynamic TDD in Dens…</a> | <https://dblp.org/rec/phd/basesearch/Celik19>      | phd/basesearch/Celik19      | 2019      |
| <a href='https://doi.org/NA'>Graph Algorithms for Large-Scale and Dynamic Natur…</a> | <https://dblp.org/rec/phd/basesearch/Ghoorchian19> | phd/basesearch/Ghoorchian19 | 2019      |
| <a href='https://doi.org/NA'>Macroscopic models of Chinese hamster ovary cell c…</a> | <https://dblp.org/rec/phd/basesearch/Hagrot19>     | phd/basesearch/Hagrot19     | 2019      |

``` r

# search for venues

dblp_crawl("Europe", entity = "venues")$content %>%
  slice(1:5) %>%
  select(starts_with("info")) %>%
  kable()
```

| info.venue                                                                        | info.acronym | info.type              | info.url                              |
| :-------------------------------------------------------------------------------- | :----------- | :--------------------- | :------------------------------------ |
| Central European Cybersecurity Conference (CECC)                                  | CECC         | Conference or Workshop | <https://dblp.org/db/conf/cecc/>      |
| Central European Functional Programming School (CEFP)                             | CEFP         | Conference or Workshop | <https://dblp.org/db/conf/cefp/>      |
| Central European Journal of Operations Research                                   | NA           | Journal                | <https://dblp.org/db/journals/cejor/> |
| Central and East European Conference on Software Engineering Techniques (CEE-SET) | CEE-SET      | Conference or Workshop | <https://dblp.org/db/conf/ifip2/>     |
| Central-European Workshop on Services and their Composition (ZEUS)                | ZEUS         | Conference or Workshop | <https://dblp.org/db/conf/zeus/>      |

``` r

# search for authors

dblp_crawl("maguire", entity = "authors")$content %>%
  select(starts_with("info")) %>%
  filter(stringr::str_starts(`info.author`, "Ger")) %>%
  kable()
```

| info.author           | info.url                             | info.aliases.alias | info.notes.note.@type | info.notes.note.text                                 |
| :-------------------- | :----------------------------------- | :----------------- | :-------------------- | :--------------------------------------------------- |
| Gerald Q. Maguire Jr. | <https://dblp.org/pid/m/GQMaguireJr> | NULL               | affiliation           | KTH Royal Institute of Technology, Stockholm, Sweden |
| Gerry Maguire         | <https://dblp.org/pid/255/3148>      | NULL               | NA                    | NA                                                   |
