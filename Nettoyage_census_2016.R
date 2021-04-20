#####Lectures du fichier d'AD######
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


test <- AD_qc_modif_format_shp[AD_qc_modif_format_shp$NOM_GÉO == 24010019,]
row.names(test) <- test$DIM..Profil.des.aires.de.diffusion..2247.

test <- test[,c(1,4)]
test2 <- rbind(c(24010019,24010019), test)

test2 <- t(as.data.frame(test2))
test2 <- test2[2,]
test3 <- rbind(test2, test2)

test3 <- as.data.frame(test3)

row.names(AD_qc_modif_format_shp) <- AD_qc_modif_format_shp$DIM..Profil.des.aires.de.diffusion..2247.
#for (i in 1:nrow(AD_qc_modif))
#{
#  if(AD_qc_modif$Membre.ID..Profil.des.aires.de.diffusion..2247.[i] %in% c(35:38))
#  {
#    AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i] <- paste('Répartition (%) de la population', AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i], sep= " ")
#  }else if(AD_qc_modif$Membre.ID..Profil.des.aires.de.diffusion..2247.[i] %in% c(45:50)){
#    AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i] <- paste('Autre logement attenant', AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i], sep= " ")
#  }else if(AD_qc_modif$Membre.ID..Profil.des.aires.de.diffusion..2247.[i] %in% c(51:56))
#  {
#    AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i] <- paste('Ménages privés selon la taille du ménage', AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i], sep= " ")
#  }else if(AD_qc_modif$Membre.ID..Profil.des.aires.de.diffusion..2247.[i] %in% c(59:67))
#  {
#    AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i] <- paste('État matrimonial pour la population âgée de 15 ans et plus', AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i], sep= " ")
#  }else if(AD_qc_modif$Membre.ID..Profil.des.aires.de.diffusion..2247.[i] %in% c(68:72))
#  {
#    AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i] <- paste('Familles de recensement dans les ménages privés selon la taille de la famille', AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i], sep= " ")
#  }else if(AD_qc_modif$Membre.ID..Profil.des.aires.de.diffusion..2247.[i] %in% c(100:104))
#  {
#    AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i] <- paste('Connaissance des langues officielles', AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i], sep= " ")
#  }else if(AD_qc_modif$Membre.ID..Profil.des.aires.de.diffusion..2247.[i] %in% c(692:707))
#  {
#    AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i] <- paste('Tranches de revenu total en 2015 pour la population âgée de 15 ans et plus', AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i], sep= " ")
#  }
#  else if(AD_qc_modif$Membre.ID..Profil.des.aires.de.diffusion..2247.[i] %in% c(760:779))
#  {
#    AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i] <- paste('Tranches de revenu total du ménage en 2015 pour les ménages privés', AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i], sep= " ")
#  }
#}



save(AD_qc_modif, file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Quebec/98-401-X2016044_QUEBEC_fra_CSV/AD_qc_modif.rda')

write.csv(test, file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Quebec/98-401-X2016044_QUEBEC_fra_CSV/AD_qc_modif.csv')
#AD_qc_modif <- AD_qc_modif[!(AD_qc_modif$CODE_GÉO..LDR. == 24 ),]
