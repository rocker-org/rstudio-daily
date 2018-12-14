#!/usr/bin/Rscript

pg <- httr::content(httr::GET("https://dailies.rstudio.com/rstudioserver/oss/debian9/x86_64/"), as = "text")
doc <- xml2::read_html(pg)
deb <- xml2::xml_attr(xml2::xml_find_first(doc, "//tbody/tr/td/a[@href]"), "href")
download.file(deb, method="wget", dest="rstudio-server-daily-amd64.deb")

