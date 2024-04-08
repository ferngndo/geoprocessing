install.packages('sf') # simple features / objetos geometris, biblioteca lida com esses dados
library(sf)

# Pontos

pnt1 <- sf::st_point(x = c(4,3)) # vc pode ou nao chamar o biblioteca
pnt1

pnt2 <- st_point(c(1,1))
pnt3 <- st_point(c(4,1))

class(pnt2)

# Multipontos

mtx <- matrix(c(pnt1, pnt2, pnt3, pnt1), 4)
mtx

mp <- st_multipoint(mtx)
plot(mp, col='red', pch=19)

# Linhas

lt1 <- st_linestring(c(pnt1, pnt2))
lt2 <- st_linestring(c(pnt2, pnt3))
lt3 <- st_linestring(c(pnt3, pnt1))

plot(lt1)
plot(lt2)
plot(lt3)

# Multilinhas

mls1 <- st_multilinestring(list(mp)) 
mls2 <- st_multilinestring(list(lt1, lt2, lt3)) # outra forma 


plot(mls2)

install.packages('ggplot2')
# diferença do plot para ggplot é que na ggplot a gente consegue ter a dimensão de área; preenchido
library(ggplot2)

ggplot() +
  geom_sf(data = mls1, colour='purple')

# Poligonos

pol <- st_polygon(mls1)
class(pol)

ggplot() +
  geom_sf(data=pol, colour='purple')

# Operações

d_pnts <- st_distance(pnt1, pnt2)
d_pnts

c_lt1 <- st_centroid(lt1)
c_lt1

l_len <- st_length(mls1)
l_len

a_pol <- st_area(pol)
a_pol

cat('A distancia entre o ponto 1 e o ponto 2 é:',
    d_pnts, '\nA área do meu poligono é:', a_pol)

rm(pnt1, pnt2, pnt3, pol, lt1, lt2,lt3,mls,d_pnts, c_l1, l_len, a_pol) # limpar o environment ; todas as variaveis que eu chamei

install.packages('geobr')
library(geobr)
help(geobr)
View(list_geobr())

#Mapa Amazônia Legal Brasil

br <- read_country(year =2020)
plot(br)

amazon <- read_amazon()

plot(amazon$geom)
plot(amazon$geom, col='green')

#Coordinate Reference System = Sistema de Referencia de Coordenadas

st_crs(br) 
st_crs(amazon)

st_crs(br) == st_crs(amazon)

ggplot() +
    geom_sf(data = amazon, 
          fill= 'lightgreen',
          color='darkgreen') +
    geom_sf(data = br,
          fill= NA,
          color='white')

# Donwload e pasta temporaria

url_file <- "http://terrabrasilis.dpi.inpe.br/download/dataset/legal-amz-aux/vector/conservation_units_legal_amazon.zip"

dest_file1 <- tempfile()

download.file(url = url_file, destfile = dest_file1)

# Descompactar

dest_file2 <- tempfile()

unzip(zipfile = dest_file1, exdir = dest_file2)

dir(dest_file2) # tudo que tem na pasta

uc <- st_read(dsn = file.path(dest_file2,
                              layer='conservation_units_legal_amazon.shp'))

str(uc) # outra forma de visualizar as informações
View(uc) # outra forma de visualizar as informações

# Mapa Unidades de Conservação criadas desde 2000 na Amazônia Legal Brasileira

uc$ano_cria[uc$ano_cria=='e 2016 de 11/05/2016'] <- '2016'

unique(uc$ano_cria)

sort(unique(uc$ano_cria))

uc$ano_cria <- as.numeric(uc$ano_cria)
sort(unique(uc$ano_cria))
str(uc)

# [linhas, colunas]
uc_rec <- uc[uc$ano_cria>=2000, ] # depois da virgula significa que quero todas as colunas
View(uc_rec)

# exportação
st_write(uc_rec, '/Users/Samsung/OneDrive/Área de Trabalho/scripts-r/UCs_Recortadas_AM_Legal.shp')

unique(uc_rec$categoria)
length(unique(uc_rec$categoria))

colors()

paletta11 <- c('#8dd3c7','#ffffb3','#bebada','#fb8072','#80b1d3','#fdb462','#b3de69','#fccde5','#d9d9d9','#bc80bd','#ccebc5')

ggplot() +
  # camada do Brasil
  geom_sf(data=br,
          fill='beige', # preenchimento
          color='gray', # contorno
          size=2) + # espessura da linha
  
  # camada amazonia brasileira
  geom_sf(data=amazon,
          fill='lightgreen', # preenchimento
          color='darkgreen', # contorno
          alpha=0.5) + # transparencia

  # camada unidades de conservação
  geom_sf(data = uc_rec,
          aes(fill = categoria), color=NA) + # aes (identifica as classe da coluna categoria e coloca cor aleatoria)
  
  # definir a paleta de cores
  scale_fill_manual(values=paletta11, 
                    name=NULL) +
  
  # etiquetas
  labs(title='UCs criadas a partir dos anos 2000 na Amazônia Legal Brasileira',
       subtitle='Categorizadas por tipo de unidades',
       caption = 'DATUM SIRGAS 2000 | Sistema de Coordenadas Geográficas | Fonte: CNUC e MMA (2022); IBGE (2000) | Elaboração: Fernando Gomes (2023) ') +
  
  # personalização
  theme(
    #estetica do titulo
    plot.title = element_text(
      face='bold',
      size=16),
    # posicao da legenda
    legend.position = 'bottom',
    #estetica legenda
    legend.text=element_text(face='bold'),
    #estitica do fundo
    panel.background = element_rect(fill='white'),
    #estetica grades
    panel.grid.major = element_line(colour='lightgray',
                                    linetype='twodash')
  ) +
  # limites x e y do gráfico
  xlim(75, 42) +
  ylim(18, -8) -> mapa1

mapa1    

install.packages('ggspatial')
library(ggspatial)

mapa1 +
  # escala
  annotation_scale(
    location='bl',
    bar_cols=c('grey', 'white')
  ) +
  
  # seta norte
  annotation_north_arrow(
    location='tr',
    height = unit(1.0, 'cm'),
    width = unit(1.0, 'cm'),
    pad_x = unit(0.3, 'cm'),
    pad_y = unit(0.3, 'cm'),
    style = north_arrow_fancy_orienteering(
      fill= c('gray40', 'white'),
      line_col='gray20')
  ) -> mapa2

mapa2

ggsave(
  filename = '/Users/Samsung/OneDrive/Área de Trabalho/scripts-r/Mapa_UCs_2.png',
  plot = mapa2,
  width = 1080,
  height = 1080,
  units = 'px', #pixels
  scale = 3
)






# ---------------------------------------------- #


View(list_geobr())

br <- read_country(year =2020)
plot(br)

biomas <- read_biomes(year=2019)
plot(biomas)

unique(biomas$name_biome)

biomas_rec <- biomas[biomas$name_biome!='Sistema Costeiro', ] 
View(biomas_rec)

st_crs(br) == st_crs(biomas)
st_crs(biomas)

ggplot() +
  # camada do Brasil
  geom_sf(data=br,
          fill='beige', # preenchimento
          color='gray', # contorno
          size=8) + # espessura da linha
  
  # camada unidades de conservação
  geom_sf(data = biomas_rec,
          aes(fill = name_biome), color=NA) + # aes (identifica as classe da coluna categoria e coloca cor aleatoria)
  
  # definir a paleta de cores
  scale_fill_manual(values=paletta11, 
                    name=NULL) +
  
  # etiquetas
  labs(title='Biomas do Brasil',
       caption = 'DATUM SIRGAS 2000 | Sistema de Coordenadas Geográficas | Fonte: IBGE (2019) | Elaboração: Fernando Gomes (2023)') +
  
  # personalização
  theme(
    #estetica do titulo
    plot.title = element_text(
      face='bold',
      size=16),
    # posicao da legenda
    legend.position = 'bottom',
    #estetica legenda
    legend.text=element_text(face='bold'),
    #estitica do fundo
    panel.background = element_rect(fill='white'),
    #estetica grades
    panel.grid.major = element_line(colour='black',
                                    linetype='solid')+
      
    # escala
    annotation_scale(
      location='bl',
      bar_cols=c('grey', 'white')
    ) +
      
      # seta norte
    annotation_north_arrow(
      location='tr',
      height = unit(1.0, 'cm'),
      width = unit(1.0, 'cm'),
      pad_x = unit(0.3, 'cm'),
      pad_y = unit(0.3, 'cm'),
      style = north_arrow_fancy_orienteering(
       fill= c('gray40', 'white'),
       line_col='gray20')
)) -> mapa_bioma
  
mapa_bioma +
  annotation_scale(
  location='bl',
  bar_cols=c('grey', 'white')
) +
  
  # seta norte
  annotation_north_arrow(
    location='tr',
    height = unit(1.0, 'cm'),
    width = unit(1.0, 'cm'),
    pad_x = unit(0.3, 'cm'),
    pad_y = unit(0.3, 'cm'),
    style = north_arrow_fancy_orienteering(
      fil= c('gray40', 'white'),
      line_col='gray20')
  ) -> mapa_bioma2

mapa_bioma2  

ggsave(
  filename = '/Users/Samsung/OneDrive/Área de Trabalho/scripts-r/Fernando_de_Oliveira_Gomes_MapaBiomas_R.png',
  plot = mapa_bioma2,
  width = 1080,
  height = 1080,
  units = 'px', #pixels
  scale = 3
)
