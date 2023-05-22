# gpphelper

Create a GPP helper toolkit, inspired by the project [strcode](https://github.com/lorenzwalthert/strcode)

## installation

please install from Github:

`devtools::install_github("zq2323/gpphelper")`


## Usage

By using the tool Addins and set the custom shortcut in Rstudio, we are able to quickly insert the header text into the current program with the imported pacakge information.

Addins:

![image](https://github.com/zq2323/gpphelper/assets/23326363/710a26c8-d7ea-4082-b887-fceede2cc950)

when clicking `insert the header`, the default header template will be added on the top of current program, shown as below:
```
#-----------------Header Begin -------------------#
# Date     : 2023-05-11
# Author   : E0459245
# Software : R version 4.1.1 (2021-08-10)
# Import   : dplyr 1.1.2
#            purrr 1.0.1
#            rlang 1.1.0
#-----------------Header End ---------------------#
 
library(rlang)
library(dplyr)

test <- purrr::map(c(1, 2, 3), \(x) print(x))
```

if the value of `Author` is not set by `options()$gpphelp$author` or `sys.getenv('user')`, it will be detected from the `sys.info()` by default.

### Customize your template

You can specify the customized header template. the gpphelp read the `options()$gpphelp` to retrieve the configuration.
```r
op <- list()
op$author <- "ZQ222"
op$headerTemplate <- "your local path/headers_cus.txt"
options(gpphelper = op)
```
then, `gpphelp` will save the `headers_cus` for user `ZQ222`.

headers_cus.txt:
```
#------------------------- BEGINNING OF PROGRAM -------------------------#
#------------------------ [ START STUDY HEADER ] ------------------------#
#
# Program name            :
# Directory               :
# Description             :
# Date                    :
# Author                  :
# Software                :
# Import                  :
#
#------------------------ [ STOP STUDY HEADER ] ------------------------#
```


