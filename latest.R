#!/usr/bin/Rscript

pg <- httr::content(httr::GET("http://www.rstudio.org/download/daily/server/ubuntu64/"), as = "text")
doc <- xml2::read_xml(pg)
deb <- xml2::xml_attr(xml2::xml_find_all(doc, "//tr[@id='row0']/td/a[@href]"), "href")
download.file(deb, method="wget", dest="rstudio-server-daily-amd64.deb")

