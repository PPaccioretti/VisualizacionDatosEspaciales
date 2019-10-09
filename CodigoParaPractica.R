## ----cargaLibrerias, echo=FALSE, include=FALSE---------------------------
# Esto es un comentario
# Esta es otra linea de comentario
# ahora vamos a sumar algo
2 + 2

#Y podemos almacenar un resultado en un objeto
resultado <- 2 + 2
# para verlo tenemos que "llamar" a ese objeto
resultado


#Comencemos instalando paquetes especializados
libs <- c("sf", "ggmap", "prettymapr",
          "tmap", "leaflet","leafem", "ggplot2","units","ggsn","ggspatial")

new.packages <- libs[!(libs %in% rownames(installed.packages()))]
if(length(new.packages)) install.packages(new.packages)

invisible(sapply(libs, library,character.only = T, quietly=T))









## ------------------------------------------------------------------------
2+2
normalAleatorio <- rnorm(10, mean = 0, sd = 1)
normalAleatorio







## ---- highlight.output=c(1,2,6,9)----------------------------------------
print(departamentos <- read_sf("datos/deptos_cba", stringsAsFactors = TRUE), n = 3)


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
print(cuencas <- read_sf("datos/cuencas_cba/cuencas_cba.gpkg", stringsAsFactors = TRUE), n = 2)



## ------------------------------------------------------------------------
summary(cuencas, maxsum = 3)


## ---- fig.height=7.5-----------------------------------------------------
plot(cuencas)


## ------------------------------------------------------------------------
plot(departamentos["departa"],
     main = NULL, col = "transparent")


## ------------------------------------------------------------------------
plot(cuencas["AREA"],
     main = NULL, col = "transparent")


## ----plot-plotSinEstarJuntos, fig.height=5.5, results='hide', fig.show = 'hide'----
plot(departamentos["departa"], col = "transparent", main = NULL,
     reset = FALSE) #<<
plot(cuencas["AREA"], col = "transparent",
     add = TRUE) #<<


## ----ref.label = 'plot-plotSinEstarJuntos', fig.height=5.2, echo = FALSE, warning=FALSE, message=FALSE----




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
print(cuencas, n = 4)


## ------------------------------------------------------------------------
plot(departamentos["departa"], col = "transparent", main = NULL, reset = FALSE)
plot(cuencas["AREA"], col = "transparent", add = TRUE)





## ------------------------------------------------------------------------
plot(departamentos["departa"], col = "transparent", main = NULL, reset = FALSE)
plot(cuencas["AREA"], col = "transparent", add = TRUE, border = "red")


## ---- fig.height = 5.3---------------------------------------------------
plot(departamentos["departa"], col = "transparent", main = NULL, reset = FALSE)
plot(cuencas["AREA"], col = "transparent", add = TRUE, border = "red")
legend("bottomright", legend = c("Límites departamentales", "Cuencas"), col = c("black", "red"), lty = 1, lwd = 3)


## ---- fig.height=5.2-----------------------------------------------------
plot(departamentos["departa"], col = "transparent", main = NULL, reset = FALSE)
plot(cuencas["AREA"], col = "transparent", add = TRUE, border = "red")
legend("bottomright", legend = c("Límites departamentales", "Cuencas"), col = c("black", "red"), lty = 1, lwd = 3)
prettymapr::addnortharrow()



## ----plot-departamentos, results='hide', fig.show = 'hide'---------------
plot(departamentos["departa"], col = "transparent", main = NULL, reset = FALSE)
plot(cuencas["AREA"], col = "transparent", add = TRUE, border = "red")
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


## ----plot-prettyKm, results='hide', fig.show = 'hide', fig.height=5.5, fig.width=3----
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
plot(cuencas["AREA"], axes = TRUE, col = "transparent", bgMap= Mapa)
addnortharrow()
addscalebar()


## ------------------------------------------------------------------------
muestreo <- read.table("datos/MuestreoSuelo.txt", header = T, sep = "\t")


## ---- eval = FALSE, echo=FALSE-------------------------------------------
## muestreo




## ------------------------------------------------------------------------
print(muestreo <- st_as_sf(muestreo, coords = c("Xt", "Yt"), crs = 32720), n = 5)



## ------------------------------------------------------------------------
summary(muestreo)


## ---- fig.height = 8.5, fig.width = 13-----------------------------------
plot(muestreo, pch = 18 , cex = 3)


## ------------------------------------------------------------------------

ggplot(muestreo) +
  geom_sf()



## ------------------------------------------------------------------------
ggplot(muestreo) +
  geom_sf(aes(fill = Limo), shape = 22, size = 3)



## ------------------------------------------------------------------------

ggplot(muestreo) +
  geom_sf(aes(fill = Limo), shape = 22, size = 3) +
  geom_sf(data = departamentos)



## ------------------------------------------------------------------------
ggplot(muestreo) +
  geom_sf(data = departamentos) +
  geom_sf(aes(fill = Limo), shape = 22, size = 3) 
 


## ------------------------------------------------------------------------
ggplot() 


## ------------------------------------------------------------------------
ggplot() +
  geom_sf(data = cuencas)


## ------------------------------------------------------------------------
ggplot() +
  geom_sf(data = cuencas) +
  geom_sf(data = muestreo)


## ---- fig.height=5.5-----------------------------------------------------
ggCuencasMuestero <- ggplot() +
  geom_sf(data = cuencas) +
  geom_sf(data = muestreo, aes(color = Limo), size = 3) 
ggCuencasMuestero


## ----ggplot-cuencasMuestreo, fig.show = 'hide'---------------------------
ggCuencasMuestero + #<<
  scale_color_continuous(type = "viridis")


## ---- ref.label='ggplot-cuencasMuestreo', echo = FALSE, warning=FALSE, message=FALSE----


## ----ggplot-cuencasMuestNA, fig.show = 'hide'----------------------------

ggCuencasMuestero + #<<
  scale_color_continuous(type = "viridis", na.value = "pink")





## ---- error=TRUE---------------------------------------------------------
muestreoLatLong <- st_transform(muestreo, st_crs(departamentos))
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
 mediaLimo <- sapply(st_covers(cuencasUTM,muestreo), function(x) {
  mean(muestreo[x,][["Limo"]], na.rm = TRUE)
     })
mediaLimo




## ----ggplot-cuencasMediaLimo, fig.show = 'hide'--------------------------
cuencasUTM$MediaLimo <- mediaLimo
ggplot(cuencasUTM) +
  geom_sf(aes(fill = MediaLimo))





## ----ggplot-cuencasMediaLimolab, fig.show = 'hide'-----------------------
ggplot(cuencasUTM) +
  geom_sf(aes(fill = MediaLimo)) +
  labs(fill = "Limo (%)")





## ---- fig.height=5-------------------------------------------------------
ggplot(cuencasUTM) +
  geom_sf(aes(fill = MediaLimo)) +
  labs(fill = "Limo (%)") + 
  ggsn::scalebar(cuencasUTM, dist = 50, transform = FALSE, dist_unit = "km")




## ---- fig.height=5-------------------------------------------------------

ggplot(cuencasUTM) +
  geom_sf(aes(fill = MediaLimo)) +
  labs(fill = "Limo (%)") + 
  ggsn::scalebar(cuencasUTM, dist = 50, transform = FALSE, dist_unit = "km") + 
  ggspatial::annotation_north_arrow(location = "tr", which_north = "grid")



## ------------------------------------------------------------------------
tm_shape(cuencasUTM) +
  tm_fill()



## ----tmap-cuencasMediaLimoSB---------------------------------------------
tm_shape(cuencasUTM) +
  tm_fill("MediaLimo")



## ----tmap-cuencasMediaLimo, fig.show = 'hide'----------------------------
tm_shape(cuencasUTM) +
  tm_fill("MediaLimo") +
  tm_borders()





## ------------------------------------------------------------------------
tm_shape(cuencasUTM) +
  tm_fill("MediaLimo", style = "quantile") +
  tm_borders() 


## ------------------------------------------------------------------------
tm_shape(cuencasUTM) +
  tm_fill("MediaLimo", style = "cont") +
  tm_borders() 


## ----tmap-cuencasMediaLimoContInterac, fig.show = 'hide', results = 'hide'----
tmap_mode("view")
tm_shape(cuencasUTM) +
  tm_fill("MediaLimo", style = "cont") +
  tm_borders() +
  tm_basemap("Esri.WorldTopoMap")




## ----ref.label = 'tmap-cuencasMediaLimoContInterac', echo = FALSE, warning=FALSE, message=FALSE----


## ----tmap-cuencasMediaLimoquantInteracFondo, fig.show = 'hide', results = 'hide'----
tmap_mode("view")
tm_shape(cuencasUTM) +
  tm_fill("MediaLimo", style = "quantile", alpha = 0.8) +
  tm_borders() +
  tm_basemap(c(
    "Stamen.Watercolor",
    "Esri",
    "OpenTopoMap",
    "Stamen.Terrain")) 
# names(leaflet::providers)




## ----tmap-cuencasUTMPllette, fig.show = 'hide', results = 'hide'---------
tmap_mode("plot")
cuencas_tmap <- tm_shape(cuencasUTM) +
  tm_fill("MediaLimo", 
          style = "cont", 
          palette = c("red", "blue"),
          textNA = "Sin Datos",
          title.size = "Media Limo") +
  tm_borders() +
  tm_legend(
    text.size=1,
    title.size=1.2,
    legend.outside=TRUE,
    frame="gray50",
    height=.6)
cuencas_tmap #<<





## ----tmap-muestreoNA, fig.show = 'hide', results = 'hide'----------------
muestreo_tmap <- tm_shape(muestreo) +
  tm_dots("Limo", size = 0.5,
          palette = "BuGn", colorNA= NULL,
          legend.hist=T) +
  tm_layout(legend.format = list(text.separator= " a "),
            legend.outside = TRUE,
            legend.hist.width = 2.5)
muestreo_tmap #<<









## ----tmap-doscapas, fig.show = 'hide', results = 'hide'------------------
tm_shape(cuencasUTM) +
  tm_fill("MediaLimo", 
          style = "cont", 
          palette = c("red", "blue"),
          textNA = "Sin Datos",
          title.size = "Media Limo") +
  tm_borders() +
  tm_legend(
    text.size=1,
    title.size=1.2,
    legend.outside=TRUE,
    frame="gray50",
    height=.6) +
  tm_shape(muestreo) +
  tm_dots("Limo", size = 0.5,
          palette = "BuGn", colorNA= NULL,
          legend.hist=T) +
  tm_layout(legend.format = list(text.separator= " a "),
            legend.outside = TRUE,
            legend.hist.width = 2.5)




## ----tmap-dosObjetos, fig.show = 'hide', results = 'hide'----------------
cuencas_tmap +
muestreo_tmap




## ----tmap-escala, fig.show = 'hide', results = 'hide'--------------------
cuencas_tmap +
muestreo_tmap +
  tm_scale_bar() +
  tm_compass(position = c( "right", "top"))





## ---- fig.height=4.5-----------------------------------------------------
tmap_cuencas <- tm_shape(cuencasUTM) +
  tm_fill("MediaLimo", style = "quantile") +
  tm_borders() +
  tm_legend(legend.outside = TRUE)
tmap_cuencas




## ---- fig.height=4.5-----------------------------------------------------
tmap_muestreo <-   tm_shape(muestreo) +
  tm_bubbles(col = "K", style = "cont", textNA = "Sin dato") +
  tm_legend(legend.outside = TRUE)
tmap_muestreo



## ---- fig.width=7--------------------------------------------------------
tmap_arrange(tmap_cuencas, tmap_muestreo)



## ---- fig.width=4--------------------------------------------------------
tmap_mode("view")
tm_shape(cuencasUTM) +
  tm_fill("MediaLimo", palette="RdYlGn", title.size = "Media Limo") +
  tm_borders() +
  tm_facets("SISTEMA", nrow = 1, sync = TRUE) +
  tm_basemap("OpenStreetMap") +
  tmap_options(limits = c(facets.view = 7))



## ------------------------------------------------------------------------

leaflet() %>%
  addTiles() %>%
  addCircles(data = muestreoLatLong) %>%
  addMiniMap(position = "topleft" , width = 150, height = 150,toggleDisplay = TRUE) 




## ------------------------------------------------------------------------
leaflet() %>%
  addTiles() %>%
  addCircles(data = muestreoLatLong) %>%
  addLogo("https://media.giphy.com/media/l1LcbeAkRm2UrdNio/giphy.gif",
          position = "bottomleft",offset.x = 5, offset.y = 100, width = 480, height = 270)

