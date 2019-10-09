knitr::purl("./index.Rmd", output = "CodigoParaPractica.R", documentation = 1)

if(file.exists("D:/")){
if(!file.exists("D:/pkgs")) dir.create("D:/pkgs")
download.packages(c("sf","units", "prettymapr","tmap", "leaflet","leafem",
                    "ggplot2","ggmap","ggsn","ggspatial"), 
                  destdir = "D:/pkgs/")

}