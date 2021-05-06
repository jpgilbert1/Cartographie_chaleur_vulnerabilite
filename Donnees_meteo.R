####Téléchargement des données météo de EC #####
#lit une liste de station ayant des donnees d'environnement canada de 2013 a 2020
library(filesstrings)
library(dplyr)
liste_station <- read.csv('/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Donnees_meteo/Station_Inventory_EN_modif.csv')

#Ici, fait appel au command line pour telecharger les donnees des stations automatiquement
#info : https://drive.google.com/drive/folders/1WJCDEU34c60IfOnG4rv5EPZ4IhhW9vZH
for (i in 1:nrow(liste_station))
{
  debut <- 'for annee in `seq 2015 2020`;do for mois in `seq 1`;do wget --content-disposition "https://climat.meteo.gc.ca/climate_data/bulk_data_f.html?format=csv&stationID='
  fin <- paste(liste_station$Station.ID[i],'&Year=${annee}&Month=${mois}&Day=14&timeframe=2&submit=++T%C3%A9l%C3%A9charger+% D%0Ades+donn%C3%A9es" ;done;done', sep = "")
  commande <- paste(debut,fin, sep="")
 
  system(commande)
  
  #fait une pause de 5 sec pour etre sur que les donnees soit toutes telechargees
  Sys.sleep(5)
  
  #puis transfere les fichiers dans un autre dossier.
  fichiers <- list.files("/Users/jean-philippegilbert/Desktop/Code_carto_chaleur_git/Cartographie_chaleur_vulnerabilite", pattern = 'fr_climat', full.names = TRUE)
  for (j in 1:length(fichiers))
  {
    file.move(fichiers[j], '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Donnees_meteo/Donnees_2015_2020')     
  }
  
}

##une fois que les données sont téléchargées, il faut déterminer quelles sont les dates des vagues de chaleur, pour aller chercher les Landsat adéquat
#donc on se fit sur la definition de INSPQ : https://www.inspq.qc.ca/pdf/publications/1079_IndicateursVigieSanteChaleur.pdf
#on on sort les dates 3 jours consecutf de journee chaude superieur a 30 et minimal superieur a 20.

donnees_meteo <- list.files(path = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Donnees_meteo/Donnees_2015_2020/', full.names = TRUE)
file <- read.csv(donnees_meteo[1]) 

nb_de_jour =0
fichier_vague_de_chaleur <- file[1,]
for (i in 1:length(donnees_meteo))
{
  file <- read.csv(donnees_meteo[i])
  file <- na_if(file, "")
  for (j in 1:nrow(file))
  {
    if (file$Mois[j] %in% 4:11 && !is.na(file$Temp.max...C.[j]) && !is.na(file$Temp.min...C.[j]))
    {
      if(as.numeric(sub(",",".",file$Temp.max...C.[j])) >= 30 && as.numeric(sub(",",".",file$Temp.min...C.[j])) >= 20)
      {
        nb_de_jour <- nb_de_jour +1
      }else
        {
          nb_de_jour <- 0
        }
      if(nb_de_jour >=3)
      {
        print(file$Nom.de.la.Station[j])
        print(file$Date.Heure[j])
        print(file$Temp.max...C.[j])
        print(i)
        print(j)
        fichier_vague_de_chaleur <- rbind(fichier_vague_de_chaleur, file[j,])
      }
    }
  }
}

fichier_vague_de_chaleur <- fichier_vague_de_chaleur[-1,]


test <- merge(fichier_vague_de_chaleur, liste_station[,1:3], by.x = "ID.climatologique" , by.y = "X.1")


#Ne donne pas beaucoup d'images, donc peut-etre prendre des images avec une température de jour en haut de 30 au lieu 
#de prendre la définition de vagues de chaleur de INSPQ
#C'est le même principe que la boucle plus haut, mais avec moins de conditions.

donnees_meteo <- list.files(path = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Donnees_meteo/Donnees_2015_2020/', full.names = TRUE)
file <- read.csv(donnees_meteo[1]) 

fichier_journees_chaudes <- file[1,]
for (i in 1:length(donnees_meteo))
{
  file <- read.csv(donnees_meteo[i])
  file <- na_if(file, "")
  file$ID.climatologique <- as.character(file$ID.climatologique)
  file2 <- merge(file, liste_station[,1:3], by.x = "Nom.de.la.Station" , by.y = "Modified.Date..2021.03.31.23.34.UTC")
  if(file2$X == "QUEBEC")
  {
    for (j in 1:nrow(file))
    {
      if (file2$Mois[j] %in% 4:11 && !is.na(file2$Temp.max...C.[j]) && !is.na(file2$Temp.min...C.[j]))
      {
        if(as.numeric(sub(",",".",file2$Temp.max...C.[j])) >= 30)
        {
          print(file$Nom.de.la.Station[j])
          print(file$Date.Heure[j])
          print(file$Temp.max...C.[j])
          print(i)
          print(j)
          fichier_journees_chaudes <- rbind(fichier_journees_chaudes, file[j,])
        }
      }
    }
  }
  print(i)
}

#Comme beaucoup de doublons, il les enlever.
save(fichier_journees_chaudes, file="/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Donnees_meteo/fichier_journee_chaude_doublons.rda")

fichier_journees_chaudes <- fichier_journees_chaudes[!duplicated(fichier_journees_chaudes$Date.Heure), ]
fichier_journees_chaudes <- fichier_journees_chaudes[-1,]

save(fichier_journees_chaudes, file="/Users/jean-philippegilbert/Documents/Université\ Laval/Cartographie\ vulnérabilité\ vagues\ de\ chaleur\ accamblante\ -\ General/Data/Donnees_meteo/fichier_journee_chaude_sans_doublons.rda")
