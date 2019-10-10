knitr::purl("./index.Rmd", output = "CodigoParaPractica.R", documentation = 1)

getPackages <- function(packs){
  packages <- unlist(
    tools::package_dependencies(packs, available.packages(), which=c("Depends", "Imports"), recursive=TRUE)
  )
  packages <- union(packs, packages)
  packages
}

if(file.exists("D:/")){
  if(!file.exists("D:/pkgs")) dir.create("D:/pkgs")
  sapply(c("sf","units", "prettymapr","tmap", "leaflet","leafem",
           "ggplot2","ggmap","ggsn","ggspatial"),function(paquete){
             PaquetesDep <- getPackages(paquete)
             PaquetesDep <- PaquetesDep[!PaquetesDep %in% c("base","stats","graphics", "tools", "utils"
                                                            "MASS", "Rcpp", "methods", "utils", "grid",
                                                            "grDevices", "splines")]
             download.packages(PaquetesDep, 
                               destdir = "D:/pkgs/")
           })

}

sapply(list.files("D:/pkgs", full.names = TRUE), function(dir_pkg) {
  install.packages(dir_pkg, repos = NULL, type="source")
})


