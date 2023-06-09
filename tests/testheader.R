## Program name: testheader.R
## Task:
## Purpose:
## Author: Wayne Yang
## Date created: 2023-06-09
## Input:
## Output:
## Macro used:
## ParameterN:

## Remarks:

## Revision history :
## Modified by:
## Modification Date:
## Modification:

## import: data.table 1.14.2
#          devtools 2.4.4
#          gpphelper 0.0.1
#          renv 0.17.3
#          rstudioapi 0.14

entimiceRepositoryRoot <-  "/a01/var/entimice/filesystem/filesysroot"
setwd(entimiceRepositoryRoot)

if (exists("pgmpath")) {
  source(file.path(pgmpath, "setup.R"))
} else if (exists("exec.programName")) {
  source(file.path(dirname(exec.programPath), "setup.R"))
} else {
  cat("running interactively")
  source(paste(dirname(rstudioapi::getSourceEditorContext()$path), "./setup.R", sep = "/"))
}

## load package
library(data.table)
library(stringr)
library(haven)




getwd()
library(devtools)
load_all()


op <- list()
op$author <- "Wayne Yang"
op$headerTemplate <- "~/R/REPO/gpphelper/tests/header2.txt"
options(gpphelper = op)

options()$gpphelper
gpphelper:::decodeChar(settings$header[[1]])
gpphelper:::decodeChar(settings$author)
gpphelper:::decodeChar(settings$comment[[1]])

gpphelper:::decodeChar("'y&]y97jM{`9j.MT7rf.xdx")

gpphelper:::get_opts(author = "gpphelper", header_config = NULL, comment_config = NULL)
#

read_opts(opts = options()$gpphelper) %>% .$header %>% sapply(.,decodeChar)

rstudioapi::getActiveDocumentContext()$path
pkg <- renv::dependencies(path = rstudioapi::getActiveDocumentContext()$path)$Package
pkg




options()
