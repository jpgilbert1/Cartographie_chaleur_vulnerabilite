#####Lectures du fichier d'AD######
#### QC ####
library(dplyr)

AD_qc <- read.csv(file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Quebec/98-401-X2016044_QUEBEC_fra_CSV/98-401-X2016044_QUEBEC_Francais_CSV_data.csv')

#Pas besoin de ces grosseurs geographiques
AD_qc_modif<-AD_qc[!(AD_qc$CODE_GÉO..LDR. == 1 |  AD_qc$CODE_GÉO..LDR. == 24),]
AD_qc_modif <- AD_qc_modif[!(AD_qc_modif$NIVEAU_GÉO == 2),]
AD_qc_modif <- AD_qc_modif[!(AD_qc_modif$NIVEAU_GÉO == 3),]
AD_qc_modif <- AD_qc_modif[,-(1:3)]

test <- AD_qc_modif[1:100,]

# code correspondant a ID du member dans les metadonnees (98-401-X2016044_Francais_meta.txt), donc on ne garde que ceux utile pour l'indice
liste_a_garder <- c(1,4,6,8:33,42,43,51:56,58,78,79,80,87,100,105,662,663,665,693, 695:707, 725,742,743,760:779,836,847,1148,1324,1337,1644,1683:1697)

AD_qc_modif <- AD_qc_modif[which(AD_qc_modif$Membre.ID..Profil.des.aires.de.diffusion..2247. %in% liste_a_garder),]

#renomme colomne de sexe pour etre plus accessible
names(AD_qc_modif)[names(AD_qc_modif) == "Dim..Sexe..3...Membre.ID...1...Total...Sexe" ] <- "Tot"
names(AD_qc_modif)[names(AD_qc_modif) == "Dim..Sexe..3...Membre.ID...2...Sexe.masculin"] <- "Masc"
names(AD_qc_modif)[names(AD_qc_modif) == "Dim..Sexe..3...Membre.ID...3...Sexe.féminin" ] <- "Fem"

test <- AD_qc_modif[1:120,]
test$Fem[test$Fem == "..."] <- NA

#Pour la gestion dans ArcGIS, plus facile d'avoir des NA que des ...
AD_qc_modif$Tot[AD_qc_modif$Tot == "..."] <- NA
AD_qc_modif$Fem[AD_qc_modif$Fem == "..."] <- NA
AD_qc_modif$Masc[AD_qc_modif$Masc == "..."] <- NA

#Pour le genre, on ne garde que la population generale, ce qui corresponds au Member ID 8. Donc on va faire 
# 3 nouveaux fichiers, un de la population total, l'autre de la population masculine et un dernier feminin
# Puis on garde le tout sous la colonne Tot
AD_qc_modif_ajout_genre <- AD_qc_modif[AD_qc_modif$Membre.ID..Profil.des.aires.de.diffusion..2247. == 8,]
AD_qc_modif_ajout_genre_tot <- AD_qc_modif_ajout_genre
AD_qc_modif_ajout_genre_tot$DIM..Profil.des.aires.de.diffusion..2247. <- "Total - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"
AD_qc_modif_ajout_genre_tot <- subset(AD_qc_modif_ajout_genre_tot, select = -c(Masc, Fem))

AD_qc_modif_ajout_genre_mas <- AD_qc_modif_ajout_genre
AD_qc_modif_ajout_genre_mas$DIM..Profil.des.aires.de.diffusion..2247. <- "Masculin - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"
AD_qc_modif_ajout_genre_mas$Tot <- AD_qc_modif_ajout_genre_mas$Masc
AD_qc_modif_ajout_genre_mas <- subset(AD_qc_modif_ajout_genre_mas, select = -c(Masc, Fem))

AD_qc_modif_ajout_genre_fem <- AD_qc_modif_ajout_genre 
AD_qc_modif_ajout_genre_fem$DIM..Profil.des.aires.de.diffusion..2247. <- "Feminin - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"
AD_qc_modif_ajout_genre_fem$Tot <-AD_qc_modif_ajout_genre_fem$Fem
AD_qc_modif_ajout_genre_fem <- subset(AD_qc_modif_ajout_genre_fem, select = -c(Masc, Fem))

#Comme la colonne tot va reprenseter les effectifs pour chacune des variables, on drop la colonne masculin et feminin
#du fichier qui contient toute les informations.
AD_qc_modif <- subset(AD_qc_modif, select = -c(Masc, Fem))
AD_qc_modif <- AD_qc_modif[!(AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247. == "Total - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"),]

#Fusion des fichiers de population tot, population masculin et population feminin avec le fichier contenant tout
AD_qc_modif <- do.call('rbind', list(AD_qc_modif,AD_qc_modif_ajout_genre_tot,AD_qc_modif_ajout_genre_mas,AD_qc_modif_ajout_genre_fem))
AD_qc_modif <- AD_qc_modif[order(AD_qc_modif$NOM_GÉO, AD_qc_modif$Membre.ID..Profil.des.aires.de.diffusion..2247.),]

#On garde un format rda, car pour ArcGIS, on va perdre toute infos sauf l'ID, l'effectif et le nom de la variable.
#Donc ce fichier sert de lien entre 98-401-X2016044_Francais_meta.txt et ArcGIS.
save(AD_qc_modif, file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Quebec/98-401-X2016044_QUEBEC_fra_CSV/AD_qc_modif.rda')

#Donc pour arcGIS, on met le nom de la variable en rowname, on garde que l'effectif et le code de l'AD
AD_qc_modif_format_shp <- subset(AD_qc_modif, select = -c(TGN, TGN_FL, INDICATEUR_QUALITÉ_DONNÉES,CODE_GÉO_ALT,
                                                          
                                                          Notes..Profil.des.aires.de.diffusion..2247.))

#a place de faire une loop tres longue sur les donnees, faire une fonction qui fait ce que l'on veut et ensuite appliquer
#la fonction avec un lapply.
#ajout_v prend une colonne_a_changer, qui est la colonne \ changer, regarde si le premier caractère est une lettre ou un chiffre.
#id_member sert a verifier si l'id_member est entre 760 et 779, pour eviter les doublons. 
#si c'est un chiffre, il va ajouter 'V_' devant le chiffre. Si c'est une lettre, ne touche pas.
ajout_v <- function(colonne_a_changer, id_member){
  if(id_member %in% 760:779)
  {
    colonne_a_changer <- paste('VV_',colonne_a_changer, sep= "")
  }
  else if(!is.na(as.numeric(substring(colonne_a_changer, 1, 1))))
  {
    colonne_a_changer <- paste('V_',colonne_a_changer, sep= "")
  }else
  {
    colonne_a_changer <- colonne_a_changer
  }
}

#Applique fonction sur le dataframe
AD_qc_modif_format_shp$DIM..Profil.des.aires.de.diffusion..2247. <- mapply(ajout_v , AD_qc_modif_format_shp$DIM..Profil.des.aires.de.diffusion..2247., AD_qc_modif_format_shp$Membre.ID..Profil.des.aires.)

#Creer une liste des AD
library(dplyr)
liste_ad <- as.data.frame(AD_qc_modif_format_shp$NOM_GÉO)
liste_ad <- distinct(liste_ad)

#Creation d'un nouveau dataframe donc les noms sont en columne et les lignes sont les effectifs (un peu long a rouler)
for(i in 1:nrow(liste_ad))
{
  tempo <- AD_qc_modif_format_shp[AD_qc_modif_format_shp$NOM_GÉO == liste_ad[i,],]
  row.names(tempo) <- tempo$DIM..Profil.des.aires.de.diffusion..2247.
  tempo <- tempo[,c(1,4)]
  tempo2 <- rbind(c(liste_ad[i,],liste_ad[i,]), tempo)
  tempo2 <- t(as.data.frame(tempo2))
  tempo2 <- tempo2[2,]
  
  if(i == 1)
  {
    AD_qc_modif_format_shp_fin <- tempo2
  }else
  {
    AD_qc_modif_format_shp_fin <- rbind(AD_qc_modif_format_shp_fin, tempo2)
  }
  print(i)
}

#Clean le dataframe un peu
AD_qc_modif_format_shp_fin_df <- as.data.frame(AD_qc_modif_format_shp_fin)
names(AD_qc_modif_format_shp_fin_df)[names(AD_qc_modif_format_shp_fin_df) == "1"] <- "NOM_GEO"
rownames(AD_qc_modif_format_shp_fin_df) <- NULL

#le dataframe devrait etre bon pour aller dans ArcGIS
save(AD_qc_modif_format_shp_fin_df, file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Quebec/98-401-X2016044_QUEBEC_fra_CSV/Stats_can_ad_qc.rda')
write.csv(AD_qc_modif_format_shp_fin_df, file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Quebec/98-401-X2016044_QUEBEC_fra_CSV/Stats_can_ad_qc.csv')

rm(list=ls())
gc()

#Suffit de faire la meme chose pour chacun dossier.

#### Colombie-Britannique ####

library(dplyr)

AD_BC <- read.csv(file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Colombie_Britannique/98-401-X2016044_COLOMBIE_BRITANNIQUE_fra_CSV/98-401-X2016044_COLOMBIE_BRITANNIQUE_Francais_CSV_data.csv')

AD_BC_modif<-AD_BC[!(AD_BC$CODE_GÉO..LDR. == 1 |  AD_BC$CODE_GÉO..LDR. == 59),]
AD_BC_modif <- AD_BC_modif[!(AD_BC_modif$NIVEAU_GÉO == 2),]
AD_BC_modif <- AD_BC_modif[!(AD_BC_modif$NIVEAU_GÉO == 3),]
AD_BC_modif <- AD_BC_modif[,-(1:3)]

liste_a_garder <- c(1,4,6,8:33,42,43,51:56,58,78,79,80,87,100,105,662,663,665,693, 695:707, 725,742,743,760:779,836,847,1148,1324,1337,1644,1683:1697)

AD_BC_modif <- AD_BC_modif[which(AD_BC_modif$Membre.ID..Profil.des.aires.de.diffusion..2247. %in% liste_a_garder),]

names(AD_BC_modif)[names(AD_BC_modif) == "Dim..Sexe..3...Membre.ID...1...Total...Sexe" ] <- "Tot"
names(AD_BC_modif)[names(AD_BC_modif) == "Dim..Sexe..3...Membre.ID...2...Sexe.masculin"] <- "Masc"
names(AD_BC_modif)[names(AD_BC_modif) == "Dim..Sexe..3...Membre.ID...3...Sexe.féminin" ] <- "Fem"

AD_BC_modif$Tot[AD_BC_modif$Tot == "..."] <- NA
AD_BC_modif$Fem[AD_BC_modif$Fem == "..."] <- NA
AD_BC_modif$Masc[AD_BC_modif$Masc == "..."] <- NA

AD_BC_modif_ajout_genre <- AD_BC_modif[AD_BC_modif$Membre.ID..Profil.des.aires.de.diffusion..2247. == 8,]
AD_BC_modif_ajout_genre_tot <- AD_BC_modif_ajout_genre
AD_BC_modif_ajout_genre_tot$DIM..Profil.des.aires.de.diffusion..2247. <- "Total - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"
AD_BC_modif_ajout_genre_tot <- subset(AD_BC_modif_ajout_genre_tot, select = -c(Masc, Fem))

AD_BC_modif_ajout_genre_mas <- AD_BC_modif_ajout_genre
AD_BC_modif_ajout_genre_mas$DIM..Profil.des.aires.de.diffusion..2247. <- "Masculin - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"
AD_BC_modif_ajout_genre_mas$Tot <- AD_BC_modif_ajout_genre_mas$Masc
AD_BC_modif_ajout_genre_mas <- subset(AD_BC_modif_ajout_genre_mas, select = -c(Masc, Fem))

AD_BC_modif_ajout_genre_fem <- AD_BC_modif_ajout_genre 
AD_BC_modif_ajout_genre_fem$DIM..Profil.des.aires.de.diffusion..2247. <- "Feminin - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"
AD_BC_modif_ajout_genre_fem$Tot <-AD_BC_modif_ajout_genre_fem$Fem
AD_BC_modif_ajout_genre_fem <- subset(AD_BC_modif_ajout_genre_fem, select = -c(Masc, Fem))

AD_BC_modif <- subset(AD_BC_modif, select = -c(Masc, Fem))
AD_BC_modif <- AD_BC_modif[!(AD_BC_modif$DIM..Profil.des.aires.de.diffusion..2247. == "Total - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"),]

AD_BC_modif <- do.call('rbind', list(AD_BC_modif,AD_BC_modif_ajout_genre_tot,AD_BC_modif_ajout_genre_mas,AD_BC_modif_ajout_genre_fem))
AD_BC_modif <- AD_BC_modif[order(AD_BC_modif$NOM_GÉO, AD_BC_modif$Membre.ID..Profil.des.aires.de.diffusion..2247.),]

save(AD_BC_modif, file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Colombie_Britannique/98-401-X2016044_COLOMBIE_BRITANNIQUE_fra_CSV/AD_BC_modif.rda')

AD_BC_modif_format_shp <- subset(AD_BC_modif, select = -c(TGN, TGN_FL, INDICATEUR_QUALITÉ_DONNÉES,CODE_GÉO_ALT,
                                                          
                                                          Notes..Profil.des.aires.de.diffusion..2247.))

ajout_v <- function(colonne_a_changer, id_member){
  if(id_member %in% 760:779)
  {
    colonne_a_changer <- paste('VV_',colonne_a_changer, sep= "")
  }
  else if(!is.na(as.numeric(substring(colonne_a_changer, 1, 1))))
  {
    colonne_a_changer <- paste('V_',colonne_a_changer, sep= "")
  }else
  {
    colonne_a_changer <- colonne_a_changer
  }
}

AD_BC_modif_format_shp$DIM..Profil.des.aires.de.diffusion..2247. <- mapply(ajout_v , AD_BC_modif_format_shp$DIM..Profil.des.aires.de.diffusion..2247., AD_BC_modif_format_shp$Membre.ID..Profil.des.aires.)

library(dplyr)
liste_ad <- as.data.frame(AD_BC_modif_format_shp$NOM_GÉO)
liste_ad <- distinct(liste_ad)

for(i in 1:nrow(liste_ad))
{
  tempo <- AD_BC_modif_format_shp[AD_BC_modif_format_shp$NOM_GÉO == liste_ad[i,],]
  row.names(tempo) <- tempo$DIM..Profil.des.aires.de.diffusion..2247.
  tempo <- tempo[,c(1,4)]
  tempo2 <- rbind(c(liste_ad[i,],liste_ad[i,]), tempo)
  tempo2 <- t(as.data.frame(tempo2))
  tempo2 <- tempo2[2,]
  
  if(i == 1)
  {
    AD_BC_modif_format_shp_fin <- tempo2
  }else
  {
    AD_BC_modif_format_shp_fin <- rbind(AD_BC_modif_format_shp_fin, tempo2)
  }
  print(i)
}

AD_BC_modif_format_shp_fin_df <- as.data.frame(AD_BC_modif_format_shp_fin)
names(AD_BC_modif_format_shp_fin_df)[names(AD_BC_modif_format_shp_fin_df) == "1"] <- "NOM_GEO"
rownames(AD_BC_modif_format_shp_fin_df) <- NULL

save(AD_BC_modif_format_shp_fin_df, file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Colombie_Britannique/98-401-X2016044_COLOMBIE_BRITANNIQUE_fra_CSV/Stats_can_ad_BC.rda')
write.csv(AD_BC_modif_format_shp_fin_df, file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Colombie_Britannique/98-401-X2016044_COLOMBIE_BRITANNIQUE_fra_CSV/Stats_can_ad_BC.csv')

rm(list=ls())
gc()

####Ontario####

library(dplyr)

AD_on <- read.csv(file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Ontario/98-401-X2016044_ONTARIO_fra_CSV/98-401-X2016044_ONTARIO_Francais_CSV_data.csv')


AD_on_modif<-AD_on[!(AD_on$CODE_GÉO..LDR. == 1 |  AD_on$CODE_GÉO..LDR. == 35),]
AD_on_modif <- AD_on_modif[!(AD_on_modif$NIVEAU_GÉO == 2),]
AD_on_modif <- AD_on_modif[!(AD_on_modif$NIVEAU_GÉO == 3),]
AD_on_modif <- AD_on_modif[,-(1:3)]

liste_a_garder <- c(1,4,6,8:33,42,43,51:56,58,78,79,80,87,100,105,662,663,665,693, 695:707, 725,742,743,760:779,836,847,1148,1324,1337,1644,1683:1697)

AD_on_modif <- AD_on_modif[which(AD_on_modif$Membre.ID..Profil.des.aires.de.diffusion..2247. %in% liste_a_garder),]

names(AD_on_modif)[names(AD_on_modif) == "Dim..Sexe..3...Membre.ID...1...Total...Sexe" ] <- "Tot"
names(AD_on_modif)[names(AD_on_modif) == "Dim..Sexe..3...Membre.ID...2...Sexe.masculin"] <- "Masc"
names(AD_on_modif)[names(AD_on_modif) == "Dim..Sexe..3...Membre.ID...3...Sexe.féminin" ] <- "Fem"

AD_on_modif$Tot[AD_on_modif$Tot == "..."] <- NA
AD_on_modif$Fem[AD_on_modif$Fem == "..."] <- NA
AD_on_modif$Masc[AD_on_modif$Masc == "..."] <- NA

AD_on_modif_ajout_genre <- AD_on_modif[AD_on_modif$Membre.ID..Profil.des.aires.de.diffusion..2247. == 8,]
AD_on_modif_ajout_genre_tot <- AD_on_modif_ajout_genre
AD_on_modif_ajout_genre_tot$DIM..Profil.des.aires.de.diffusion..2247. <- "Total - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"
AD_on_modif_ajout_genre_tot <- subset(AD_on_modif_ajout_genre_tot, select = -c(Masc, Fem))

AD_on_modif_ajout_genre_mas <- AD_on_modif_ajout_genre
AD_on_modif_ajout_genre_mas$DIM..Profil.des.aires.de.diffusion..2247. <- "Masculin - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"
AD_on_modif_ajout_genre_mas$Tot <- AD_on_modif_ajout_genre_mas$Masc
AD_on_modif_ajout_genre_mas <- subset(AD_on_modif_ajout_genre_mas, select = -c(Masc, Fem))

AD_on_modif_ajout_genre_fem <- AD_on_modif_ajout_genre 
AD_on_modif_ajout_genre_fem$DIM..Profil.des.aires.de.diffusion..2247. <- "Feminin - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"
AD_on_modif_ajout_genre_fem$Tot <-AD_on_modif_ajout_genre_fem$Fem
AD_on_modif_ajout_genre_fem <- subset(AD_on_modif_ajout_genre_fem, select = -c(Masc, Fem))

AD_on_modif <- subset(AD_on_modif, select = -c(Masc, Fem))
AD_on_modif <- AD_on_modif[!(AD_on_modif$DIM..Profil.des.aires.de.diffusion..2247. == "Total - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"),]

AD_on_modif <- do.call('rbind', list(AD_on_modif,AD_on_modif_ajout_genre_tot,AD_on_modif_ajout_genre_mas,AD_on_modif_ajout_genre_fem))
AD_on_modif <- AD_on_modif[order(AD_on_modif$NOM_GÉO, AD_on_modif$Membre.ID..Profil.des.aires.de.diffusion..2247.),]

save(AD_on_modif, file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Ontario/98-401-X2016044_ONTARIO_fra_CSV/AD_on_modif.rda')

AD_on_modif_format_shp <- subset(AD_on_modif, select = -c(TGN, TGN_FL, INDICATEUR_QUALITÉ_DONNÉES,CODE_GÉO_ALT,
                                                          
                                                          Notes..Profil.des.aires.de.diffusion..2247.))

ajout_v <- function(colonne_a_changer, id_member){
  if(id_member %in% 760:779)
  {
    colonne_a_changer <- paste('VV_',colonne_a_changer, sep= "")
  }
  else if(!is.na(as.numeric(substring(colonne_a_changer, 1, 1))))
  {
    colonne_a_changer <- paste('V_',colonne_a_changer, sep= "")
  }else
  {
    colonne_a_changer <- colonne_a_changer
  }
}

AD_on_modif_format_shp$DIM..Profil.des.aires.de.diffusion..2247. <- mapply(ajout_v , AD_on_modif_format_shp$DIM..Profil.des.aires.de.diffusion..2247., AD_on_modif_format_shp$Membre.ID..Profil.des.aires.)

library(dplyr)
liste_ad <- as.data.frame(AD_on_modif_format_shp$NOM_GÉO)
liste_ad <- distinct(liste_ad)


for(i in 1:nrow(liste_ad))
{
  tempo <- AD_on_modif_format_shp[AD_on_modif_format_shp$NOM_GÉO == liste_ad[i,],]
  row.names(tempo) <- tempo$DIM..Profil.des.aires.de.diffusion..2247.
  tempo <- tempo[,c(1,4)]
  tempo2 <- rbind(c(liste_ad[i,],liste_ad[i,]), tempo)
  tempo2 <- t(as.data.frame(tempo2))
  tempo2 <- tempo2[2,]
  
  if(i == 1)
  {
    AD_on_modif_format_shp_fin <- tempo2
  }else
  {
    AD_on_modif_format_shp_fin <- rbind(AD_on_modif_format_shp_fin, tempo2)
  }
  print(i)
}

AD_on_modif_format_shp_fin_df <- as.data.frame(AD_on_modif_format_shp_fin)
names(AD_on_modif_format_shp_fin_df)[names(AD_on_modif_format_shp_fin_df) == "1"] <- "NOM_GEO"
rownames(AD_on_modif_format_shp_fin_df) <- NULL

save(AD_on_modif_format_shp_fin_df, file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Ontario/98-401-X2016044_ONTARIO_fra_CSV/Stats_can_ad_on.rda')
write.csv(AD_on_modif_format_shp_fin_df, file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Ontario/98-401-X2016044_ONTARIO_fra_CSV/Stats_can_ad_on.csv')

rm(list=ls())
gc()


####Prairies####

library(dplyr)

AD_prairies <- read.csv(file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Prairie/98-401-X2016044_PRAIRIES_fra_CSV/98-401-X2016044_PRAIRIES_Francais_CSV_data.csv')


AD_prairies_modif<-AD_prairies[!(AD_prairies$CODE_GÉO..LDR. == 1 |  AD_prairies$CODE_GÉO..LDR. == 35),]
AD_prairies_modif <- AD_prairies_modif[!(AD_prairies_modif$NIVEAU_GÉO == 2),]
AD_prairies_modif <- AD_prairies_modif[!(AD_prairies_modif$NIVEAU_GÉO == 3),]
AD_prairies_modif <- AD_prairies_modif[,-(1:3)]


liste_a_garder <- c(1,4,6,8:33,42,43,51:56,58,78,79,80,87,100,105,662,663,665,693, 695:707, 725,742,743,760:779,836,847,1148,1324,1337,1644,1683:1697)

AD_prairies_modif <- AD_prairies_modif[which(AD_prairies_modif$Membre.ID..Profil.des.aires.de.diffusion..2247. %in% liste_a_garder),]

names(AD_prairies_modif)[names(AD_prairies_modif) == "Dim..Sexe..3...Membre.ID...1...Total...Sexe" ] <- "Tot"
names(AD_prairies_modif)[names(AD_prairies_modif) == "Dim..Sexe..3...Membre.ID...2...Sexe.masculin"] <- "Masc"
names(AD_prairies_modif)[names(AD_prairies_modif) == "Dim..Sexe..3...Membre.ID...3...Sexe.féminin" ] <- "Fem"

AD_prairies_modif$Tot[AD_prairies_modif$Tot == "..."] <- NA
AD_prairies_modif$Fem[AD_prairies_modif$Fem == "..."] <- NA
AD_prairies_modif$Masc[AD_prairies_modif$Masc == "..."] <- NA

AD_prairies_modif_ajout_genre <- AD_prairies_modif[AD_prairies_modif$Membre.ID..Profil.des.aires.de.diffusion..2247. == 8,]
AD_prairies_modif_ajout_genre_tot <- AD_prairies_modif_ajout_genre
AD_prairies_modif_ajout_genre_tot$DIM..Profil.des.aires.de.diffusion..2247. <- "Total - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"
AD_prairies_modif_ajout_genre_tot <- subset(AD_prairies_modif_ajout_genre_tot, select = -c(Masc, Fem))

AD_prairies_modif_ajout_genre_mas <- AD_prairies_modif_ajout_genre
AD_prairies_modif_ajout_genre_mas$DIM..Profil.des.aires.de.diffusion..2247. <- "Masculin - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"
AD_prairies_modif_ajout_genre_mas$Tot <- AD_prairies_modif_ajout_genre_mas$Masc
AD_prairies_modif_ajout_genre_mas <- subset(AD_prairies_modif_ajout_genre_mas, select = -c(Masc, Fem))

AD_prairies_modif_ajout_genre_fem <- AD_prairies_modif_ajout_genre 
AD_prairies_modif_ajout_genre_fem$DIM..Profil.des.aires.de.diffusion..2247. <- "Feminin - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"
AD_prairies_modif_ajout_genre_fem$Tot <-AD_prairies_modif_ajout_genre_fem$Fem
AD_prairies_modif_ajout_genre_fem <- subset(AD_prairies_modif_ajout_genre_fem, select = -c(Masc, Fem))

AD_prairies_modif <- subset(AD_prairies_modif, select = -c(Masc, Fem))
AD_prairies_modif <- AD_prairies_modif[!(AD_prairies_modif$DIM..Profil.des.aires.de.diffusion..2247. == "Total - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"),]

AD_prairies_modif <- do.call('rbind', list(AD_prairies_modif,AD_prairies_modif_ajout_genre_tot,AD_prairies_modif_ajout_genre_mas,AD_prairies_modif_ajout_genre_fem))
AD_prairies_modif <- AD_prairies_modif[order(AD_prairies_modif$NOM_GÉO, AD_prairies_modif$Membre.ID..Profil.des.aires.de.diffusion..2247.),]

save(AD_prairies_modif, file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Prairie/98-401-X2016044_PRAIRIES_fra_CSV/AD_prairies_modif.rda')

AD_prairies_modif_format_shp <- subset(AD_prairies_modif, select = -c(TGN, TGN_FL, INDICATEUR_QUALITÉ_DONNÉES,CODE_GÉO_ALT,
                                                          
                                                          Notes..Profil.des.aires.de.diffusion..2247.))

ajout_v <- function(colonne_a_changer, id_member){
  if(id_member %in% 760:779)
  {
    colonne_a_changer <- paste('VV_',colonne_a_changer, sep= "")
  }
  else if(!is.na(as.numeric(substring(colonne_a_changer, 1, 1))))
  {
    colonne_a_changer <- paste('V_',colonne_a_changer, sep= "")
  }else
  {
    colonne_a_changer <- colonne_a_changer
  }
}

AD_prairies_modif_format_shp$DIM..Profil.des.aires.de.diffusion..2247. <- mapply(ajout_v , AD_prairies_modif_format_shp$DIM..Profil.des.aires.de.diffusion..2247., AD_prairies_modif_format_shp$Membre.ID..Profil.des.aires.)

library(dplyr)
liste_ad <- as.data.frame(AD_prairies_modif_format_shp$NOM_GÉO)
liste_ad <- distinct(liste_ad)

for(i in 1:nrow(liste_ad))
{
  tempo <- AD_prairies_modif_format_shp[AD_prairies_modif_format_shp$NOM_GÉO == liste_ad[i,],]
  row.names(tempo) <- tempo$DIM..Profil.des.aires.de.diffusion..2247.
  tempo <- tempo[,c(1,4)]
  tempo2 <- rbind(c(liste_ad[i,],liste_ad[i,]), tempo)
  tempo2 <- t(as.data.frame(tempo2))
  tempo2 <- tempo2[2,]
  
  if(i == 1)
  {
    AD_prairies_modif_format_shp_fin <- tempo2
  }else
  {
    AD_prairies_modif_format_shp_fin <- rbind(AD_prairies_modif_format_shp_fin, tempo2)
  }
  print(i)
}

AD_prairies_modif_format_shp_fin_df <- as.data.frame(AD_prairies_modif_format_shp_fin)
names(AD_prairies_modif_format_shp_fin_df)[names(AD_prairies_modif_format_shp_fin_df) == "1"] <- "NOM_GEO"
rownames(AD_prairies_modif_format_shp_fin_df) <- NULL

save(AD_prairies_modif_format_shp_fin_df, file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Prairie/98-401-X2016044_PRAIRIES_fra_CSV/Stats_can_ad_prairies.rda')
write.csv(AD_prairies_modif_format_shp_fin_df, file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Prairie/98-401-X2016044_PRAIRIES_fra_CSV/Stats_can_ad_prairies.csv')

rm(list=ls())
gc()

####Atlantiques####


library(dplyr)

AD_atlan <- read.csv(file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Provinces_Atlantiques/98-401-X2016044_ATLANTIQUE_fra_CSV/98-401-X2016044_ATLANTIQUE_Francais_CSV_data.csv')


AD_atlan_modif<-AD_atlan[!(AD_atlan$CODE_GÉO..LDR. == 1 |  AD_atlan$CODE_GÉO..LDR. == 10),]
AD_atlan_modif <- AD_atlan_modif[!(AD_atlan_modif$NIVEAU_GÉO == 2),]
AD_atlan_modif <- AD_atlan_modif[!(AD_atlan_modif$NIVEAU_GÉO == 3),]
AD_atlan_modif <- AD_atlan_modif[,-(1:3)]

liste_a_garder <- c(1,4,6,8:33,42,43,51:56,58,78,79,80,87,100,105,662,663,665,693, 695:707, 725,742,743,760:779,836,847,1148,1324,1337,1644,1683:1697)

AD_atlan_modif <- AD_atlan_modif[which(AD_atlan_modif$Membre.ID..Profil.des.aires.de.diffusion..2247. %in% liste_a_garder),]

names(AD_atlan_modif)[names(AD_atlan_modif) == "Dim..Sexe..3...Membre.ID...1...Total...Sexe" ] <- "Tot"
names(AD_atlan_modif)[names(AD_atlan_modif) == "Dim..Sexe..3...Membre.ID...2...Sexe.masculin"] <- "Masc"
names(AD_atlan_modif)[names(AD_atlan_modif) == "Dim..Sexe..3...Membre.ID...3...Sexe.féminin" ] <- "Fem"

AD_atlan_modif$Tot[AD_atlan_modif$Tot == "..."] <- NA
AD_atlan_modif$Fem[AD_atlan_modif$Fem == "..."] <- NA
AD_atlan_modif$Masc[AD_atlan_modif$Masc == "..."] <- NA

AD_atlan_modif_ajout_genre <- AD_atlan_modif[AD_atlan_modif$Membre.ID..Profil.des.aires.de.diffusion..2247. == 8,]
AD_atlan_modif_ajout_genre_tot <- AD_atlan_modif_ajout_genre
AD_atlan_modif_ajout_genre_tot$DIM..Profil.des.aires.de.diffusion..2247. <- "Total - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"
AD_atlan_modif_ajout_genre_tot <- subset(AD_atlan_modif_ajout_genre_tot, select = -c(Masc, Fem))

AD_atlan_modif_ajout_genre_mas <- AD_atlan_modif_ajout_genre
AD_atlan_modif_ajout_genre_mas$DIM..Profil.des.aires.de.diffusion..2247. <- "Masculin - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"
AD_atlan_modif_ajout_genre_mas$Tot <- AD_atlan_modif_ajout_genre_mas$Masc
AD_atlan_modif_ajout_genre_mas <- subset(AD_atlan_modif_ajout_genre_mas, select = -c(Masc, Fem))

AD_atlan_modif_ajout_genre_fem <- AD_atlan_modif_ajout_genre 
AD_atlan_modif_ajout_genre_fem$DIM..Profil.des.aires.de.diffusion..2247. <- "Feminin - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"
AD_atlan_modif_ajout_genre_fem$Tot <-AD_atlan_modif_ajout_genre_fem$Fem
AD_atlan_modif_ajout_genre_fem <- subset(AD_atlan_modif_ajout_genre_fem, select = -c(Masc, Fem))

AD_atlan_modif <- subset(AD_atlan_modif, select = -c(Masc, Fem))
AD_atlan_modif <- AD_atlan_modif[!(AD_atlan_modif$DIM..Profil.des.aires.de.diffusion..2247. == "Total - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"),]

AD_atlan_modif <- do.call('rbind', list(AD_atlan_modif,AD_atlan_modif_ajout_genre_tot,AD_atlan_modif_ajout_genre_mas,AD_atlan_modif_ajout_genre_fem))
AD_atlan_modif <- AD_atlan_modif[order(AD_atlan_modif$NOM_GÉO, AD_atlan_modif$Membre.ID..Profil.des.aires.de.diffusion..2247.),]

save(AD_atlan_modif, file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Provinces_Atlantiques/98-401-X2016044_ATLANTIQUE_fra_CSV/AD_atlan_modif.rda')

AD_atlan_modif_format_shp <- subset(AD_atlan_modif, select = -c(TGN, TGN_FL, INDICATEUR_QUALITÉ_DONNÉES,CODE_GÉO_ALT,
                                                                      
                                                                      Notes..Profil.des.aires.de.diffusion..2247.))

ajout_v <- function(colonne_a_changer, id_member){
  if(id_member %in% 760:779)
  {
    colonne_a_changer <- paste('VV_',colonne_a_changer, sep= "")
  }
  else if(!is.na(as.numeric(substring(colonne_a_changer, 1, 1))))
  {
    colonne_a_changer <- paste('V_',colonne_a_changer, sep= "")
  }else
  {
    colonne_a_changer <- colonne_a_changer
  }
}

AD_atlan_modif_format_shp$DIM..Profil.des.aires.de.diffusion..2247. <- mapply(ajout_v , AD_atlan_modif_format_shp$DIM..Profil.des.aires.de.diffusion..2247., AD_atlan_modif_format_shp$Membre.ID..Profil.des.aires.)

library(dplyr)
liste_ad <- as.data.frame(AD_atlan_modif_format_shp$NOM_GÉO)
liste_ad <- distinct(liste_ad)

for(i in 1:nrow(liste_ad))
{
  tempo <- AD_atlan_modif_format_shp[AD_atlan_modif_format_shp$NOM_GÉO == liste_ad[i,],]
  row.names(tempo) <- tempo$DIM..Profil.des.aires.de.diffusion..2247.
  tempo <- tempo[,c(1,4)]
  tempo2 <- rbind(c(liste_ad[i,],liste_ad[i,]), tempo)
  tempo2 <- t(as.data.frame(tempo2))
  tempo2 <- tempo2[2,]
  
  if(i == 1)
  {
    AD_atlan_modif_format_shp_fin <- tempo2
  }else
  {
    AD_atlan_modif_format_shp_fin <- rbind(AD_atlan_modif_format_shp_fin, tempo2)
  }
  print(i)
}

AD_atlan_modif_format_shp_fin_df <- as.data.frame(AD_atlan_modif_format_shp_fin)
names(AD_atlan_modif_format_shp_fin_df)[names(AD_atlan_modif_format_shp_fin_df) == "1"] <- "NOM_GEO"
rownames(AD_atlan_modif_format_shp_fin_df) <- NULL

save(AD_atlan_modif_format_shp_fin_df, file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Provinces_Atlantiques/98-401-X2016044_ATLANTIQUE_fra_CSV/Stats_can_ad_atlan.rda')
write.csv(AD_atlan_modif_format_shp_fin_df, file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Provinces_Atlantiques/98-401-X2016044_ATLANTIQUE_fra_CSV/Stats_can_ad_atlan.csv')

rm(list=ls())
gc()

####Territoire####
library(dplyr)

AD_ter <- read.csv(file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Territoires/98-401-X2016044_TERRITOIRES_fra_CSV/98-401-X2016044_TERRITOIRES_Francais_CSV_data.csv')

AD_ter_modif<-AD_ter[!(AD_ter$CODE_GÉO..LDR. == 1 |  AD_ter$CODE_GÉO..LDR. == 10),]
AD_ter_modif <- AD_ter_modif[!(AD_ter_modif$NIVEAU_GÉO == 2),]
AD_ter_modif <- AD_ter_modif[!(AD_ter_modif$NIVEAU_GÉO == 3),]
AD_ter_modif <- AD_ter_modif[,-(1:3)]

liste_a_garder <- c(1,4,6,8:33,42,43,51:56,58,78,79,80,87,100,105,662,663,665,693, 695:707, 725,742,743,760:779,836,847,1148,1324,1337,1644,1683:1697)

AD_ter_modif <- AD_ter_modif[which(AD_ter_modif$Membre.ID..Profil.des.aires.de.diffusion..2247. %in% liste_a_garder),]

names(AD_ter_modif)[names(AD_ter_modif) == "Dim..Sexe..3...Membre.ID...1...Total...Sexe" ] <- "Tot"
names(AD_ter_modif)[names(AD_ter_modif) == "Dim..Sexe..3...Membre.ID...2...Sexe.masculin"] <- "Masc"
names(AD_ter_modif)[names(AD_ter_modif) == "Dim..Sexe..3...Membre.ID...3...Sexe.féminin" ] <- "Fem"

AD_ter_modif$Tot[AD_ter_modif$Tot == "..."] <- NA
AD_ter_modif$Fem[AD_ter_modif$Fem == "..."] <- NA
AD_ter_modif$Masc[AD_ter_modif$Masc == "..."] <- NA

AD_ter_modif_ajout_genre <- AD_ter_modif[AD_ter_modif$Membre.ID..Profil.des.aires.de.diffusion..2247. == 8,]
AD_ter_modif_ajout_genre_tot <- AD_ter_modif_ajout_genre
AD_ter_modif_ajout_genre_tot$DIM..Profil.des.aires.de.diffusion..2247. <- "Total - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"
AD_ter_modif_ajout_genre_tot <- subset(AD_ter_modif_ajout_genre_tot, select = -c(Masc, Fem))

AD_ter_modif_ajout_genre_mas <- AD_ter_modif_ajout_genre
AD_ter_modif_ajout_genre_mas$DIM..Profil.des.aires.de.diffusion..2247. <- "Masculin - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"
AD_ter_modif_ajout_genre_mas$Tot <- AD_ter_modif_ajout_genre_mas$Masc
AD_ter_modif_ajout_genre_mas <- subset(AD_ter_modif_ajout_genre_mas, select = -c(Masc, Fem))

AD_ter_modif_ajout_genre_fem <- AD_ter_modif_ajout_genre 
AD_ter_modif_ajout_genre_fem$DIM..Profil.des.aires.de.diffusion..2247. <- "Feminin - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"
AD_ter_modif_ajout_genre_fem$Tot <-AD_ter_modif_ajout_genre_fem$Fem
AD_ter_modif_ajout_genre_fem <- subset(AD_ter_modif_ajout_genre_fem, select = -c(Masc, Fem))

AD_ter_modif <- subset(AD_ter_modif, select = -c(Masc, Fem))
AD_ter_modif <- AD_ter_modif[!(AD_ter_modif$DIM..Profil.des.aires.de.diffusion..2247. == "Total - Groupes d'âge et âge moyen de la population - Données intégrales (100 %)"),]

AD_ter_modif <- do.call('rbind', list(AD_ter_modif,AD_ter_modif_ajout_genre_tot,AD_ter_modif_ajout_genre_mas,AD_ter_modif_ajout_genre_fem))
AD_ter_modif <- AD_ter_modif[order(AD_ter_modif$NOM_GÉO, AD_ter_modif$Membre.ID..Profil.des.aires.de.diffusion..2247.),]

save(AD_ter_modif, file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Territoires/98-401-X2016044_TERRITOIRES_fra_CSV/AD_ter_modif.rda')

AD_ter_modif_format_shp <- subset(AD_ter_modif, select = -c(TGN, TGN_FL, INDICATEUR_QUALITÉ_DONNÉES,CODE_GÉO_ALT,
                                                                
                                                                Notes..Profil.des.aires.de.diffusion..2247.))

ajout_v <- function(colonne_a_changer, id_member){
  if(id_member %in% 760:779)
  {
    colonne_a_changer <- paste('VV_',colonne_a_changer, sep= "")
  }
  else if(!is.na(as.numeric(substring(colonne_a_changer, 1, 1))))
  {
    colonne_a_changer <- paste('V_',colonne_a_changer, sep= "")
  }else
  {
    colonne_a_changer <- colonne_a_changer
  }
}

AD_ter_modif_format_shp$DIM..Profil.des.aires.de.diffusion..2247. <- mapply(ajout_v , AD_ter_modif_format_shp$DIM..Profil.des.aires.de.diffusion..2247., AD_ter_modif_format_shp$Membre.ID..Profil.des.aires.)

library(dplyr)
liste_ad <- as.data.frame(AD_ter_modif_format_shp$NOM_GÉO)
liste_ad <- distinct(liste_ad)

for(i in 1:nrow(liste_ad))
{
  tempo <- AD_ter_modif_format_shp[AD_ter_modif_format_shp$NOM_GÉO == liste_ad[i,],]
  row.names(tempo) <- tempo$DIM..Profil.des.aires.de.diffusion..2247.
  tempo <- tempo[,c(1,4)]
  tempo2 <- rbind(c(liste_ad[i,],liste_ad[i,]), tempo)
  tempo2 <- t(as.data.frame(tempo2))
  tempo2 <- tempo2[2,]
  
  if(i == 1)
  {
    AD_ter_modif_format_shp_fin <- tempo2
  }else
  {
    AD_ter_modif_format_shp_fin <- rbind(AD_ter_modif_format_shp_fin, tempo2)
  }
  print(i)
}

AD_ter_modif_format_shp_fin_df <- as.data.frame(AD_ter_modif_format_shp_fin)
names(AD_ter_modif_format_shp_fin_df)[names(AD_ter_modif_format_shp_fin_df) == "1"] <- "NOM_GEO"
rownames(AD_ter_modif_format_shp_fin_df) <- NULL

save(AD_ter_modif_format_shp_fin_df, file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Territoires/98-401-X2016044_TERRITOIRES_fra_CSV/Stats_can_ad_ter.rda')
write.csv(AD_ter_modif_format_shp_fin_df, file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Territoires/98-401-X2016044_TERRITOIRES_fra_CSV/Stats_can_ad_ter.csv')

rm(list=ls())
gc()

