#####################################################################################
# Actividades prácticas para visualizar datos espaciales                            #
#####################################################################################


## leer un archivo de formato deptos_cba.shp que se encuentra en la 
# carpeta datos
## con la función read_sf() y asignarlo a un objeto denominado deptos
library(sf)
deptos<- read_sf("datos/deptos_cba/deptos_cba.shp")
head(deptos)
## visualizar las primeras columnas del nuevo objeto deptos

names(deptos)

## Obtener una estadística descriptiva sobre el objeto deptos

summary(deptos)

## realizar un gráfico del objeto deptos con la función plot 

plot(deptos)

## realizar un grafico de los departamentos de la provincia de Cordoba y las cabeceras
## no colocar la escala de colores, poner el nombre a cada grafico

plot(deptos["departa"], key.pos=NULL, main = "Departamentos de Córdoba")

?plot.sf

## leer el archivo cuencas_cba.gpkg desde la carpeta cuencas_cba en datos
## guardarlo en un objeto denominado cuencas

cuencas <- read_sf("datos/cuencas_cba/cuencas_cba.gpkg")

## graficar el objeto cuencas con la funcion plot, sin titulo y de fondo transparente

plot(cuencas)
names(cuencas)

## graficar la columna denominada AREA del objeto cuencas, sin titulo y transparente

plot(cuencas["AREA"], main = "", col=NA, reset = FALSE)
plot(deptos["departa"], main = NULL, col=NA, add=TRUE)


## recuperar el sistema de coordenadas de referencia desde un objeto con la 
## funcion st_crs

st_crs(deptos)==st_crs(cuencas)

# ambos objetos estan en el mismo sistema de coordenadas?

st_crs(deptos)==st_crs(cuencas)
## usar la funcion st_transform() para transformar las coordenadas de un objeto sf

cuencas <- st_transform(cuencas, st_crs(deptos))
st_crs(deptos)==st_crs(cuencas)
## recuperar las coordenadas del objeto



## corroborar que sean iguales





## ahora si superponer los deptos y las areas en un unico grafico con la funcion plot
## de fondo transparente

plot(cuencas["AREA"], main = "", col=NA, reset =F )
plot(deptos["departa"], main = NULL, col=NA, add=TRUE, border="turquoise1")
legend("bottomleft", legend=c("Límite departamentales","Cuencas"), col = c("black","turquoise1"), lty=1, lwd=3)
prettymapr::addnortharrow()
prettymapr::addscalebar()
colors()

##cambiar el color de las areas en azul



## agregar leyendas con funcion legenda, la flecha cardinal y la escala

prettymap({plot(cuencas["AREA"], main = "", col=NA, reset =F )
  plot(deptos["departa"], main = NULL, col=NA, add=TRUE, border="turquoise1")},drawarrow = TRUE, scale.plotepsg = 4326)









## leer el archivo MuestreoSuelo.txt desde la carpeta datos, recordar que el separador
## entre columnas es tabulador \t

suelo <- read.table("datos/MuestreoSuelo.txt", header = TRUE, sep = "\t")
dim(suelo)
class(suelo)
head(suelo)

## convertir a sf con la funcion st_as_sf guardar en el objeto muestreo

suelo_sf <-st_as_sf(suelo, coords = c("Xt","Yt"), crs=32720) 

## graficar con la funcio plot

class(suelo_sf)
head(suelo_sf)


## ahora graficar con la funcion ggplot

plot(suelo_sf, pch=18, cex=0.9)

library(ggplot2)

PlotMuestreo <- ggplot(suelo_sf) +
  geom_sf(data = deptos) +
  geom_sf(aes(color = Limo)) + 
  scale_color_continuous(type = "viridis") +
  labs(title="Muestero", color = "Limo (%)")
#

ggsave("Muestreo.png")

## adicionar la capa de la variable CC con la funcion geom_sf










