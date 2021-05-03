####Ce fichier sert manipuler les donnees de Landsat et GAIA pour calculer les SUHII selon la methode de Yang et al., 2021. (impact factor de 6.192)####
#Les fichiers ne sont pas sur la meme projection, donc reprojette selon les donnes du GAIA qui sont en long lat (Landsat en UTM)
library("raster")

setwd('/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Donnee_GAIA_Artificial_impervenous_surface')
Image_GAIA_ref <- raster("GAIA_1985_2018_46_-074.tif")

fichier_moins_10 <- function(df)
{
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

test <- fichier_moins_10(df)
reprojection_raster(test)


for(i in 1:nrow(metadata_2015_cloud_cover_10))
{
  Image_Landsat <- raster(paste0(metadata_2015_cloud_cover_10$`system:index`[i], '.tif'))
  Image_Landsat_reproject <- projectRaster(Image_Landsat,
                                           crs = crs(Image_GAIA_ref),
                                           res = res(Image_GAIA_ref))
  writeRaster(Image_Landsat_reproject, paste0("Reproject/",metadata_2015_cloud_cover_10$`system:index`[i]), format = "GTiff")
}


#2016
setwd('/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Landsat_methode_GEE/GEE_QC_2016')
load("Metadata/Metadata_2016.rda")
j <- 0
for (i in 1:nrow(df))
{
  if(df$CLOUD_COVER[i] <= 10)
  {
    if (j == 0)
    {
      metadata_2016_cloud_cover_10 <- df[i,]
      j <- j+1
    }else
    {
      metadata_2016_cloud_cover_10 <- rbind(metadata_2016_cloud_cover_10, df[i,])
    }
  }
}

for(i in 1:nrow(metadata_2016_cloud_cover_10))
{
  Image_Landsat <- raster(paste0(metadata_2016_cloud_cover_10$`system:index`[i], '.tif'))
  Image_Landsat_reproject <- projectRaster(Image_Landsat,
                                           crs = crs(Image_GAIA_ref),
                                           res = res(Image_GAIA_ref))
  writeRaster(Image_Landsat_reproject, paste0("Reproject/",metadata_2016_cloud_cover_10$`system:index`[i]), format = "GTiff")
}


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





