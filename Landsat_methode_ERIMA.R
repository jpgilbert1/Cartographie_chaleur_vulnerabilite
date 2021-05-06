####Il y a un algo ecrit par un auteur (voir note 14 avril 2021). Donc ici pour l'instant seulement telechargement des (Ermedia) ####
#nom de l'article : Google Earth Engine Open-Source Code for Land Surface Temperature Estimation from the Landsat Series
#La majorite de l'algo est https://code.earthengine.google.com/?accept_repo=users/wangmmcug/landsat_psc_lst
#ce code sert simplement à acquiérir des métadonnées.
### Metadonnees
library(tidyverse)
library(reticulate)
library(rgee)
library(plyr)
ee_Initialize()

#pour 2015
image_2015 <- list.files(path="/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Landsat_methode_Ermedia/GEE_QC_2015")
for (i in 1:length(image_2015))
{
  image_2015[i] <- str_remove(image_2015[i], ".tif")
  image_2015[i] <- paste0("LANDSAT/LC08/C01/T1_SR/", image_2015[i])
}

for (i in 1:(length(image_2015)-2))
{
  image_landsat <- ee$Image(image_2015[i])
  metadata <- image_landsat$getInfo()
  metadata <- metadata$properties
  if(i == 1)
  {
    df <- data.frame(matrix(metadata, nrow=1, byrow=TRUE))
  }else
  {
    df <- rbind(df,data.frame(matrix(metadata, nrow=1, byrow=TRUE)))
  }
}
colnames(df) <- names(metadata)
save(df, file = "/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Landsat_methode_Ermedia/GEE_QC_2015/Metadata/Metadata_2015.rda")

#pour 2016
image_2016 <- list.files(path="/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Landsat_methode_Ermedia/GEE_QC_2016")
for (i in 1:length(image_2016))
{
  image_2016[i] <- str_remove(image_2016[i], ".tif")
  image_2016[i] <- paste0("LANDSAT/LC08/C01/T1_SR/", image_2016[i])
}

for (i in 1:(length(image_2016) -2))
{
  image_landsat <- ee$Image(image_2016[i])
  metadata <- image_landsat$getInfo()
  metadata <- metadata$properties
  if(i == 1)
  {
    df <- data.frame(matrix(metadata, nrow=1, byrow=TRUE))
    colnames(df) <- names(metadata)
  }else
  {
    df_2 <- data.frame(matrix(metadata, nrow=1, byrow=TRUE))
    colnames(df_2) <- names(metadata)
    df <- rbind.fill(df,df_2)
  }
}
colnames(df) <- names(metadata)
save(df, file = "/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Landsat_methode_Ermedia/GEE_QC_2016/Metadata/Metadata_2016.rda")

#pour 2017
image_2017 <- list.files(path="/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Landsat_methode_Ermedia/GEE_QC_2017")
for (i in 1:length(image_2017))
{
  image_2017[i] <- str_remove(image_2017[i], ".tif")
  image_2017[i] <- paste0("LANDSAT/LC08/C01/T1_SR/", image_2017[i])
}

for (i in 1:length(image_2017))
{
  image_landsat <- ee$Image(image_2017[i])
  metadata <- image_landsat$getInfo()
  metadata <- metadata$properties
  if(i == 1)
  {
    df <- data.frame(matrix(metadata, nrow=1, byrow=TRUE))
  }else
  {
    df <- rbind(df,data.frame(matrix(metadata, nrow=1, byrow=TRUE)))
  }
}
colnames(df) <- names(metadata)
save(df, file = "/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Landsat_methode_Ermedia/GEE_QC_2017/Metadata/Metadata_2017.rda")

#2018
image_2018 <- list.files(path="/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Landsat_methode_Ermedia/GEE_QC_2018")
for (i in 1:length(image_2018))
{
  image_2018[i] <- str_remove(image_2018[i], ".tif")
  image_2018[i] <- paste0("LANDSAT/LC08/C01/T1_SR/", image_2018[i])
}

for (i in 1:length(image_2018))
{
  image_landsat <- ee$Image(image_2018[i])
  metadata <- image_landsat$getInfo()
  metadata <- metadata$properties
  if(i == 1)
  {
    df <- data.frame(matrix(metadata, nrow=1, byrow=TRUE))
    colnames(df) <- names(metadata)
  }else
  {
    df_2 <- data.frame(matrix(metadata, nrow=1, byrow=TRUE))
    colnames(df_2) <- names(metadata)
    df <- rbind.fill(df,df_2)
  }
}
#colnames(df) <- names(metadata)
save(df, file = "/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Landsat_methode_Ermedia/GEE_QC_2018/Metadata/Metadata_2018.rda")

#pour 2019
image_2019 <- list.files(path="/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Landsat_methode_Ermedia/GEE_QC_2019")
for (i in 1:length(image_2019))
{
  image_2019[i] <- str_remove(image_2019[i], ".tif")
  image_2019[i] <- paste0("LANDSAT/LC08/C01/T1_SR/", image_2019[i])
}

for (i in 1:length(image_2019))
{
  image_landsat <- ee$Image(image_2019[i])
  metadata <- image_landsat$getInfo()
  metadata <- metadata$properties
  if(i == 1)
  {
    df <- data.frame(matrix(metadata, nrow=1, byrow=TRUE))
  }else
  {
    df <- rbind(df,data.frame(matrix(metadata, nrow=1, byrow=TRUE)))
  }
}
colnames(df) <- names(metadata)
save(df, file = "/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Landsat_methode_Ermedia/GEE_QC_2019/Metadata/Metadata_2019.rda")

#pour 2020
image_2020 <- list.files(path="/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Landsat_methode_Ermedia/GEE_QC_2020")
for (i in 1:length(image_2020))
{
  image_2020[i] <- str_remove(image_2020[i], ".tif")
  image_2020[i] <- paste0("LANDSAT/LC08/C01/T1_SR/", image_2020[i])
}

for (i in 1:length(image_2020))
{
  image_landsat <- ee$Image(image_2020[i])
  metadata <- image_landsat$getInfo()
  metadata <- metadata$properties
  if(i == 1)
  {
    df <- data.frame(matrix(metadata, nrow=1, byrow=TRUE))
  }else
  {
    df <- rbind(df,data.frame(matrix(metadata, nrow=1, byrow=TRUE)))
  }
}
colnames(df) <- names(metadata)
save(df, file = "/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Landsat_methode_Ermedia/GEE_QC_2020/Metadata/Metadata_2020.rda")

#Les données ont été évalué, et chaque bonne image a été garder. Je vais donc créer des métadonnées avec les bonnes images pour pouvoir extraire
#de nouvelles images avec une méthode différente afin de comparer.

library(tidyverse)
meta_data_bonne_image <- function(path_fichier, path_metadonnees,path_output)
{
  bonne_images <- list.files(path=path_fichier)
  bonne_images <- str_remove(bonne_images, '.tif')
  load(path_metadonnees)
  df <- df[which(df$`system:index` %in% bonne_images),]
  save(df, file = path_output)
}

meta_data_bonne_image("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Ermedia/GEE_QC_2015/Reproject/Bonne",
                      '/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Ermedia/GEE_QC_2015/Metadata/Metadata_2015.rda',
                      '/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Ermedia/GEE_QC_2015/Metadata/Metadata_2015_bonne.rda')

meta_data_bonne_image("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Ermedia/GEE_QC_2016/Reproject/Bonne",
                      '/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Ermedia/GEE_QC_2016/Metadata/Metadata_2016.rda',
                      '/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Ermedia/GEE_QC_2016/Metadata/Metadata_2016_bonne.rda')

meta_data_bonne_image("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Ermedia/GEE_QC_2017/Reproject/Bonne",
                      '/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Ermedia/GEE_QC_2017/Metadata/Metadata_2017.rda',
                      '/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Ermedia/GEE_QC_2017/Metadata/Metadata_2017_bonne.rda')

meta_data_bonne_image("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Ermedia/GEE_QC_2018/Reproject/Bonne",
                      '/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Ermedia/GEE_QC_2018/Metadata/Metadata_2018.rda',
                      '/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Ermedia/GEE_QC_2018/Metadata/Metadata_2018_bonne.rda')

meta_data_bonne_image("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Ermedia/GEE_QC_2019/Reproject/Bonne",
                      '/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Ermedia/GEE_QC_2019/Metadata/Metadata_2019.rda',
                      '/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Ermedia/GEE_QC_2019/Metadata/Metadata_2019_bonne.rda')

meta_data_bonne_image("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Ermedia/GEE_QC_2020/Reproject/Bonne",
                      '/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Ermedia/GEE_QC_2020/Metadata/Metadata_2020.rda',
                      '/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Ermedia/GEE_QC_2020/Metadata/Metadata_2020_bonne.rda')
