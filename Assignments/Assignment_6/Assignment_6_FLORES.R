library(tidyverse)

dat<-read_csv("../../Data/BioLog_Plate_Data.csv")

dat

dat2<-dat %>% 
  pivot_longer(c(Hr_24, Hr_48, Hr_144),
               names_to="Hours",
               values_to= "Concentrations")

dat3<-dat2 %>% 
  pivot_wider(id_cols= c(Rep,Well,Dilution, Substrate, Hours),
              names_from= `Sample ID`,
              values_from= Concentrations)
