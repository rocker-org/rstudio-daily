#!/usr/bin/Rscript

pg <- httr::content(httr::GET("http://www.rstudio.org/download/daily/server/ubuntu64/"))
deb <- XML::xpathSApply(pg, "//tr[@id='row0']/td/a[@href]", XML::xmlAttrs)[[1]]
download.file(deb, method="wget", dest="rstudio-server-daily-amd64.deb")

