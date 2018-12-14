## ----setup, include=FALSE------------------------------------------------
library(knitr)

knitr::knit_hooks$set(
   error = function(x, options) {
     paste('\n\n<div class="alert alert-danger" style="background-color:#ffb3b3">',
           gsub('##', '\n', gsub('^##\ Error', '**Error**', x)),
           '</div>', sep = '\n')
   },
   warning = function(x, options) {
     paste('\n\n<div class="alert alert-warning" style="background-color:#ffff66">',
           gsub('##', '\n', gsub('^##\ Warning:', '**Warning**', x)),
           '</div>', sep = '\n')
   },
   message = function(x, options) {
     paste('\n\n<div class="alert alert-info" style="background-color:#47d147">',
           gsub('##', '\n', x),
           '</div>', sep = '\n')
   }
)

knitr::opts_chunk$set(echo = TRUE)

## ---- message=FALSE------------------------------------------------------
libs <- c("sf","raster", "ggplot2","mapview","units")

new.packages <- libs[!(libs %in% rownames(installed.packages()))]
if(length(new.packages)) install.packages(new.packages)

invisible(sapply(libs, library,character.only = T, quietly=T))

## ------------------------------------------------------------------------
Departamentos<-st_read("../Datos/deptos_cba_cg")

## ------------------------------------------------------------------------
class(Departamentos)

## ------------------------------------------------------------------------
st_crs(Departamentos)


## ------------------------------------------------------------------------
Suelos<-read.table("../Datos/suelos.txt", header=T)

## ------------------------------------------------------------------------
Suelossf<-st_as_sf(Suelos,coords = c("Xt","Yt"))

## ------------------------------------------------------------------------
st_crs(Suelossf)

## ------------------------------------------------------------------------
head(Suelossf)

## ------------------------------------------------------------------------
Suelossf<-st_as_sf(Suelos,coords = c("Xt","Yt"),  crs = 32720)

## ------------------------------------------------------------------------
st_crs(Suelossf)


## ------------------------------------------------------------------------
head(Suelossf)

## ------------------------------------------------------------------------
st_geometry(Departamentos)
st_geometry(Suelossf)

## ------------------------------------------------------------------------
st_crs(Departamentos)
st_crs(Suelossf)

## ------------------------------------------------------------------------
st_crs(Departamentos)

## ------------------------------------------------------------------------
Departamentos<-st_transform(Departamentos,st_crs(Suelossf))

## ------------------------------------------------------------------------
st_crs(Departamentos)

## ------------------------------------------------------------------------
st_distance(Suelossf)

## ------------------------------------------------------------------------
DistanciasSuelo<-st_distance(Suelossf)
mean(DistanciasSuelo)

## ---- error=TRUE---------------------------------------------------------
DistMedia<-mean(DistanciasSuelo[DistanciasSuelo!=0])

## ------------------------------------------------------------------------
(DistMedia<-mean(DistanciasSuelo[DistanciasSuelo!=units::as_units(0,"m")]))
units(DistMedia) <- as_units("km")
DistMedia

## ------------------------------------------------------------------------
st_covers(Departamentos,Suelossf)

## ------------------------------------------------------------------------
lengths(st_covers(Departamentos,Suelossf))

## ------------------------------------------------------------------------
head(DepartConMuestras<-data.frame("Muestras"=lengths(st_covers(Departamentos,Suelossf)),Departamentos))

## ------------------------------------------------------------------------
kable(table(rep(Departamentos$departa, lengths(st_covers(Departamentos,Suelossf)))))

## ------------------------------------------------------------------------
(MediasMOS<-sapply(st_covers(Departamentos,Suelossf), function(x, datos,columna){
  mean(datos[x,columna,drop=T],na.rm=T)}, datos=Suelossf, columna="MOS"))

## ------------------------------------------------------------------------

MediaMosCAT<-cut(MediasMOS,3)

## ------------------------------------------------------------------------
Departamentos$MOSMedia<- MediasMOS
Departamentos$MOSMediaCAT<-MediaMosCAT

## ------------------------------------------------------------------------
(DEM<-raster("../Datos/dtm_elevation_merit.dem_m_250m_s0..0cm_2017_v1.0.tif"))

## ------------------------------------------------------------------------
st_crs(DEM)

## ------------------------------------------------------------------------
raster::crs(DEM)

## ------------------------------------------------------------------------
DEMrp<-projectRaster(DEM, crs=st_crs(Departamentos)$proj4string)# crs(DEM)
DepDEM<-extract(x=DEMrp, y=Departamentos, fun=mean, df=T,sp=T)

class(DepDEM)

## ------------------------------------------------------------------------
DepDEMsf<-st_as_sf(DepDEM)
names(DepDEMsf)

## ------------------------------------------------------------------------
plot(Suelossf)

## ---- eval=FALSE---------------------------------------------------------
## ## S4 method for signature 'sf'
## mapView(x, map = NULL, pane = "auto",
##   canvas = useCanvas(x), viewer.suppress = canvas, zcol = NULL,
##   burst = FALSE, color = mapviewGetOption("vector.palette"),
##   col.regions = mapviewGetOption("vector.palette"), at = NULL,
##   na.color = mapviewGetOption("na.color"), cex = 6,
##   lwd = lineWidth(x), alpha = 0.9, alpha.regions = regionOpacity(x),
##   na.alpha = regionOpacity(x), map.types = NULL,
##   verbose = mapviewGetOption("verbose"), popup = popupTable(x),
##   layer.name = NULL, label = makeLabels(x, zcol),
##   legend = mapviewGetOption("legend"), legend.opacity = 1,
##   homebutton = TRUE, native.crs = FALSE,
##   highlight = mapviewHighlightOptions(x, alpha.regions, alpha, lwd),
##   maxpoints = getMaxFeatures(x), ...)

## ------------------------------------------------------------------------
mapview(Departamentos)

## ------------------------------------------------------------------------
mapview(Departamentos, zcol='st_area_sh')

## ------------------------------------------------------------------------
mapview(Departamentos, zcol="MOSMedia")

## ---- echo = TRUE--------------------------------------------------------
mapview(Departamentos, zcol='MOSMediaCAT')

## ---- echo = TRUE--------------------------------------------------------
mapview(Departamentos, zcol='MOSMedia',at=seq(min(Departamentos$MOSMedia),max(Departamentos$MOSMedia),length=5 ))

## ---- echo = TRUE--------------------------------------------------------
mapview(Departamentos, zcol='MOSMediaCAT', burst=TRUE)

## ---- echo = TRUE--------------------------------------------------------
mapview(Departamentos, zcol='departa', map.types = c("OpenStreetMap","CartoDB.DarkMatter"))


## ------------------------------------------------------------------------
mapview(Suelossf, legend=TRUE, cex="pH")

## ------------------------------------------------------------------------
mapview(Departamentos) + Suelossf

## ------------------------------------------------------------------------
mapviewOptions(basemaps = c("CartoDB.Positron","Esri.WorldShadedRelief", "OpenStreetMap.DE"),
               layers.control.pos = "bottomright")
mapview(Departamentos, color="blue") + mapview(Suelossf, color = "grey40",col.regions = "red")

## ------------------------------------------------------------------------
ggplot(Suelossf) + geom_sf()

## ------------------------------------------------------------------------
ggplot(Departamentos) + geom_sf(aes(fill=st_area_sh))

## ------------------------------------------------------------------------
spplot(DEM)

## ------------------------------------------------------------------------
mapview(DEM, col.regions=viridisLite::viridis)

