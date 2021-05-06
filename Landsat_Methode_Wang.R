#####   Methode wang 2020 ######
#nom de l'article : An Efficient Framework for Producing Landsat-Based Land Surface Temperature Data Using Google Earth Engine
# même principe que Landsat_methode_ERIMA. De visuel, les images sont plus clean, et selon l'article de Wang, cette méthode est plus
#accurate que celle d'Erima. Elle aussi elle est sur google earth engine. https://code.earthengine.google.com/?accept_repo=users/wangmmcug/landsat_psc_lst

#Sur GEE, des fichiers de toutes les images pour la province de Qc a été fait, avec une couverture nuageuse de 10% et moins.


library("readxl")
Image_dispo_2015 <-read_excel('/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Info_landsat_2015.xlsx')
Image_dispo_2016 <-read_excel('/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Info_landsat_2016.xlsx')
Image_dispo_2017 <-read_excel('/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Info_landsat_2017.xlsx')
Image_dispo_2018 <-read_excel('/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Info_landsat_2018.xlsx')
Image_dispo_2019 <-read_excel('/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Info_landsat_2019.xlsx')
Image_dispo_2020 <-read_excel('/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_Wang/Info_landsat_2020.xlsx')


extraction_date <- function(df)
{#' extraction_date
#'
#' @param df 
#'extrait les dates de la colonne date et les met danss leur propre colone
#'
#' @return df avec trois nouveaux champs, Year, month et day
#' @export
#'
#' @examples
  
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

#combine les fichiers ensemble
Image_dispo <- do.call('rbind', list(Image_dispo_2015,Image_dispo_2016,Image_dispo_2017,Image_dispo_2018,Image_dispo_2019,Image_dispo_2020))
Image_journee_chaude <- Image_dispo[1,]

#va cherche le fichier qui est les journees chaudes, soit 30 celsius ou plus comme t maximal dans la journee
load("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Donnees_meteo/fichier_journee_chaude_sans_doublons.rda")

#Dans le lot d'images, pas toutes les images correspondent a des journees chaudes, donc on ne les telecharges pas pour rien
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

###########Telechargement des photos sur GEE, PAS DANS R #########


#Mettre toutes les images de la même date ensemble, dans un meme fichier
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

