#####################################################################################
# Actividades prácticas para visualizar datos espaciales                            #
#####################################################################################


## leer un archivo de formato deptos_cba.shp que se encuentra en la carpeta datos
## con la función read_sf() y asignarlo a un objeto denominado deptos



## visualizar las primeras columnas del nuevo objeto deptos



## Obtener una estadística descriptiva sobre el objeto deptos



## realizar un gráfico del objeto deptos con la función plot 



## realizar un grafico de los departamentos de la provincia de Cordoba y las cabeceras
## no colocar la escala de colores, poner el nombre a cada grafico





## leer el archivo cuencas_cba.gpkg desde la carpeta cuencas_cba en datos
## guardarlo en un objeto denominado cuencas



## graficar el objeto cuencas con la funcion plot, sin titulo y de fondo transparente



## graficar la columna denominada AREA del objeto cuencas, sin titulo y transparente




## recuperar el sistema de coordenadas de referencia desde un objeto con la 
## funcion st_crs



# ambos objetos estan en el mismo sistema de coordenadas?


## usar la funcion st_transform() para transformar las coordenadas de un objeto sf


## recuperar las coordenadas del objeto



## corroborar que sean iguales





## ahora si superponer los deptos y las areas en un unico grafico con la funcion plot
## de fondo transparente





##cambiar el color de las areas en azul



## agregar leyendas con funcion legenda, la flecha cardinal y la escala











## leer el archivo MuestreoSuelo.txt desde la carpeta datos, recordar que el separador
## entre columnas es tabulador \t



## convertir a sf con la funcion st_as_sf guardar en el objeto muestreo



## graficar con la funcio plot




## ahora graficar con la funcion ggplot





## adicionar la capa de la variable CC con la funcion geom_sf










