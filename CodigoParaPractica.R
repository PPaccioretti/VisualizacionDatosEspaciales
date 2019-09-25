## ----cargaLibrerias------------------------------------------------------

library(sf)
library(ggplot2)
library(ggmap)
library(prettymapr)
library(units)
library(tmap)
library(leaflet)
library(leafem)


libs <- c("sf", "ggmap", "prettymapr", "tmap", "leaflet","leafem", "ggplot2","units")
new.packages <- libs[!(libs %in% rownames(installed.packages()))]
if(length(new.packages)) install.packages(new.packages)

invisible(sapply(libs, library,character.only = T, quietly=T))





## ------------------------------------------------------------------------
2+2
normalAleatorio <- rnorm(10, mean = 0, sd = 1) 
normalAleatorio




## ---- highlight.output=c(1,2,6,9)----------------------------------------
head(departamentos <- read_sf("datos/deptos_cba", stringsAsFactors = TRUE), 3)


## ------------------------------------------------------------------------
summary(departamentos)


## ------------------------------------------------------------------------
plot(departamentos)


## ---- eval=FALSE---------------------------------------------------------
## ?plot.sf()


## ------------------------------------------------------------------------
plot(departamentos["departa"])


## ------------------------------------------------------------------------
plot(departamentos["departa"], key.pos = NULL)


## ------------------------------------------------------------------------
plot(departamentos["departa"], key.pos = NULL, main = "Departamentos")


## ------------------------------------------------------------------------
head(cuencas <- read_sf("datos/cuencas_cba", stringsAsFactors = TRUE), 2)



## ------------------------------------------------------------------------
summary(cuencas)


## ---- fig.height=5.5-----------------------------------------------------
plot(cuencas)


## ------------------------------------------------------------------------
plot(departamentos["departa"], 
     main = NULL, col = "transparent")


## ------------------------------------------------------------------------
plot(cuencas["AREA"], 
     main = NULL, col = "transparent")


## ---- fig.height=5.5-----------------------------------------------------
plot(departamentos["departa"], col = "transparent", main = NULL, 
     reset = FALSE) #<<
plot(cuencas["AREA"], col = "transparent", add = TRUE)



## ---- highlight.output=c(3)----------------------------------------------
st_crs(departamentos)


## ---- highlight.output=c(3)----------------------------------------------
st_crs(cuencas)


## ------------------------------------------------------------------------
st_crs(departamentos) == st_crs(cuencas)



## ---- highlight.output=c(3)----------------------------------------------
cuencas <- st_transform(cuencas, st_crs(departamentos))
st_crs(cuencas)


## ------------------------------------------------------------------------
st_crs(departamentos) == st_crs(cuencas)


## ---- highlight.output=c(5, 6)-------------------------------------------
head(cuencas,4)


## ------------------------------------------------------------------------
plot(departamentos["departa"], col = "transparent", main = NULL, reset = FALSE)
plot(cuencas["AREA"], col = "transparent", add = TRUE)



## ------------------------------------------------------------------------
plot(departamentos["departa"], col = "transparent", main = NULL, reset = FALSE)
plot(cuencas["AREA"], add = TRUE, col = "transparent", border = "red")


## ---- fig.height = 5.3---------------------------------------------------
plot(departamentos["departa"], col = "transparent", main = NULL, reset = FALSE)
plot(cuencas["AREA"], add = TRUE, col = "transparent", border = "red")
legend("bottomright", legend = c("Límites departamentales", "Cuencas"), col = c("black", "red"), lty = 1, lwd = 3)


## ---- fig.height=5.2-----------------------------------------------------
plot(departamentos["departa"], col = "transparent", main = NULL, reset = FALSE)
plot(cuencas["AREA"], add = TRUE, col = "transparent", border = "red")
legend("bottomright", legend = c("Límites departamentales", "Cuencas"), col = c("black", "red"), lty = 1, lwd = 3)
prettymapr::addnortharrow()



## ----plot-departamentos, results='hide', fig.show = 'hide'---------------
plot(departamentos["departa"], col = "transparent", main = NULL, reset = FALSE)
plot(cuencas["AREA"], add = TRUE, col = "transparent", border = "red")
legend("bottomright", legend = c("Límites departamentales", "Cuencas"), col = c("black", "red"), lty = 1, lwd = 3)
prettymapr::addnortharrow()
prettymapr::addscalebar()


## ----ref.label = 'plot-departamentos', echo = FALSE, warning=FALSE, message=FALSE----


## ----plot-prettyCm, results='hide', fig.show = 'hide'--------------------
prettymap(plot(departamentos["departa"],
               col = "transparent", 
               main = "Departamentos"), 
          drawarrow=TRUE)



## ----ref.label = 'plot-prettyCm', echo = FALSE, warning=FALSE, message=FALSE----


## ----plot-prettyKm, results='hide', fig.show = 'hide'--------------------
prettymap(plot(departamentos["departa"],
               col = "transparent", 
               main = "Departamentos"), 
          drawarrow=TRUE, 
          scale.plotepsg = 4326) #<<





## ---- seteoBordes, eval = TRUE-------------------------------------------
bordes <- st_bbox(cuencas)
names(bordes) <- c("left", "bottom", "right", "top")


## ---- plot-descargaGraficaMapa, eval = TRUE, warning=TRUE, fig.show = 'hide', error = TRUE, message=FALSE, cahe = TRUE----
Mapa <- get_stamenmap(bbox = bordes, zoom = 2)



## ---- eval = FALSE-------------------------------------------------------
## try(plot(cuencas["AREA"], axes = TRUE, bgMap= Mapa))


## ----plot-mapaDeFondo, eval = TRUE, fig.show = 'hide'--------------------
cuencas <- st_transform(cuencas, crs = st_crs(3857))
plot(cuencas["AREA"], axes = TRUE, bgMap= Mapa)


## ---- echo = FALSE, warning=FALSE, message=FALSE-------------------------
cuencas <- st_transform(cuencas, crs = st_crs(3857))
plot(cuencas["AREA"], axes = TRUE, bgMap= Mapa)
addnortharrow()
addscalebar()


## ------------------------------------------------------------------------
head(muestreo <- read.table("datos/MuestreoSuelo.txt", header = T, sep = "\t"),8)


## ------------------------------------------------------------------------
head(muestreo <- st_as_sf(muestreo, coords = c("Xt", "Yt"), crs = 32720), 5)



## ------------------------------------------------------------------------

muestreoLatLong <- st_transform(muestreo, st_crs(departamentos))
plot(departamentos["departa"], col = "transparent", reset = FALSE)
plot(muestreoLatLong["Limo"], add = TRUE)




## ------------------------------------------------------------------------
summary(muestreo)


## ---- fig.height = 8.5, fig.width = 13-----------------------------------
plot(muestreo, pch = 18 , cex = 3)


## ----ggplot-cuencas, fig.show = 'hide'-----------------------------------
ggplot(cuencas) +
  geom_sf() 




## ----ggplot-cuencasMuestreo, fig.show = 'hide'---------------------------

ggCuencasMuestero <- ggplot() +
  geom_sf(data = cuencas) +
  geom_sf(data = muestreo, 
          aes( color = Limo), size = 3)




## ---- echo = FALSE, warning=FALSE, message=FALSE-------------------------
ggCuencasMuestero


## ----ggplot-cuencasMuestNA, fig.show = 'hide'----------------------------

ggCuencasMuestero + #<<
  scale_color_continuous(na.value = "red")





## ---- error=TRUE---------------------------------------------------------
st_covers(cuencas, muestreoLatLong)


## ---- results='markup'---------------------------------------------------
cuencasUTM <- st_transform(cuencas, st_crs(muestreo))
lengths(st_covers(cuencasUTM, muestreo))



## ------------------------------------------------------------------------
st_area(cuencas)
lengths(st_covers(cuencasUTM, muestreo))/st_area(cuencasUTM)



## ------------------------------------------------------------------------
puntosKm <- lengths(st_covers(cuencasUTM, muestreo))/units::set_units(st_area(cuencasUTM), km^2)
cuencasUTM$CantidadMuestrasKm <- puntosKm
cuencasUTM$CantidadMuestrasKm


## ------------------------------------------------------------------------
plot(cuencasUTM["CantidadMuestrasKm"])



## ------------------------------------------------------------------------


st_covers(cuencasUTM,muestreo)



## ---- highlight.output=c(1,2,3)------------------------------------------
 mediaCC <- sapply(st_covers(cuencasUTM,muestreo), function(x) {
  mean(muestreo[x,][["CC"]], na.rm = TRUE)
     })
mediaCC




## ----ggplot-cuencasMediaCC, fig.show = 'hide'----------------------------
cuencasUTM$MediaCC <- mediaCC
ggplot(cuencasUTM) +
  geom_sf(aes(fill = MediaCC))





## ----ggplot-cuencasMediaCClab, fig.show = 'hide'-------------------------
ggplot(cuencasUTM) +
  geom_sf(aes(fill = MediaCC)) +
  labs(fill = "Media C.C.")





## ------------------------------------------------------------------------
tm_shape(cuencasUTM) +
  tm_fill()



## ----tmap-cuencasMediaCC, fig.show = 'hide'------------------------------
tm_shape(cuencasUTM) +
  tm_fill("MediaCC") +
  tm_borders()





## ----tmap-cuencasMediaCCquant, fig.show = 'hide', results = 'hide'-------
tm_shape(cuencasUTM) +
  tm_fill("MediaCC", style = "quantile") +
  tm_borders() +
  tm_basemap() 



## ----ref.label = 'tmap-cuencasMediaCCquant', echo = FALSE, warning=FALSE, message=FALSE----


## ----tmap-cuencasMediaCCquantInterac, fig.show = 'hide', results = 'hide'----
tmap_mode("view")
tm_shape(cuencasUTM) +
  tm_fill("MediaCC", style = "quantile") +
  tm_borders() +
  tm_basemap() 



## ----ref.label = 'tmap-cuencasMediaCCquantInterac', echo = FALSE, warning=FALSE, message=FALSE----


## ----tmap-cuencasMediaCCquantInteracFondo, fig.show = 'hide', results = 'hide'----
tmap_mode("view")
tm_shape(cuencasUTM) +
  tm_fill("MediaCC", style = "quantile") +
  tm_borders() +
  tm_basemap() +
  tm_view(alpha = 1, basemaps = "Esri.WorldTopoMap") #<<




## ----ref.label = 'tmap-cuencasMediaCCquantInteracFondo', echo = FALSE, warning=FALSE, message=FALSE----


## ----tmap-cuencasMediaCCicono, fig.show = 'hide', results = 'hide'-------
tmap_mode("plot")
tm_shape(cuencasUTM) +
  tm_fill("MediaCC") +
  tm_borders() +
  tm_basemap() +
  tm_symbols(size = "AREA", 
             shape = tmap_icons("https://png.pngtree.com/svg/20160627/area_1270351.png"))




## ----ref.label = 'tmap-cuencasMediaCCicono', echo = FALSE, warning=FALSE, message=FALSE----


## ----tmap-cuencasSeparadorTexto, fig.show = 'hide', results = 'hide'-----
tm_shape(cuencasUTM) +
  tm_fill("MediaCC", palette="RdYlGn") +
  tm_borders() +
  tm_basemap() +
  tm_symbols(size = "AREA") +
  tm_scale_bar() +
  tm_layout(legend.format = list(text.separator= " a ", text.align = "center"))






## ------------------------------------------------------------------------


tm_shape(cuencasUTM) +
  tm_fill("MediaCC", palette="RdYlGn", title.size = "Media CC") +
  tm_borders() +
  tm_basemap() +
  tm_symbols(size = "AREA", col="blue", title.size = "Area") +
  tm_scale_bar() +
  tm_compass(position = c( "right", "top"))






## ------------------------------------------------------------------------
tm_shape(cuencasUTM) +
  tm_fill("MediaCC", palette="RdYlGn", title.size = "Media CC") +
  tm_borders() +
  tm_basemap() +
  tm_symbols(size = "AREA", col="blue", title.size = "Area") +
  tm_scale_bar() +
  tm_compass(position = c( "right", "top")) +
  tm_legend(
    text.size=1,
    title.size=1.2,
    legend.outside=TRUE,
    frame="gray50",
    height=.6)



## ------------------------------------------------------------------------

tm_shape(cuencasUTM) +
  tm_fill("MediaCC", palette="RdYlGn", title.size = "Media CC") +
  tm_borders() +
  tm_basemap() +
  tm_symbols(size = "AREA", col="blue", title.size = "Area") +
  tm_scale_bar() +
  tm_compass(position = c( "right", "top")) +
  tm_facets("SISTEMA",nrow = 1)


## ------------------------------------------------------------------------


tm_shape(cuencasUTM) +
  tm_fill("MediaCC", palette="RdYlGn", title.size = "Media CC", style = "quantile") +
  tm_borders() +
  tm_symbols(size = "AREA", col="blue", title.size = "Area") +
  tm_facets("SISTEMA")  +
  tm_scale_bar() +
  tm_compass(position = c( "right", "top"))



## ------------------------------------------------------------------------
tm_shape(cuencasUTM) +
  tm_fill("MediaCC", palette="RdYlGn", title.size = "Media CC", style = "quantile") +
  tm_borders() +
  tm_symbols(size = "AREA", col="blue", title.size = "Area") +
  tm_facets("SISTEMA")  +
  tm_scale_bar() +
  tm_compass(position = c( "right", "top")) +
  tm_layout(legend.format = list(text.separator= " a ", text.align = "left"))



## ------------------------------------------------------------------------
tm_shape(cuencasUTM) +
  tm_fill("MediaCC", palette="RdYlGn", title.size = "Media CC", style = "cont",
          textNA="Sin Muestras") +
  tm_borders() +
  tm_facets("SISTEMA")  +
  tm_scale_bar(text.size = 10) +
  tm_compass(type = "rose", position = c( "right", "top"), size = 2)



## ------------------------------------------------------------------------
tmap_cuencas <- tm_shape(cuencasUTM) +
  tm_fill("MediaCC", style = "quantile") +
  tm_borders() +
  tm_basemap() +
  tm_view(alpha = 1, basemaps = "Esri.WorldTopoMap")
tmap_cuencas




## ------------------------------------------------------------------------
tmap_muestreo <-   tm_shape(muestreo) +
  tm_bubbles(col = "K", style = "cont", textNA = "Sin dato") +
  tm_basemap()
tmap_muestreo



## ------------------------------------------------------------------------
tmap_arrange(tmap_cuencas, tmap_muestreo)



## ----tmap-cuencasMuestreo, fig.show = 'hide', results = 'hide'-----------
tm_shape(cuencasUTM) +
  tm_fill("MediaCC", style = "quantile") +
  tm_borders() +
  tm_basemap() +
tm_shape(muestreo) +
  tm_bubbles(col = "K", style = "cont") +
  tm_basemap()






## ------------------------------------------------------------------------

leaflet() %>%
  addTiles() %>%
  addCircles(data = muestreoLatLong) %>%
  addMiniMap(position = "topleft" , width = 150, height = 150)




## ------------------------------------------------------------------------
leaflet() %>%
  addTiles() %>%
  addCircles(data = muestreoLatLong) %>%
  addMiniMap(position = "topleft" , width = 150, height = 150) %>%
  addLogo("https://media.giphy.com/media/l1LcbeAkRm2UrdNio/giphy.gif",
          position = "bottomleft",offset.x = 5, offset.y = 100, width = 480, height = 270) 


## ---- results='asis', echo = FALSE---------------------------------------
PrintBibliography(bib)

