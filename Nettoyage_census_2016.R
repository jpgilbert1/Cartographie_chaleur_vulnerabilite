#####Lectures du fichier d'AD######
library(dplyr)

AD_qc <- read.csv(file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Quebec/98-401-X2016044_QUEBEC_fra_CSV/98-401-X2016044_QUEBEC_Francais_CSV_data.csv')

AD_qc_modif<-AD_qc[!(AD_qc$CODE_GÉO..LDR. == 1 |  AD_qc$CODE_GÉO..LDR. == 24),]
AD_qc_modif <- AD_qc_modif[!(AD_qc_modif$NIVEAU_GÉO == 2),]
AD_qc_modif <- AD_qc_modif[!(AD_qc_modif$NIVEAU_GÉO == 3),]
AD_qc_modif <- AD_qc_modif[,-(1:3)]

test <- AD_qc_modif[1:100,]
liste_a_garder <- c(1,4,5,6,7,34:73,87,100:109,661:687, 691:707, 741:779, 800:847)

AD_qc_modif <- AD_qc_modif[which(AD_qc_modif$Membre.ID..Profil.des.aires.de.diffusion..2247. %in% liste_a_garder),]
names(AD_qc_modif)[names(AD_qc_modif) == "Dim..Sexe..3...Membre.ID...1...Total...Sexe" ] <- "Tot_deux_sexes"
names(AD_qc_modif)[names(AD_qc_modif) == "Dim..Sexe..3...Membre.ID...2...Sexe.masculin"] <- "Masc"
names(AD_qc_modif)[names(AD_qc_modif) == "Dim..Sexe..3...Membre.ID...3...Sexe.féminin" ] <- "Fem"

test <- AD_qc_modif[1:300,]
test$Fem[test$Fem == "..."] <- NA

AD_qc_modif$Tot_deux_sexes[AD_qc_modif$Tot_deux_sexes == "..."] <- NA
AD_qc_modif$Fem[AD_qc_modif$Fem == "..."] <- NA
AD_qc_modif$Masc[AD_qc_modif$Masc == "..."] <- NA

for (i in 1:nrow(AD_qc_modif))
{
  if(AD_qc_modif$Membre.ID..Profil.des.aires.de.diffusion..2247.[i] %in% c(35:38))
  {
    AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i] <- paste('Répartition (%) de la population', AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i], sep= " ")
  }else if(AD_qc_modif$Membre.ID..Profil.des.aires.de.diffusion..2247.[i] %in% c(45:50)){
    AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i] <- paste('Autre logement attenant', AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i], sep= " ")
  }else if(AD_qc_modif$Membre.ID..Profil.des.aires.de.diffusion..2247.[i] %in% c(51:56))
  {
    AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i] <- paste('Ménages privés selon la taille du ménage', AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i], sep= " ")
  }else if(AD_qc_modif$Membre.ID..Profil.des.aires.de.diffusion..2247.[i] %in% c(59:67))
  {
    AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i] <- paste('État matrimonial pour la population âgée de 15 ans et plus', AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i], sep= " ")
  }else if(AD_qc_modif$Membre.ID..Profil.des.aires.de.diffusion..2247.[i] %in% c(68:72))
  {
    AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i] <- paste('Familles de recensement dans les ménages privés selon la taille de la famille', AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i], sep= " ")
  }else if(AD_qc_modif$Membre.ID..Profil.des.aires.de.diffusion..2247.[i] %in% c(100:104))
  {
    AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i] <- paste('Connaissance des langues officielles', AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i], sep= " ")
  }else if(AD_qc_modif$Membre.ID..Profil.des.aires.de.diffusion..2247.[i] %in% c(692:707))
  {
    AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i] <- paste('Tranches de revenu total en 2015 pour la population âgée de 15 ans et plus', AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i], sep= " ")
  }
  else if(AD_qc_modif$Membre.ID..Profil.des.aires.de.diffusion..2247.[i] %in% c(760:779))
  {
    AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i] <- paste('Tranches de revenu total du ménage en 2015 pour les ménages privés', AD_qc_modif$DIM..Profil.des.aires.de.diffusion..2247.[i], sep= " ")
  }
}

save(AD_qc_modif, file = '/Users/jean-philippegilbert/Documents/Université Laval/Cartographie vulnérabilité vagues de chaleur accamblante - General/Data/Stat_can_2016/Quebec/98-401-X2016044_QUEBEC_fra_CSV/AD_qc_modif.rda')
#AD_qc_modif <- AD_qc_modif[!(AD_qc_modif$CODE_GÉO..LDR. == 24 ),]
