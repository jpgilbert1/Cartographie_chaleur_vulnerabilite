#### Installation du package Google Earth Engine et de tous ce qu'il a besoin ####
##source : https://github.com/r-spatial/rgee

#install.packages("rgee")

library(remotes)
#install_github("r-spatial/rgee")
library(rgee)
rgee::ee_install()
ee_check()


#### Une fois que tout est ok (on le vois avec ee_check()), il faut synchroniser python et R####

library(reticulate)
library(rgee)


#### Changement de plan: Il y a un algo ecrit par un auteur (voir note 14 avril 2021). Donc ici pour l'instant seulement telechargement des (Ermedia)
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

#####Methode wang 2020
library("readxl")

Image_dispo_2015 <-read_excel('/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Info_landsat_2015.xlsx')
Image_dispo_2016 <-read_excel('/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Info_landsat_2016.xlsx')
Image_dispo_2017 <-read_excel('/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Info_landsat_2017.xlsx')
Image_dispo_2018 <-read_excel('/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Info_landsat_2018.xlsx')
Image_dispo_2019 <-read_excel('/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Info_landsat_2019.xlsx')
Image_dispo_2020 <-read_excel('/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Info_landsat_2020.xlsx')

extraction_date <- function(df)
{
  df$Year <- as.numeric(substr(df$Date, start = 1, stop = 4))
  df$Month <- as.numeric(substr(df$Date, start = 6, stop = 7))
  df$Day <- as.numeric(substr(df$Date, start = 9, stop = 10))
  return(df)
}

Image_dispo_2015 <- extraction_date(Image_dispo_2015)
Image_dispo_2016 <- extraction_date(Image_dispo_2016)
Image_dispo_2017 <- extraction_date(Image_dispo_2017)
Image_dispo_2018 <- extraction_date(Image_dispo_2018)
Image_dispo_2019 <- extraction_date(Image_dispo_2019)
Image_dispo_2020 <- extraction_date(Image_dispo_2020)

Image_dispo <- do.call('rbind', list(Image_dispo_2015,Image_dispo_2016,Image_dispo_2017,Image_dispo_2018,Image_dispo_2019,Image_dispo_2020))
Image_journee_chaude <- Image_dispo[1,]
for (i in 1:nrow(Image_dispo))
{
 for (j in 1:nrow(fichier_journees_chaudes))
 {
   if(as.character(Image_dispo$Date[i]) == fichier_journees_chaudes$Date.Heure[j])
   {
     Image_journee_chaude <- rbind(Image_journee_chaude, Image_dispo[i,])
   }
 }
  print(i)
}
Image_journee_chaude <- Image_journee_chaude[-1,]

write.csv(Image_journee_chaude, '/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Image_chaude.csv')

##Mettre toutes les images de la même date ensemble, dans un meme fichier
library(filesstrings)

image_wang_2015 <- list.files(path = "/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2015"
                              , pattern = "tif")
image_wang_2015_full <- list.files(path = "/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2015"
                              , pattern = "tif"
                              ,full.names = TRUE)
image_wang_2015 <- str_remove(image_wang_2015, '_LST.tif')


for(i in 1:length(image_wang_2015))
{
  test <- Image_journee_chaude[which(Image_journee_chaude$Landsat_id %in% image_wang_2015[i] ), ] 
  if(as.character(test$Date) %in% list.files(path = "/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2015"))
  {
    nom_dossier <- paste0("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2015/",as.character(test$Date))
    file.move(image_wang_2015_full[i], nom_dossier)
  }else
  {
    dir.create(paste0("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2015/",as.character(test$Date)))
    nom_dossier <- paste0("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2015/",as.character(test$Date))
    file.move(image_wang_2015_full[i], nom_dossier)
  }
}

image_wang_2016 <- list.files(path = "/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2016"
                              , pattern = "tif")
image_wang_2016_full <- list.files(path = "/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2016"
                                   , pattern = "tif"
                                   ,full.names = TRUE)
image_wang_2016 <- str_remove(image_wang_2016, '_LST.tif')


for(i in 1:length(image_wang_2016))
{
  test <- Image_journee_chaude[which(Image_journee_chaude$Landsat_id %in% image_wang_2016[i] ), ] 
  if(as.character(test$Date) %in% list.files(path = "/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2016"))
  {
    nom_dossier <- paste0("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2016/",as.character(test$Date))
    file.move(image_wang_2016_full[i], nom_dossier)
  }else
  {
    dir.create(paste0("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2016/",as.character(test$Date)))
    nom_dossier <- paste0("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2016/",as.character(test$Date))
    file.move(image_wang_2016_full[i], nom_dossier)
  }
}

image_wang_2017 <- list.files(path = "/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2017"
                              , pattern = "tif")
image_wang_2017_full <- list.files(path = "/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2017"
                                   , pattern = "tif"
                                   ,full.names = TRUE)
image_wang_2017 <- str_remove(image_wang_2017, '_LST.tif')


for(i in 1:length(image_wang_2017))
{
  test <- Image_journee_chaude[which(Image_journee_chaude$Landsat_id %in% image_wang_2017[i] ), ] 
  if(as.character(test$Date) %in% list.files(path = "/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2017"))
  {
    nom_dossier <- paste0("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2017/",as.character(test$Date))
    file.move(image_wang_2017_full[i], nom_dossier)
  }else
  {
    dir.create(paste0("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2017/",as.character(test$Date)))
    nom_dossier <- paste0("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2017/",as.character(test$Date))
    file.move(image_wang_2017_full[i], nom_dossier)
  }
}

image_wang_2018 <- list.files(path = "/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2018"
                              , pattern = "tif")
image_wang_2018_full <- list.files(path = "/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2018"
                                   , pattern = "tif"
                                   ,full.names = TRUE)
image_wang_2018 <- str_remove(image_wang_2018, '_LST.tif')


for(i in 1:length(image_wang_2018))
{
  test <- Image_journee_chaude[which(Image_journee_chaude$Landsat_id %in% image_wang_2018[i] ), ] 
  if(as.character(test$Date) %in% list.files(path = "/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2018"))
  {
    nom_dossier <- paste0("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2018/",as.character(test$Date))
    file.move(image_wang_2018_full[i], nom_dossier)
  }else
  {
    dir.create(paste0("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2018/",as.character(test$Date)))
    nom_dossier <- paste0("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2018/",as.character(test$Date))
    file.move(image_wang_2018_full[i], nom_dossier)
  }
}

image_wang_2019 <- list.files(path = "/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2019"
                              , pattern = "tif")
image_wang_2019_full <- list.files(path = "/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2019"
                                   , pattern = "tif"
                                   ,full.names = TRUE)
image_wang_2019 <- str_remove(image_wang_2019, '_LST.tif')


for(i in 1:length(image_wang_2019))
{
  test <- Image_journee_chaude[which(Image_journee_chaude$Landsat_id %in% image_wang_2019[i] ), ] 
  if(as.character(test$Date) %in% list.files(path = "/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2019"))
  {
    nom_dossier <- paste0("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2019/",as.character(test$Date))
    file.move(image_wang_2019_full[i], nom_dossier)
  }else
  {
    dir.create(paste0("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2019/",as.character(test$Date)))
    nom_dossier <- paste0("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2019/",as.character(test$Date))
    file.move(image_wang_2019_full[i], nom_dossier)
  }
}

image_wang_2020 <- list.files(path = "/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2020"
                              , pattern = "tif")
image_wang_2020_full <- list.files(path = "/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2020"
                                   , pattern = "tif"
                                   ,full.names = TRUE)
image_wang_2020 <- str_remove(image_wang_2020, '_LST.tif')


for(i in 1:length(image_wang_2020))
{
  test <- Image_journee_chaude[which(Image_journee_chaude$Landsat_id %in% image_wang_2020[i] ), ] 
  if(as.character(test$Date) %in% list.files(path = "/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2020"))
  {
    nom_dossier <- paste0("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2020/",as.character(test$Date))
    file.move(image_wang_2020_full[i], nom_dossier)
  }else
  {
    dir.create(paste0("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2020/",as.character(test$Date)))
    nom_dossier <- paste0("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Wang_2020/",as.character(test$Date))
    file.move(image_wang_2020_full[i], nom_dossier)
  }
}

