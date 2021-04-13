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

# 1. Initialize the Python Environment  
#Ceci est mon authentification : 4/1AY0e-g7028VXxck9xkcmq0Ob-xX6YMkIpGbFPej03T1i-f1oLIH_ztbdZpo #
ee_Initialize()

# 2. Install geemap in the same Python ENV that use rgee
py_install("geemap")
gm <- import("geemap")

#ee_install_upgrade()

#Premier test. Telechargement et enregistrement d'une image Landsat 8 Tier 1 DN. Il s'agit d'une image recouvrant une partie de l'estrie
#pour le 12 juin 2017

secteur <- c(-72.4988076171875,46.630943299130344,
             -72.2461220703125,46.630943299130344,
             -72.2461220703125,46.71574964520758,
             -72.4988076171875,46.71574964520758,
             -72.4988076171875,46.630943299130344)

test <- ee$Image('LANDSAT/LC08/C01/T1/LC08_014028_20170612')
task_img <- ee$batch$Export$image$toDrive(image = test,
                                          region = secteur)

task_img$start()
ee_monitoring(task_img)

l <- ee$Feature(test)

#Deuxieme test : creation d'un dictionnaire pour les images Landsat de la ville de Qc en 2016 (date du plus recent recensement?)

secteur_ville_qc <- c(-71.34950798924484,46.728698813821076,
                      -71.01991814549484,46.728698813821076,
                      -71.01991814549484,46.901625009007994,
                      -71.34950798924484,46.901625009007994,
                      -71.34950798924484,46.728698813821076)

dictionnaire_image_qc <- c('LANDSAT/LC08/C01/T1/LC08_013027_20160211',
'LANDSAT/LC08/C01/T1/LC08_013027_20160227',
'LANDSAT/LC08/C01/T1/LC08_013027_20160314',
'LANDSAT/LC08/C01/T1/LC08_013027_20160330',
'LANDSAT/LC08/C01/T1/LC08_013027_20160415',
'LANDSAT/LC08/C01/T1/LC08_013027_20160501',
'LANDSAT/LC08/C01/T1/LC08_013027_20160602',
'LANDSAT/LC08/C01/T1/LC08_013027_20160618',
'LANDSAT/LC08/C01/T1/LC08_013027_20160704',
'LANDSAT/LC08/C01/T1/LC08_013027_20160720',
'LANDSAT/LC08/C01/T1/LC08_013027_20160805',
'LANDSAT/LC08/C01/T1/LC08_013027_20160821',
'LANDSAT/LC08/C01/T1/LC08_013027_20160906',
'LANDSAT/LC08/C01/T1/LC08_013027_20160922',
'LANDSAT/LC08/C01/T1/LC08_013027_20161211',
'LANDSAT/LC08/C01/T1/LC08_013028_20160211',
'LANDSAT/LC08/C01/T1/LC08_013028_20160227',
'LANDSAT/LC08/C01/T1/LC08_013028_20160314',
'LANDSAT/LC08/C01/T1/LC08_013028_20160330',
'LANDSAT/LC08/C01/T1/LC08_013028_20160415',
'LANDSAT/LC08/C01/T1/LC08_013028_20160501',
'LANDSAT/LC08/C01/T1/LC08_013028_20160618',
'LANDSAT/LC08/C01/T1/LC08_013028_20160704',
'LANDSAT/LC08/C01/T1/LC08_013028_20160720',
'LANDSAT/LC08/C01/T1/LC08_013028_20160805',
'LANDSAT/LC08/C01/T1/LC08_013028_20160821',
'LANDSAT/LC08/C01/T1/LC08_013028_20160906',
'LANDSAT/LC08/C01/T1/LC08_013028_20160922',
'LANDSAT/LC08/C01/T1/LC08_013028_20161008',
'LANDSAT/LC08/C01/T1/LC08_013028_20161211',
'LANDSAT/LC08/C01/T1/LC08_014027_20160101',
'LANDSAT/LC08/C01/T1/LC08_014027_20160117',
'LANDSAT/LC08/C01/T1/LC08_014027_20160202',
'LANDSAT/LC08/C01/T1/LC08_014027_20160218',
'LANDSAT/LC08/C01/T1/LC08_014027_20160305',
'LANDSAT/LC08/C01/T1/LC08_014027_20160321',
'LANDSAT/LC08/C01/T1/LC08_014027_20160406',
'LANDSAT/LC08/C01/T1/LC08_014027_20160524',
'LANDSAT/LC08/C01/T1/LC08_014027_20160625',
'LANDSAT/LC08/C01/T1/LC08_014027_20160711',
'LANDSAT/LC08/C01/T1/LC08_014027_20160727',
'LANDSAT/LC08/C01/T1/LC08_014027_20160812',
'LANDSAT/LC08/C01/T1/LC08_014027_20160913',
'LANDSAT/LC08/C01/T1/LC08_014027_20160929',
'LANDSAT/LC08/C01/T1/LC08_014027_20161015')

for (i in 1:length(dictionnaire_image_qc))
{
  image_landsat <- ee$Image(dictionnaire_image_qc[i])
  task_img <- ee$batch$Export$image$toDrive(image = image_landsat,
                                            region = secteur_ville_qc,
                                            fileNamePrefix = dictionnaire_image_qc[i],
                                            folder = 'Ville_de_qc_2016')
  task_img$start()$
  ee_monitoring(task_img)
  if(i == 2)
  {
    break
  }
}

#####Test 3: Telechargement des images avec un pretraitement (Cloud Cover et ML et AL pour le calcul de TOA) #########
image_landsat <- ee$Image(dictionnaire_image_qc[1])
couvert_nuageux <- image_landsat$get('CLOUD_COVER')
couvert_nuageux <- couvert_nuageux$getInfo()

multiplicative_rescaling <- image_landsat$get('RADIANCE_MULT_BAND_10')
multiplicative_rescaling <- multiplicative_rescaling$getInfo()

additive_rescaling <- image_landsat$get('RADIANCE_ADD_BAND_10')
additive_rescaling <- additive_rescaling$getInfo()

nom_image <- image_landsat$get("system:index")
nom_image <- nom_image$getInfo()

rm(info_image)
for (i in 1:length(dictionnaire_image_qc))
{
  image_landsat <- ee$Image(dictionnaire_image_qc[i])
  couvert_nuageux <- image_landsat$get('CLOUD_COVER')
  couvert_nuageux <- couvert_nuageux$getInfo()
  if(couvert_nuageux < 5)
  {
    print(couvert_nuageux)

    nom_image <- image_landsat$get("system:index")
    nom_image <- nom_image$getInfo()
    
    multiplicative_rescaling <- image_landsat$get('RADIANCE_MULT_BAND_10')
    multiplicative_rescaling <- multiplicative_rescaling$getInfo()
    
    additive_rescaling <- image_landsat$get('RADIANCE_ADD_BAND_10')
    additive_rescaling <- additive_rescaling$getInfo()
    
    task_img <- ee$batch$Export$image$toDrive(image = image_landsat,
                                              region = secteur_ville_qc,
                                              fileNamePrefix = dictionnaire_image_qc[i],
                                              folder = 'Ville_de_qc_2016')
    task_img$start()#$ee_monitoring(task_img)
    
    if (isFALSE(exists('info_image') && is.data.frame(get('info_image'))))
    {
      info_image <- data.frame(nom_image,multiplicative_rescaling, additive_rescaling, couvert_nuageux, stringsAsFactors=FALSE)
    }else
    {
      info_image <- rbind(info_image, c(nom_image,multiplicative_rescaling, additive_rescaling, couvert_nuageux))
    }
  }
}


#avec ces informations, il est possible de calculer le TOA (quoiqu'il semble déjà fait par GEE, on peut comparer cette méthode avec)


x <- data.frame(nom_image,multiplicative_rescaling, additive_rescaling, couvert_nuageux)

