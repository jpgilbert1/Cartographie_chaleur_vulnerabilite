####Téléchargement des données météo de EC #####
#lit une liste de station ayant des donnees d'environnement canada de 2013 a 2020
library(filesstrings)
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
