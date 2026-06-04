##HO - Meeting precision criteria in paediatric PK studies##
#Curve fitting for L,M,S data#
##Elin Svensson, Oskar Clewe

library(polynom)

#Set path to wd
working.directory <- "//argos.storage.uu.se/MyFolder$/yujli183/PMxLab/Projects/BDQ and DLM daily dosing pediatrics/Rcodes/vir-pop-children-LMS/"
setwd(working.directory)

#Read LMS data
LMS_MALE <-  read.csv("male_LMS_values.csv",header=T, as.is=T)
LMS_FEMALE <-  read.csv("female_LMS_values.csv",header=T, as.is=T)

#Function for L data

  #Function for L, males
LMS_MALE_60 <-   LMS_MALE[ which(LMS_MALE$AGE<=60), ]
LMS_MALE_lt_8 <- LMS_MALE[ which(LMS_MALE$AGE<=8), ]
LMS_MALE_gt_8_lt60 <- LMS_MALE[ which(LMS_MALE$AGE>8&LMS_MALE$AGE<=60), ]

LMS_MALE_120 <-   LMS_MALE[ which(LMS_MALE$AGE<=120&LMS_MALE$AGE>60), ]
LMS_MALE_gt_120 <-   LMS_MALE[ which(LMS_MALE$AGE>120), ]

lm_L_MALE_602 <- lm(LMS_MALE_60$L~LMS_MALE_60$AGE+I(LMS_MALE_60$AGE^2)+I(LMS_MALE_60$AGE^3)) #+I(LMS_MALE_60$AGE^4)  #yes
lm_L_MALE_120 <- lm(LMS_MALE_120$L~LMS_MALE_120$AGE+I(LMS_MALE_120$AGE^2)+I(LMS_MALE_120$AGE^3)) #+I(LMS_MALE_60$AGE^4) #yes
lm_L_MALE_gt_1202 <- lm(LMS_MALE_gt_120$L~LMS_MALE_gt_120$AGE+I(LMS_MALE_gt_120$AGE^2)+I(LMS_MALE_gt_120$AGE^3)+I(LMS_MALE_gt_120$AGE^4) )
  
  #summary(lm_L_MALE)
    #Plot L data and L approximation line, males
    LvsAGE_MALE_PLOT <- plot(LMS_MALE$AGE,LMS_MALE$L,main="MALE\nL vs. AGE",xlab="AGE (months)",ylab="L")
    vec <- seq(0, 60, by=1)
    lines(vec,coef(lm_L_MALE_602)[1] + coef(lm_L_MALE_602)[2]*vec +coef(lm_L_MALE_602)[3]*vec^2+coef(lm_L_MALE_602)[4]*vec^3, col="red",lwd="5" )
    vec <- seq(60, 120, by=1)
    lines(vec,coef(lm_L_MALE_120)[1] + coef(lm_L_MALE_120)[2]*vec +coef(lm_L_MALE_120)[3]*vec^2+coef(lm_L_MALE_120)[4]*vec^3, col="red",lwd="5" )
    vec <- seq(120, 216, by=1)
    lines(vec,coef(lm_L_MALE_gt_1202)[1] + coef(lm_L_MALE_gt_1202)[2]*vec +coef(lm_L_MALE_gt_1202)[3]*vec^2+coef(lm_L_MALE_gt_1202)[4]*vec^3+coef(lm_L_MALE_gt_1202)[5]*vec^4, col="red",lwd="5" )
    
  
  #Function for L, females
  LMS_FEMALE_60 <-   LMS_FEMALE[ which(LMS_FEMALE$AGE<=60), ]
  LMS_FEMALE_lt_8 <- LMS_FEMALE[ which(LMS_FEMALE$AGE<=8), ]
  LMS_FEMALE_gt_8_lt60 <- LMS_FEMALE[ which(LMS_FEMALE$AGE>8&LMS_FEMALE$AGE<=60), ]
  
  LMS_FEMALE_120 <-   LMS_FEMALE[ which(LMS_FEMALE$AGE<=120&LMS_FEMALE$AGE>60), ]
  LMS_FEMALE_gt_120 <-   LMS_FEMALE[ which(LMS_FEMALE$AGE>120), ]
  
  
  lm_L_FEMALE_60 <- lm(LMS_FEMALE_60$L~LMS_FEMALE_60$AGE+I(LMS_FEMALE_60$AGE^2)+I(LMS_FEMALE_60$AGE^3)+I(LMS_MALE_60$AGE^4)+I(LMS_MALE_60$AGE^5) ) #  #yes
  lm_L_FEMALE_120 <- lm(LMS_FEMALE_120$L ~ LMS_FEMALE_120$AGE+I(LMS_FEMALE_120$AGE^2)) #+I(LMS_FEMALE_120$AGE^3)+I(LMS_MALE_60$AGE^4) #yes
  lm_L_FEMALE_gt_1202 <- lm(LMS_FEMALE_gt_120$L ~ LMS_FEMALE_gt_120$AGE+I(LMS_FEMALE_gt_120$AGE^2)+I(LMS_FEMALE_gt_120$AGE^3)+I(LMS_FEMALE_gt_120$AGE^4) ) #yes
  
  #summary(lm_L_FEMALE)


    #Plot L data and L approximation line, females
    LvsAGE_FEMALE_PLOT<-plot(LMS_FEMALE$AGE,LMS_FEMALE$L,main="FEMALE\nL vs. AGE",xlab="AGE (months)",ylab="L")
    vec <- seq(0, 60, by=1)
    lines(vec,coef(lm_L_FEMALE_60)[1] + coef(lm_L_FEMALE_60)[2]*vec +coef(lm_L_FEMALE_60)[3]*vec^2 +coef(lm_L_FEMALE_60)[4]*vec^3 
          +coef(lm_L_FEMALE_60)[5]*vec^4+coef(lm_L_FEMALE_60)[6]*vec^5, col="red",lwd="5" )
    vec <- seq(61, 120, by=1)
    lines(vec,coef(lm_L_FEMALE_120)[1] + coef(lm_L_FEMALE_120)[2]*vec +coef(lm_L_FEMALE_120)[3]*vec^2, col="red",lwd="5" )
    vec <- seq(121, 216, by=1)
    lines(vec,coef(lm_L_FEMALE_gt_1202)[1] + coef(lm_L_FEMALE_gt_1202)[2]*vec +coef(lm_L_FEMALE_gt_1202)[3]*vec^2+coef(lm_L_FEMALE_gt_1202)[4]*vec^3+coef(lm_L_FEMALE_gt_1202)[5]*vec^4, 
          col="red",lwd="5" )

#Function for S data
  
  #Subset S data based on AGE<150 and AGE>150
  LMS_MALE_AGE_le_150 <- LMS_MALE[ which(LMS_MALE$AGE<=150), ]
  LMS_MALE_AGE_gt_150 <- LMS_MALE[ which(LMS_MALE$AGE>150), ]
  LMS_FEMALE_AGE_le_150  <- LMS_FEMALE[ which(LMS_FEMALE$AGE<=150), ]
  LMS_FEMALE_AGE_gt_150  <- LMS_FEMALE[ which(LMS_FEMALE$AGE>150), ]

  #Function for S male
  lm_S_MALE_AGE_le_150<-lm(LMS_MALE_AGE_le_150$S~LMS_MALE_AGE_le_150$AGE)
  #summary(lm_S_MALE_AGE_le_150)
  lm_S_MALE_AGE_gt_150<-lm(LMS_MALE_AGE_gt_150$S~LMS_MALE_AGE_gt_150$AGE)
  #summary(lm_S_MALE_AGE_gt_150)
  
  lm_S_MALE_lt_8 <- lm(LMS_MALE_lt_8$S ~ LMS_MALE_lt_8$AGE+I(LMS_MALE_lt_8$AGE^2) +I(LMS_MALE_lt_8$AGE^3)) #                   #yes
  lm_S_MALE_gt_8_lt60 <- lm(LMS_MALE_gt_8_lt60$S ~ LMS_MALE_gt_8_lt60$AGE+I(LMS_MALE_gt_8_lt60$AGE^2) +I(LMS_MALE_gt_8_lt60$AGE^3) +I(LMS_MALE_gt_8_lt60$AGE^4)) # yes 
  
  lm_S_MALE_120 <- lm(LMS_MALE_120$S ~ LMS_MALE_120$AGE+I(LMS_MALE_120$AGE^2)+I(LMS_MALE_120$AGE^3)) #+I(LMS_MALE_60$AGE^4)                   #yes
  lm_S_MALE_gt_120 <- lm(LMS_MALE_gt_120$S ~ LMS_MALE_gt_120$AGE+I(LMS_MALE_gt_120$AGE^2)+I(LMS_MALE_gt_120$AGE^3)+I(LMS_MALE_gt_120$AGE^4) ) #yes

    #Plot S data and S approximation line, males
    SvsAGE_MALE_PLOT<-plot(LMS_MALE$AGE,LMS_MALE$S,main="MALE\nS vs. AGE",xlab="AGE (months)",ylab="S")
      vec <- seq(0, 8, by=1)
      lines(vec,coef(lm_S_MALE_lt_8)[1] + coef(lm_S_MALE_lt_8)[2]*vec +coef(lm_S_MALE_lt_8)[3]*vec^2+coef(lm_S_MALE_lt_8)[4]*vec^3, col="red",lwd="5" )
      vec <- seq(9, 60, by=1)
      lines(vec,coef(lm_S_MALE_gt_8_lt60)[1] + coef(lm_S_MALE_gt_8_lt60)[2]*vec +coef(lm_S_MALE_gt_8_lt60)[3]*vec^2+coef(lm_S_MALE_gt_8_lt60)[4]*vec^3
            +coef(lm_S_MALE_gt_8_lt60)[5]*vec^4
            , col="red",lwd="5" )
      
      vec <- seq(61, 120, by=1)
      lines(vec,coef(lm_S_MALE_120)[1] + coef(lm_S_MALE_120)[2]*vec +coef(lm_S_MALE_120)[3]*vec^2+coef(lm_S_MALE_120)[4]*vec^3, col="red",lwd="5" )
      vec <- seq(121, 216, by=1)
      lines(vec,coef(lm_S_MALE_gt_120)[1] + coef(lm_S_MALE_gt_120)[2]*vec +coef(lm_S_MALE_gt_120)[3]*vec^2+coef(lm_S_MALE_gt_120)[4]*vec^3+coef(lm_S_MALE_gt_120)[5]*vec^4, 
            col="red",lwd="5" ) #
      
  #Function for S female
  lm_S_FEMALE_AGE_le_150<-lm(LMS_FEMALE_AGE_le_150$S~LMS_FEMALE_AGE_le_150$AGE)
  #summary(lm_S_FEMALE_AGE_le_150)
  lm_S_FEMALE_AGE_gt_150<-lm(LMS_FEMALE_AGE_gt_150$S~LMS_FEMALE_AGE_gt_150$AGE)
  #summary(lm_S_FEMALE_AGE_gt_150)
  
  lm_S_FEMALE_lt_8 <- lm(LMS_FEMALE_lt_8$S ~ LMS_FEMALE_lt_8$AGE+I(LMS_FEMALE_lt_8$AGE^2) +I(LMS_FEMALE_lt_8$AGE^3) ) #                   #yes
  lm_S_FEMALE_gt_8_lt60 <- lm(LMS_FEMALE_gt_8_lt60$S ~ LMS_FEMALE_gt_8_lt60$AGE+I(LMS_FEMALE_gt_8_lt60$AGE^2) +I(LMS_FEMALE_gt_8_lt60$AGE^3) 
                              +I(LMS_FEMALE_gt_8_lt60$AGE^4)) # yes
  
  lm_S_FEMALE_120 <- lm(LMS_FEMALE_120$S ~ LMS_FEMALE_120$AGE+I(LMS_FEMALE_120$AGE^2)) #+I(LMS_FEMALE_120$AGE^3)+I(LMS_MALE_60$AGE^4) #yes
  lm_S_FEMALE_gt_120 <- lm(LMS_FEMALE_gt_120$S ~ LMS_FEMALE_gt_120$AGE+I(LMS_FEMALE_gt_120$AGE^2)+I(LMS_FEMALE_gt_120$AGE^3) +I(LMS_FEMALE_gt_120$AGE^4)) #yes

    #Plot S data and S approximation line, females
    SvsAGE_FEMALE_PLOT<-plot(LMS_FEMALE$AGE,LMS_FEMALE$S,main="FEMALE\nS vs. AGE",xlab="AGE (months)",ylab="S")
      vec <- seq(0, 8, by=1)
      lines(vec,coef(lm_S_FEMALE_lt_8)[1] + coef(lm_S_FEMALE_lt_8)[2]*vec +coef(lm_S_FEMALE_lt_8)[3]*vec^2 +coef(lm_S_FEMALE_lt_8)[4]*vec^3, col="red",lwd="5" )
      vec <- seq(9, 60, by=1)
      lines(vec,coef(lm_S_FEMALE_gt_8_lt60)[1] + coef(lm_S_FEMALE_gt_8_lt60)[2]*vec +coef(lm_S_FEMALE_gt_8_lt60)[3]*vec^2 
            +coef(lm_S_FEMALE_gt_8_lt60)[4]*vec^3 +coef(lm_S_FEMALE_gt_8_lt60)[5]*vec^4, col="red",lwd="5" )
      vec <- seq(61, 120, by=1)
      lines(vec,coef(lm_S_FEMALE_120)[1] + coef(lm_S_FEMALE_120)[2]*vec +coef(lm_S_FEMALE_120)[3]*vec^2, col="red",lwd="5" )
      vec <- seq(121, 216, by=1)
      lines(vec,coef(lm_S_FEMALE_gt_120)[1] + coef(lm_S_FEMALE_gt_120)[2]*vec +coef(lm_S_FEMALE_gt_120)[3]*vec^2 +coef(lm_S_FEMALE_gt_120)[4]*vec^3
            +coef(lm_S_FEMALE_gt_120)[5]*vec^4
            , col="red",lwd="5" )
      lines(vec,-0.2138 + (0.004139)*vec +(0.00001957)*vec^2 + (-0.0000003040)*vec^3 + (0.0000000007493)*vec^4, col="red",lwd="5"  )

#Function for M data
  
  #Function for M data, males
  lm_M_MALE<-lm(LMS_MALE$M~LMS_MALE$AGE+I(LMS_MALE$AGE^2)+I(LMS_MALE$AGE^3)+I(LMS_MALE$AGE^4))
  #summary(lm_M_MALE)

  #Function for M data, females
  lm_M_FEMALE<-lm(LMS_FEMALE$M~LMS_FEMALE$AGE+I(LMS_FEMALE$AGE^2)+I(LMS_FEMALE$AGE^3)+I(LMS_FEMALE$AGE^4))
  #summary(lm_M_FEMALE)

    #Plot M data and M approximation line, males
    MvsAGE_MALE_PLOT<-plot(LMS_MALE$AGE,LMS_MALE$M,main="MALE\nM vs. AGE",xlab="AGE (months)",ylab="M")
      vec <- seq(0, 216, by=1)
      lines(vec,coef(lm_M_MALE)[1] + coef(lm_M_MALE)[2]*vec +coef(lm_M_MALE)[3]*vec^2+coef(lm_M_MALE)[4]*vec^3+coef(lm_M_MALE)[5]*vec^4, col="red",lwd="5" )
      lines(vec,4.904809 + 0.4209516*vec +(-0.005652092)*vec^2 + 0.0000459*vec^3 + (-0.00000010448529)*vec^4, col="red",lwd="5"  )
    #Plot M data and M approximation line, females
    MvsAGE_FEMALE_PLOT<-plot(c(LMS_FEMALE$AGE,217),c(LMS_FEMALE$M,100),main="FEMALE\nM vs. AGE",xlab="AGE (months)",ylab="M")
      vec <- seq(0, 216, by=1)
      lines(vec,coef(lm_M_FEMALE)[1] + coef(lm_M_FEMALE)[2]*vec +coef(lm_M_FEMALE)[3]*vec^2+coef(lm_M_FEMALE)[4]*vec^3+coef(lm_M_FEMALE)[5]*vec^4, col="red",lwd="5" )
      lines(vec,4.832 + 0.3743*vec +(-0.004874)*vec^2 + 0.00004466*vec^3 + (-0.0000001167)*vec^4, col="red",lwd="5"  )
      
      
      