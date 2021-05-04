####Ce fichier sert manipuler les donnees de Landsat et GAIA pour calculer les SUHII selon la methode de Yang et al., 2021. (impact factor de 6.192)####
#Les fichiers ne sont pas sur la meme projection, donc reprojette selon les donnes du GAIA qui sont en long lat (Landsat en UTM)
library("raster")

setwd('/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Donnee_GAIA_Artificial_impervenous_surface')
Image_GAIA_ref <- raster("GAIA_1985_2018_46_-074.tif")


fichier_moins_10 <- function(df)
{
  #' fichier_moins_10
  #'
  #'Prends un dataframe contenant les metadatas des images Landsat et ne garde que les lignes avec un couvert nuageux de moins de 10%
  #' @param df 
  #'
  #' @return 
  #' @export
  #'
  #' @examples
  j <- 0
  for (i in 1:nrow(df))
  {
    if(df$CLOUD_COVER[i] <= 10)
    {
      if (j == 0)
      {
        metadata_cloud_cover_10 <- df[i,]
        j <- j+1
      }else
      {
        metadata_cloud_cover_10 <- rbind(metadata_cloud_cover_10, df[i,])
      }
    }
  }
  return(metadata_cloud_cover_10)
}


reprojection_raster <- function(df)
{
#' reprojection_raster
#' 
#' Prends les images dans le fichier et le reproject en long-lat et enregistre la nouvelle image
#'
#' @param df 
#'
#' @return
#' @export
#'
#' @examples
  for(i in 1:nrow(df))
  {
    Image_Landsat <- raster(paste0(df$`system:index`[i], '.tif'))
    Image_Landsat_reproject <- projectRaster(Image_Landsat,
                                             crs = crs(Image_GAIA_ref),
                                             res = res(Image_GAIA_ref))
    writeRaster(Image_Landsat_reproject, paste0("Reproject/",df$`system:index`[i]), format = "GTiff")
  }
}



#2015
setwd('/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Landsat_methode_GEE/GEE_QC_2015')
load("Metadata/Metadata_2015.rda")

df_2015 <- fichier_moins_10(df)
reprojection_raster(df_2015)

#2016
setwd('/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Landsat_methode_GEE/GEE_QC_2016')
load("Metadata/Metadata_2016.rda")

df_2016 <- fichier_moins_10(df)
reprojection_raster(df_2016)

#2017
setwd('/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Landsat_methode_GEE/GEE_QC_2017')
load("Metadata/Metadata_2017.rda")

df_2017 <- fichier_moins_10(df)
reprojection_raster(df_2017)

#2018
setwd('/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Landsat_methode_GEE/GEE_QC_2018')
load("Metadata/Metadata_2018.rda")

df_2018 <- fichier_moins_10(df)
reprojection_raster(df_2018)

#2019
setwd('/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Landsat_methode_GEE/GEE_QC_2019')
load("Metadata/Metadata_2019.rda")

df_2019 <- fichier_moins_10(df)
reprojection_raster(df_2019)

#2020
setwd('/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Landsat_methode_GEE/GEE_QC_2020')
load("Metadata/Metadata_2020.rda")

df_2020 <- fichier_moins_10(df)
reprojection_raster(df_2020)

####### Une fois les donnees reprojecter, il faut ensuite determiner si l'image correspond effectivement a un moment de vague de chaleur spatialement
library(rgdal)
library(maptools)
library(ggplot2)
library(rgeos)
load()
setwd('/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Shp_file/Region_administrativ/30218')

municipalite <- readOGR(dsn =".",layer =  "sda_regio_20k_2012_s_poly", stringsAsFactors = FALSE)
#plot(municipalite)

#summary(municipalite@data)

#shp_df <- broom::tidy(municipalite, region = "MUS_NM_MUN")
#lapply(shp_df, class)
#head(shp_df)

#cnames <- aggregate(cbind(long, lat) ~ id, data=shp_df, FUN=mean)
#map <- ggplot() + geom_polygon(data = municipalite, aes(x = long, y = lat, group = group), colour = "black", fill = NA)
#map + geom_text(data = cnames, aes(x = long, y = lat, label = id), size = 4) + theme_void()

setwd('/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_GEE/GEE_QC_2020/Reproject')
Landsat_image_1 <- raster("LC08_017028_20200812.tif")
#plot(Landsat_image_1)
#Landsat_image_1_df <- as.data.frame(Landsat_image_1, xy = TRUE)

plot(municipalite)
plot(Landsat_image_1, 
     add = TRUE)

images_bonnes_2015 <- list.files("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_GEE/GEE_QC_2015/Reproject/Bonne", full.names = TRUE)
images_bonnes_2016 <- list.files("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_GEE/GEE_QC_2016/Reproject/Bonne", full.names = TRUE)
images_bonnes_2017 <- list.files("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_GEE/GEE_QC_2017/Reproject/Bonne", full.names = TRUE)
images_bonnes_2018 <- list.files("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_GEE/GEE_QC_2018/Reproject/Bonne", full.names = TRUE)
images_bonnes_2019 <- list.files("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_GEE/GEE_QC_2019/Reproject/Bonne", full.names = TRUE)
images_bonnes_2020 <- list.files("/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Landsat_methode_GEE/GEE_QC_2020/Reproject/Bonne", full.names = TRUE)
combine_images_bonne <- c(images_bonnes_2015,images_bonnes_2016, images_bonnes_2016, images_bonnes_2017, images_bonnes_2018, images_bonnes_2019, images_bonnes_2020)


plot(municipalite)
plot(raster(combine_images_bonne[1]), 
     add = TRUE)
plot(raster(combine_images_bonne[2]),
     add = TRUE)
plot(raster(combine_images_bonne[3]),
     add = TRUE)
plot(raster(combine_images_bonne[4]),
     add = TRUE)
plot(raster(combine_images_bonne[5]),
     add = TRUE)
plot(raster(combine_images_bonne[6]),
     add = TRUE)
plot(raster(combine_images_bonne[7]),
     add = TRUE)
plot(raster(combine_images_bonne[8]),
     add = TRUE)
plot(raster(combine_images_bonne[9]),
     add = TRUE)
plot(raster(combine_images_bonne[10]),
     add = TRUE)
plot(raster(combine_images_bonne[11]),
     add = TRUE)
plot(raster(combine_images_bonne[12]),
     add = TRUE)
plot(raster(combine_images_bonne[13]),
     add = TRUE)
plot(raster(combine_images_bonne[14]),
     add = TRUE)
plot(raster(combine_images_bonne[15]),
     add = TRUE)
plot(raster(combine_images_bonne[16]),
     add = TRUE)
plot(raster(combine_images_bonne[17]),
     add = TRUE)
plot(raster(combine_images_bonne[18]),
     add = TRUE)
plot(raster(combine_images_bonne[19]),
     add = TRUE)
plot(raster(combine_images_bonne[20]),
     add = TRUE)
plot(raster(combine_images_bonne[21]),
     add = TRUE)
plot(raster(combine_images_bonne[22]),
     add = TRUE)
plot(raster(combine_images_bonne[23]),
     add = TRUE)
plot(raster(combine_images_bonne[24]),
      add = TRUE)
plot(raster(combine_images_bonne[25]),
     add = TRUE)
plot(raster(combine_images_bonne[26]),
     add = TRUE)
plot(raster(combine_images_bonne[27]),
     add = TRUE)
plot(raster(combine_images_bonne[28]),
     add = TRUE)
plot(raster(combine_images_bonne[29]),
     add = TRUE)
plot(raster(combine_images_bonne[30]),
     add = TRUE)
plot(raster(combine_images_bonne[31]),
     add = TRUE)
plot(raster(combine_images_bonne[32]),
     add = TRUE)
plot(raster(combine_images_bonne[33]),
     add = TRUE)
plot(raster(combine_images_bonne[34]),
     add = TRUE)


crs(Image_Landsat)
res(Image_GAIA_ref)
Image_Landsat_reproject <- projectRaster(Image_Landsat,
                                         crs = crs(Image_GAIA_ref),
                                         res = res(Image_GAIA_ref))
res(Image_Landsat_reproject)
Image_Landsat_test <- raster(name_file)
plot(Image_Landsat_reproject)
writeRaster(Image_Landsat_reproject, "test_output11", format = "GTiff")
Image_Landsat_test_df <- as.data.frame(Image_Landsat_test, xy = TRUE)




setwd('/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Donnee_GAIA_Artificial_impervenous_surface')




Image_test <- raster("GAIA_1985_2018_46_-074.tif")

library(ggplot2)
Image_test_df <- as.data.frame(Image_test, xy = TRUE)
plot(Image_test )





