rm(list = ls())
path <- 'G:/data/xingwiexue/'
#设置所有行为学数据存放路径
file_list <- matrix(c(1:34),nrow=34,ncol = 1)
#设置被试数量
file_name_list <- matrix(c(1:length(file_list)),nrow = length(file_list),ncol = 1)
groups_var <-c("对照组","口吃组",rep("对照组",7),rep("口吃组",11),rep("对照组",7),rep("口吃组",4),rep("对照组",2),rep("口吃组",1))
age_var <- c(25,20,26,21,25,21,24,23,19,25,18,16,31,22,30,36,30,22,24,24,22,26,19,23,23,21,19,41,20,24,23,22,22,22)
education_var <- c(18,12,17,16,16,14,17,16,13,12,12,16,16,15,15,16,12,16,16,16,15,16,13,16,16,15,13,16,15,16,16,14,14,16)
SSI_3_var <-c(0,26,0,0,0,0,0,0,0,25,20,21,15,17,20,18,23,30,28,25,0,0,0,0,0,0,0,17,27,31,18,0,0,31)
OASES_var <-c(0,48,0,0,0,0,0,0,0,65,45,64,43,59,48,51,59,56,57,51,0,0,0,0,0,0,0,54.4,45.5,61,56.6,0,0,90.6)
#生成被试文件夹表
for(i in 1:length(file_list)){
  file_name_tp <- file_list[i,1]
  if (file_name_tp < 10){
    file_name <- paste('000',as.character(file_name_tp),sep = '')
  }else{
    file_name <- paste('00',as.character(file_name_tp),sep = '')
  }
  file_name_list[i,1] <- file_name
}
library("rio")
library("dplyr")
library(tidyverse, quietly = TRUE)
data_name_list <- matrix(c(1:length(file_list)),nrow = length(file_list),ncol = 1)
for(h in 1:length(file_list)){
  file_name_tp1 <- file_list[h,1]
  data_list_name <- paste('data',as.character(file_name_tp1),sep = '_')
  data_name_list[h,1] <- data_list_name
}
data_all_list <- list()
data_final <- data.frame(condition=0,stimu.ACC=0,stimu.RT=0,Block=0,word=0,sub_id=0,group=0,age=0,education=0,SSI_3=0,OASES=0)
for(n in 1: length(file_name_list)){
  file_name <- file_name_list[n,1]
  setwd(paste(path,file_name,sep = ''))
  #导入数据
  print(getwd())
  data1 <- import("run1.xls")
  data2 <- import("run2.xls")
  #筛选需要的变量
  data1new <- select(data1,condition,stimu.ACC,stimu.RT,Block,word)
  
  
  data2new <- select(data2,condition,stimu.ACC,stimu.RT,Block,word)
  #对两个run的数据进行合并
  data_all <- rbind(data1new,data2new) %>%filter_all(all_vars(!is.na(.)))%>%
                    mutate(sub_id = rep(paste("sub",as.character(n),sep = "_"),time=200))%>%
                      mutate(group=rep(groups_var[n],200),age=rep(age_var[n],200),education=rep(education_var[n],200),
                             SSI_3=rep(SSI_3_var[n],200),OASES=rep(OASES_var[n],200))
  data_final <- rbind(data_final,data_all)
}

data_final <- filter(data_final,condition != 0)
#年龄和教育水平的组间T检验
data_final %>% select(sub_id,group,age,education,SSI_3,OASES) %>% unique() ->tmp_group_age
tmp_group_age %>% filter(group=="口吃组") %>% select(age) %>% as.matrix() %>%  shapiro.test()
tmp_group_age %>% filter(group=="对照组") %>% select(age) %>% as.matrix() %>%  shapiro.test()
tmp_group_age %>% filter(group=="口吃组") %>% select(education) %>% as.matrix() %>%  shapiro.test()
tmp_group_age %>% filter(group=="对照组") %>% select(education) %>% as.matrix() %>%  shapiro.test()

t.test(age ~ group,data= tmp_group_age,paired=FALSE)
effsize::cohen.d(tmp_group_age$age~tmp_group_age$group,hedges.correction=TRUE)

wilcox.test(education ~ group,data= tmp_group_age,alternative="less",exact=FALSE,correct=FALSE,paired=FALSE)

effsize::cohen.d(tmp_group_age$education~tmp_group_age$group,hedges.correction=TRUE)

tmp_group_age %>% group_by(group) %>% summarise(mean_age = mean(age),sd_age = sd(age),mean_education = mean(education),sd_education = sd(education))

tmp_group_age %>% filter(group=="口吃组") %>% group_by(group) %>% summarise(mean_SSI3 = mean(SSI_3),sd_SSI3 = sd(SSI_3),mean_OASES = mean(OASES),sd_OASES = sd(OASES))


names(data_final)[4] <- "item"
data_prime <- filter(data_final,condition %in% c("A","B"))
data_interefrence <- filter(data_final,condition %in% c("C","D"))

loction_1 <- which(data_prime$condition=="A")
for(m in 1:length(loction_1)){
  times <- loction_1[m]
  data_prime$condition[times] <- "Prime"}

loction_2 <- which(data_prime$condition=="B")
for(m in 1:length(loction_2)){
  times <- loction_2[m]
  data_prime$condition[times] <- "No_prime"}

loction_3 <- which(data_interefrence$condition=="C")
for(m in 1:length(loction_3)){
  times <- loction_3[m]
  data_interefrence$condition[times] <- "No_interference"}

loction_4 <- which(data_interefrence$condition=="D")
for(m in 1:length(loction_4)){
  times <- loction_4[m]
  data_interefrence$condition[times] <- "interference"}








#z-secor
data_prime_zstandard <- data.frame(condition=0,stimu.ACC=0,stimu.RT=0,item=0,word=0,sub_id=0,group=0,age=0,education=0,SSI_3=0,OASES=0)
for(m in c(1:33)){
  sub_id1 = paste("sub",as.character(m),sep = "_")
  data_prime %>% filter(stimu.ACC==1 & condition=="Prime" & sub_id==sub_id1) %>% 
    filter(stimu.RT<mean(stimu.RT)+3*sd(stimu.RT)|stimu.RT>mean(stimu.RT)-3*sd(stimu.RT)) -> data_tmp1
  data_prime %>% filter(stimu.ACC==1 & condition=="No_prime" & sub_id==sub_id1) %>% 
    filter(stimu.RT<mean(stimu.RT)+3*sd(stimu.RT)|stimu.RT>mean(stimu.RT)-3*sd(stimu.RT)) -> data_tmp2
  
  data_prime_zstandard <- rbind(data_prime_zstandard,data_tmp1) %>% rbind(data_tmp2)
}
data_prime_zstandard <- filter(data_prime_zstandard,condition != 0 & sub_id != "sub_18") 
data_prime_zstandard$stimu.RT <- log10(data_prime_zstandard$stimu.RT)
data_prime_zstandard %>% filter(group=="口吃组") %>% group_by(condition,sub_id) %>%
              summarise(mean_rt = mean(stimu.RT))  %>% ungroup()%>% 
              filter(condition=="Prime")%>% select(mean_rt) %>% as.matrix() %>%  shapiro.test()

data_prime_zstandard %>% filter(group=="对照组") %>% group_by(condition,sub_id) %>%
  summarise(mean_rt = mean(stimu.RT))  %>% ungroup()%>% 
  filter(condition=="Prime")%>% select(mean_rt) %>% as.matrix() %>%  shapiro.test()

data_prime_zstandard %>% filter(group=="口吃组") %>% group_by(condition,sub_id) %>%
  summarise(mean_rt = mean(stimu.RT))  %>% ungroup()%>% 
  filter(condition=="No_prime")%>% select(mean_rt) %>% as.matrix() %>%  shapiro.test()

data_prime_zstandard %>% filter(group=="对照组") %>% group_by(condition,sub_id) %>%
  summarise(mean_rt = mean(stimu.RT))  %>% ungroup()%>% 
  filter(condition=="No_prime")%>% select(mean_rt) %>% as.matrix() %>%  shapiro.test()


data_prime_zstandard %>% filter(group=="口吃组") -> stutter
stutter[stutter=="Prime"]=1
stutter[stutter=="No_prime"]=0
library(lmerTest)
cor_model <- lmerTest::lmer(SSI_3~stimu.RT+condition+(1|sub_id),data = stutter,control = lmerControl(optCtrl = list(maxfun = 20000)))




data_inter_zstandard <- data.frame(condition=0,stimu.ACC=0,stimu.RT=0,item=0,word=0,sub_id=0,group=0,age=0,education=0,SSI_3=0,OASES=0)
for(m in c(1:33)){
  sub_id1 = paste("sub",as.character(m),sep = "_")
  data_interefrence %>% filter(stimu.ACC==1 & condition=="interference" & sub_id==sub_id1) %>% 
    filter(stimu.RT<mean(stimu.RT)+3*sd(stimu.RT)|stimu.RT>mean(stimu.RT)-3*sd(stimu.RT)) -> data_tmp1
  data_interefrence %>% filter(stimu.ACC==1 & condition=="No_interference" & sub_id==sub_id1) %>% 
    filter(stimu.RT<mean(stimu.RT)+3*sd(stimu.RT)|stimu.RT>mean(stimu.RT)-3*sd(stimu.RT)) -> data_tmp2
  
  data_inter_zstandard <- rbind(data_inter_zstandard,data_tmp1) %>% rbind(data_tmp2)
}
data_inter_zstandard <- filter(data_inter_zstandard,condition != 0)
data_inter_zstandard$stimu.RT <- log10(data_inter_zstandard$stimu.RT)
data_inter_zstandard %>% filter(group=="口吃组") %>% group_by(condition,sub_id) %>%
  summarise(mean_rt = mean(stimu.RT))  %>% ungroup()%>% 
  filter(condition=="interference")%>% select(mean_rt) %>% as.matrix() %>%  shapiro.test()

data_inter_zstandard %>% filter(group=="对照组") %>% group_by(condition,sub_id) %>%
  summarise(mean_rt = mean(stimu.RT))  %>% ungroup()%>% 
  filter(condition=="interference")%>% select(mean_rt) %>% as.matrix() %>%  shapiro.test()

data_inter_zstandard %>% filter(group=="口吃组") %>% group_by(condition,sub_id) %>%
  summarise(mean_rt = mean(stimu.RT))  %>% ungroup()%>% 
  filter(condition=="No_interference")%>% select(mean_rt) %>% as.matrix() %>%  shapiro.test()

data_inter_zstandard %>% filter(group=="对照组") %>% group_by(condition,sub_id) %>%
  summarise(mean_rt = mean(stimu.RT))  %>% ungroup()%>% 
  filter(condition=="No_interference")%>% select(mean_rt) %>% as.matrix() %>%  shapiro.test()

data_p_huizong <-data_prime_zstandard %>% group_by(condition,sub_id,group) %>%
  summarise(mean_rt = mean(stimu.RT))  %>% ungroup() %>% as.data.frame()

  glm(data=data_p_huizong,mean_rt~condition*group,family = "gaussian")%>% 
  bruceR::GLM_summary(robust = TRUE,cluster = "sub_id")


  data_inter_huizong <-data_inter_zstandard %>% group_by(condition,sub_id,group) %>%
    summarise(mean_rt = mean(stimu.RT))  %>% ungroup() %>% as.data.frame()
  
  glm(data=data_inter_huizong,mean_rt~condition*group,family = "gaussian")%>% 
    bruceR::GLM_summary(robust = TRUE,cluster = "sub_id") -> modle




sdt_error_model<-  glm(data=data_inter_huizong,mean_rt~condition*group,family = "gaussian")%>% clusterSEs::cluster.bs.glm(dat = data_inter_huizong, ~ sub_id, prog.bar = FALSE)

bruceR::GLM_summary(data_p_model)

data_interefrence %>% filter(stimu.ACC==1) ->cor_data_inter
 











data_prime <- export(data_prime,"data_prime.xlsx")
data_interefrence <- export(data_interefrence,"interefrence.xlsx")
  #导出手动添加了group变量，删除了data_prime中18号被试即口吃组10号被试的数据，因为正确率太低
data_prime <- import("data_prime.xlsx")
data_interefrence <- import("interefrence.xlsx")  
factor(data_prime$PrimeC,ordered = FALSE)
factor(data_prime$group,ordered = FALSE)

data_interefrence %>% filter(stimu.ACC==1)  %>% filter(group=='stutter') -> tmp
name <- levels(factor(tmp$sub_id))
##绘图每个被试的正确率和反应时的整体情况图
tmp_file <- list()
for(number in c(1:16)){
  tmp %>% filter(sub_id==name[number]) -> tmp_file[[number]]
  tmp_file[[number]] %>% mutate(item=c(1:nrow(tmp_file[[number]]))) -> tmp_file[[number]]
}

stutter <- rbind(tmp_file[[1]],tmp_file[[2]]) %>% rbind(tmp_file[[3]])%>% rbind(tmp_file[[4]]) %>% 
  rbind(tmp_file[[5]])%>% 
  rbind(tmp_file[[6]])%>% 
  rbind(tmp_file[[7]])%>% 
  rbind(tmp_file[[8]])%>%
  rbind(tmp_file[[9]])%>%
  rbind(tmp_file[[10]])%>% 
  rbind(tmp_file[[11]])%>% 
  rbind(tmp_file[[12]])%>% 
  rbind(tmp_file[[13]])%>% 
  rbind(tmp_file[[14]])%>% 
  rbind(tmp_file[[15]])%>% 
  rbind(tmp_file[[16]])

stutter %>% ggplot(aes(x=item,y=stimu.RT,color=PrimeC))+geom_line(aes(group=PrimeC))+facet_wrap(~sub_id)

data_interefrence  %>% filter(stimu.ACC==1)  %>% filter(group=='control') -> tmp1
name1 <- levels(factor(tmp1$sub_id))
tmp_file1 <- list()
for(number1 in c(1:17)){
  tmp1 %>% filter(sub_id==name1[number1]) -> tmp_file1[[number1]]
  tmp_file1[[number1]] %>% mutate(item=c(1:nrow(tmp_file1[[number1]]))) -> tmp_file1[[number1]]
}

control <- rbind(tmp_file1[[1]],tmp_file1[[2]]) %>% rbind(tmp_file1[[3]])%>% rbind(tmp_file1[[4]]) %>% 
  rbind(tmp_file1[[5]])%>% 
  rbind(tmp_file1[[6]])%>% 
  rbind(tmp_file1[[7]])%>% 
  rbind(tmp_file1[[8]])%>%
  rbind(tmp_file1[[9]])%>%
  rbind(tmp_file1[[10]])%>% 
  rbind(tmp_file1[[11]])%>% 
  rbind(tmp_file1[[12]])%>% 
  rbind(tmp_file1[[13]])%>% 
  rbind(tmp_file1[[14]])%>% 
  rbind(tmp_file1[[15]])%>% 
  rbind(tmp_file1[[16]])%>% 
  rbind(tmp_file1[[17]])
control %>% ggplot(aes(x=item,y=stimu.RT,color=PrimeC))+geom_line(aes(group=PrimeC))+facet_wrap(~sub_id)



##正确率混合逻辑模型分析

data_model1 <- glmer( stimu.ACC ~ PrimeC*group + (1 + PrimeC| sub_id) + (1 + PrimeC*group| Block), 
                      data = data_interefrence, family = binomial, control = glmerControl(optimizer = "bobyqa"))
isSingular(data_model1)
summary(data_model1)
data_model2 <- glmer( stimu.ACC ~ PrimeC*group + (1 + PrimeC| sub_id) + (1 + PrimeC+group| Block), 
                      data = data_interefrence, family = binomial, control = glmerControl(optimizer = "bobyqa"))
isSingular(data_model2)
summary(data_model2)
data_model3 <- glmer( stimu.ACC ~ PrimeC*group + (1 + PrimeC| sub_id) + (1 + PrimeC| Block), 
                      data = data_interefrence, family = binomial, control = glmerControl(optimizer = "bobyqa"))
isSingular(data_model3)
summary(data_model2)
data_model4 <- glmer( stimu.ACC ~ PrimeC*group + (1 | sub_id) + (1| Block), 
                      data = data_interefrence, family = binomial, control = glmerControl(optimizer = "bobyqa"))
isSingular(data_model4)
anova(data_model1,data_model2,data_model3,data_model4)
bruceR::HLM_summary(data_model3)




















library(bruceR)
library(tidyverse)
library(sjPlot)  # for plotting
library(sjmisc)
setwd("G:/data/xingwiexue/")
data <- rio::import("roi.xlsx")

data[data=="interference"] = "干扰条件"
data[data=="no_interference"] = "非干扰条件"
data[data=="S"] = "口吃组"
data[data=="NS"] = "对照组"
data %>% group_by(group,condition)  %>% summarise(mean_RT = mean(RT))
data %>% group_by(group,condition)  %>% summarise(mean_ROI = mean(inter_roi1))

data_new <- filter(data,condition=="干扰条件")
model_real <- lm(RT~inter_roi1*group,data)

GLM_summary(model_real)
set_theme(
  geom.outline.color = "antiquewhite4", 
  geom.outline.size = 1, 
  geom.label.size = 2,
  geom.label.color = "grey50",
  title.color = "red", 
  title.size = 1.5, 
  axis.angle.x = 0, 
  axis.textcolor = "blue", 
  base = theme_bruce()
)
plot_model(model_real, type = "int", terms = c('inter_roi1', 'group'))

ssi_1_model <- lm(severe~inter_roi1+roi2+roi3+roi4+foi5+roi6,data_new)
ssi_2_model <- lm(severe~roi2+roi3+roi4+foi5+roi6,data_new)
ssi_3_model <- lm(severe~roi3+roi4+foi5+roi6,data_new)
anova(ssi_1_model,ssi_2_model,ssi_3_model)
summary(ssi_3_model)


data %>% ggplot(aes(x=group,y=roi2,fill=condition))+stat_summary(fun = mean,geom = "bar",position = position_dodge(1))+
  stat_summary(fun.data = mean_se,geom="errorbar",position = position_dodge(1),width=0.2)+theme_bruce()+
  scale_fill_manual(values=c("#f6941d","#af0065"))















setwd("G:/data/xingwiexue/0033/")


data_prime_new <- filter(data_prime,data_prime$stimu.ACC==1)
library(lme4)
 data_model <- glmer(stimu.ACC~ PrimeC*group + (1 | sub_id) + (1 | item), data = data_prime, family = binomial, control = glmerControl(optimizer = "bobyqa"))
 summary(data_model)
 data_model11 <- glmer(stimu.ACC~ PrimeC*group + (1 | sub_id) + (1 | Block), data = data_interefrence, family = binomial, control = glmerControl(optimizer = "bobyqa"))
 summary(data_model11)
 library(afex)
 data_model2 <- mixed(stimu.RT~ PrimeC*group + (1|sub_id), data = data_prime_new)
 summary(data_model2)
 data_model3 <- mixed(stimu.RT~ PrimeC*group + (1|sub_id) +(1|sub_id:PrimeC), data = data_interefrence)
 summary(data_model3)
 data_interefrence_new <- filter(data_interefrence,data_interefrence$stimu.ACC==1)
 data_model4 <- mixed(stimu.RT~ PrimeC*group + (1|sub_id) +(1|Block), data = data_interefrence)
 summary(data_model4) 
 
 
 
 data_interefrence$group <- factor(data_interefrence$group)
 data_model11 <- glmer(group ~ stimu.ACC + stimu.RT + (1 | sub_id) + (1 | Block), data = data_interefrence, family = binomial, control = glmerControl(optimizer = "bobyqa"))
 summary(data_model11)
 
 
 data_RT <- import("data_RT.xlsx")
 data_ACC <- import("data_ACC.xlsx")
 data_cor <- import("xiangguan.xlsx")
 data_crt <- import("xiangg_rt.xlsx")
 
 data_cor_new <- filter(data_cor,data_cor$group=="S")
 data_rt_new <- filter(data_crt,data_crt$group=="S")
 data_cor_new %>% select("A","B","C","D","stutter")%>% PerformanceAnalytics::chart.Correlation()
 data_rt_new  %>% select("A","B","C","D","stutter")%>% PerformanceAnalytics::chart.Correlation()
 cor.test(data_cor_new$C,data_cor_new$stutter)
 cor.test(data_cor_new$D,data_cor_new$stutter)
 cor.test(data_rt_new$C,data_rt_new$stutter)
 
 data_all <- cbind(data_ACC,data_RT)
 Hmisc::rcorr(data_all)
 
 
 