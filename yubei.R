rm(list = ls())
path <- 'G:/data/xingwiexue/'
#设置所有行为学数据存放路径
file_list <- matrix(c(1:34),nrow=34,ncol = 1)
groups_var <-c("对照组","口吃组",rep("对照组",7),rep("口吃组",11),rep("对照组",7),rep("口吃组",4),rep("对照组",2),rep("口吃组",1))
#设置被试数量
file_name_list <- matrix(c(1:length(file_list)),nrow = length(file_list),ncol = 1)
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
#分别进入被试文件夹，进行数据清洗并保存清洗好的数据
data_ACC <- data.frame(prime=rep(0,time=length(file_name_list)),No_prime=rep(0,time=length(file_name_list)),No_interference=rep(0,time=length(file_name_list)),interference=rep(0,time=length(file_name_list)),
                       group=rep(0,time=length(file_name_list)))
data_RT <- data.frame(prime=rep(0,time=length(file_name_list)),No_prime=rep(0,time=length(file_name_list)),No_interference=rep(0,time=length(file_name_list)),interference=rep(0,time=length(file_name_list)),
                       group=rep(0,time=length(file_name_list)))
for(n in 1: length(file_name_list)){
  file_name <- file_name_list[n,1]
setwd(paste(path,file_name,sep = ''))
  #导入数据
print(getwd())
data1 <- import("run1.xls")
data2 <- import("run2.xls")
#筛选需要的变量
data1new <- select(data1,dummscan.OffsetTime,condition,fushiB.OnsetTime,dongwuB1.OnsetTime,
                   fix.OnsetTime,jiatingyongpB1.OnsetTime,pictures.OnsetTime,
                   stimu.OnsetTime,stimu.ACC,stimu.RT,shuiguoB1.OnsetTime,wenjuB1.OnsetTime)

  
data2new <- select(data2,dummscan.OffsetTime,condition,fushiB.OnsetTime,dongwuB1.OnsetTime,
                   fix.OnsetTime,jiatingyongpB1.OnsetTime,pictures.OnsetTime,
                   stimu.OnsetTime,stimu.ACC,stimu.RT,shuiguoB1.OnsetTime,wenjuB1.OnsetTime)
#对两个run的数据进行合并并分类
data_A <- rbind(data1new,data2new)%>%select(dummscan.OffsetTime,condition,fix.OnsetTime,pictures.OnsetTime,stimu.OnsetTime,
                                              stimu.ACC,stimu.RT)%>%filter_all(all_vars(!is.na(.)))%>%filter(condition=="A")%>%mutate(group=rep(groups_var[n],50))
data_B <- rbind(data1new,data2new)%>%select(dummscan.OffsetTime,condition,fix.OnsetTime,pictures.OnsetTime,stimu.OnsetTime,
                                            stimu.ACC,stimu.RT)%>%filter_all(all_vars(!is.na(.)))%>%filter(condition=="B")%>%mutate(group=rep(groups_var[n],50))
data_C <- rbind(data1new,data2new)%>%select(dummscan.OffsetTime,condition,fix.OnsetTime,pictures.OnsetTime,stimu.OnsetTime,
                                            stimu.ACC,stimu.RT)%>%filter_all(all_vars(!is.na(.)))%>%filter(condition=="C")%>%mutate(group=rep(groups_var[n],50))
data_D <- rbind(data1new,data2new)%>%select(dummscan.OffsetTime,condition,fix.OnsetTime,pictures.OnsetTime,stimu.OnsetTime,
                                            stimu.ACC,stimu.RT)%>%filter_all(all_vars(!is.na(.)))%>%filter(condition=="D")%>%mutate(group=rep(groups_var[n],50))

data_all <- rbind(data_A,data_B,data_C,data_D)
rio::export(data_all,"data_all.xlsx")
#计算正确率
data_A_ACC <- mean(data_A$stimu.ACC)
data_B_ACC <- mean(data_B$stimu.ACC)
data_C_ACC <- mean(data_C$stimu.ACC)
data_D_ACC <- mean(data_D$stimu.ACC)

data_ACC$prime[n] <- data_A_ACC 
data_ACC$No_prime[n] <- data_B_ACC 
data_ACC$No_interference[n] <- data_C_ACC 
data_ACC$interference[n] <- data_D_ACC 
data_ACC$group[n] <- groups_var[n]
#剔除异常反应后计算反应时
data_A_R <- select(data_A,stimu.RT,stimu.ACC,group)%>%filter(stimu.ACC == 1)
condition_A <- (rep('A',length(data_A_R[,1])))%>%t()%>%t()
data_A_RT<- filter(data_A_R,stimu.RT<mean(stimu.RT)+2.5*sd(stimu.RT)|stimu.RT>mean(stimu.RT)-2.5*sd(stimu.RT))%>%mutate(conditon = condition_A[,1])
data_A_RT_num <- mean(data_A_RT$stimu.RT)%>%round()
#计算B，data_B_R后面有用
data_B_R <- select(data_B,stimu.RT,stimu.ACC,group)%>%filter(stimu.ACC == 1)
condition_B <- (rep('B',length(data_B_R[,1])))%>%t()%>%t()
data_B_RT<- filter(data_B_R,stimu.RT<mean(stimu.RT)+2.5*sd(stimu.RT)|stimu.RT>mean(stimu.RT)-2.5*sd(stimu.RT))%>%mutate(conditon = condition_B[,1])
data_B_RT_num <- mean(data_B_RT$stimu.RT)%>%round()
#计算C
data_C_R <- select(data_C,stimu.RT,stimu.ACC,group)%>%filter(stimu.ACC == 1)
condition_C <- (rep('C',length(data_C_R[,1])))%>%t()%>%t()
data_C_RT <- filter(data_C_R,stimu.RT<mean(stimu.RT)+2.5*sd(stimu.RT)|stimu.RT>mean(stimu.RT)-2.5*sd(stimu.RT))%>%mutate(conditon = condition_C[,1])
data_C_RT_num <- mean(data_C_RT$stimu.RT)%>%round()
#计算D
data_D_R <- select(data_D,stimu.RT,stimu.ACC,group)%>%filter(stimu.ACC == 1)
condition_D <- (rep('D',length(data_D_R[,1])))%>%t()%>%t()
data_D_RT <- filter(data_D_R,stimu.RT<mean(stimu.RT)+2.5*sd(stimu.RT)|stimu.RT>mean(stimu.RT)-2.5*sd(stimu.RT))%>%mutate(conditon = condition_D[,1])
data_D_RT_num <- mean(data_D_RT$stimu.RT)%>%round()
#保存每个被试的每个trail的RT，用作混合线性模型计算
data_zong_RT <- rbind(data_A_RT,data_B_RT,data_C_RT,data_D_RT)
data_zong_RT <- mutate(data_zong_RT,subj = t(t(rep(file_name,length(data_zong_RT[,1])))))%>%export(paste(file_name,"data_RT.xlsx",sep = '_'))
#保存反应时

data_RT$prime[n] <- data_A_RT_num
data_RT$No_prime[n] <- data_B_RT_num
data_RT$No_interference[n] <- data_C_RT_num
data_RT$interference[n] <- data_D_RT_num
data_RT$group[n] <- groups_var[n]
#计算1A onset
run1_data_A<- select(data1new,dummscan.OffsetTime,condition,fix.OnsetTime,pictures.OnsetTime,stimu.OnsetTime,
                        stimu.ACC,stimu.RT)%>%filter_all(all_vars(!is.na(.)))%>%filter(condition=="A")%>%filter(stimu.ACC == 1)%>%
          filter(stimu.RT<mean(data_A_R$stimu.RT)+2.5*sd(data_A_R$stimu.RT)|stimu.RT>mean(data_A_R$stimu.RT)-2.5*sd(data_A_R$stimu.RT))%>%
          mutate(fix_on = (fix.OnsetTime - dummscan.OffsetTime)/1000)%>%
          mutate(pic_on = (pictures.OnsetTime-dummscan.OffsetTime)/1000)%>%
          mutate(stimu_onset = (stimu.OnsetTime-dummscan.OffsetTime)/1000)%>%select(fix_on,pic_on,stimu_onset)
export(run1_data_A,"run1_data_A.xlsx")
#计算1B onset
run1_data_B<- select(data1new,dummscan.OffsetTime,condition,fix.OnsetTime,pictures.OnsetTime,stimu.OnsetTime,
                     stimu.ACC,stimu.RT)%>%filter_all(all_vars(!is.na(.)))%>%filter(condition=="B")%>%filter(stimu.ACC == 1)%>%
  filter(stimu.RT<mean(data_B_R$stimu.RT)+2.5*sd(data_B_R$stimu.RT)|stimu.RT>mean(data_B_R$stimu.RT)-2.5*sd(data_B_R$stimu.RT))%>%
  mutate(fix_on = (fix.OnsetTime - dummscan.OffsetTime)/1000)%>%
  mutate(pic_on = (pictures.OnsetTime-dummscan.OffsetTime)/1000)%>%
  mutate(stimu_onset = (stimu.OnsetTime-dummscan.OffsetTime)/1000)%>%select(fix_on,pic_on,stimu_onset)
export(run1_data_B,"run1_data_B.xlsx")
#计算1C osnet
run1_data_C<- select(data1new,dummscan.OffsetTime,condition,fix.OnsetTime,pictures.OnsetTime,stimu.OnsetTime,
                     stimu.ACC,stimu.RT)%>%filter_all(all_vars(!is.na(.)))%>%filter(condition=="C")%>%filter(stimu.ACC == 1)%>%
  filter(stimu.RT<mean(data_C_R$stimu.RT)+2.5*sd(data_C_R$stimu.RT)|stimu.RT>mean(data_C_R$stimu.RT)-2.5*sd(data_C_R$stimu.RT))%>%
  mutate(fix_on = (fix.OnsetTime - dummscan.OffsetTime)/1000)%>%
  mutate(pic_on = (pictures.OnsetTime-dummscan.OffsetTime)/1000)%>%
  mutate(stimu_onset = (stimu.OnsetTime-dummscan.OffsetTime)/1000)%>%select(fix_on,pic_on,stimu_onset)
export(run1_data_C,"run1_data_C.xlsx")
#计算1D osnet
run1_data_D<- select(data1new,dummscan.OffsetTime,condition,fix.OnsetTime,pictures.OnsetTime,stimu.OnsetTime,
                     stimu.ACC,stimu.RT)%>%filter_all(all_vars(!is.na(.)))%>%filter(condition=="D")%>%filter(stimu.ACC == 1)%>%
  filter(stimu.RT<mean(data_D_R$stimu.RT)+2.5*sd(data_D_R$stimu.RT)|stimu.RT>mean(data_D_R$stimu.RT)-2.5*sd(data_D_R$stimu.RT))%>%
  mutate(fix_on = (fix.OnsetTime - dummscan.OffsetTime)/1000)%>%
  mutate(pic_on = (pictures.OnsetTime-dummscan.OffsetTime)/1000)%>%
  mutate(stimu_onset = (stimu.OnsetTime-dummscan.OffsetTime)/1000)%>%select(fix_on,pic_on,stimu_onset)
export(run1_data_D,"run1_data_D.xlsx")

run1_data_error <- select(data1new,dummscan.OffsetTime,condition,fix.OnsetTime,pictures.OnsetTime,stimu.OnsetTime,
                          stimu.ACC,stimu.RT)%>%filter_all(all_vars(!is.na(.)))%>%filter(stimu.ACC == 0)%>%
  mutate(fix_on = (fix.OnsetTime - dummscan.OffsetTime)/1000)%>%
  mutate(pic_on = (pictures.OnsetTime-dummscan.OffsetTime)/1000)%>%
  mutate(stimu_onset = (stimu.OnsetTime-dummscan.OffsetTime)/1000)%>%select(fix_on,pic_on,stimu_onset)
export(run1_data_error,"run1_data_error.xlsx")
#计算2A onset
run2_data_A<- select(data2new,dummscan.OffsetTime,condition,fix.OnsetTime,pictures.OnsetTime,stimu.OnsetTime,
                     stimu.ACC,stimu.RT)%>%filter_all(all_vars(!is.na(.)))%>%filter(condition=="A")%>%filter(stimu.ACC == 1)%>%
  filter(stimu.RT<mean(data_A_R$stimu.RT)+2.5*sd(data_A_R$stimu.RT)|stimu.RT>mean(data_A_R$stimu.RT)-2.5*sd(data_A_R$stimu.RT))%>%
  mutate(fix_on = (fix.OnsetTime - dummscan.OffsetTime)/1000)%>%
  mutate(pic_on = (pictures.OnsetTime-dummscan.OffsetTime)/1000)%>%
  mutate(stimu_onset = (stimu.OnsetTime-dummscan.OffsetTime)/1000)%>%select(fix_on,pic_on,stimu_onset)
export(run2_data_A,"run2_data_A.xlsx")
#计算2B onset
run2_data_B<- select(data2new,dummscan.OffsetTime,condition,fix.OnsetTime,pictures.OnsetTime,stimu.OnsetTime,
                     stimu.ACC,stimu.RT)%>%filter_all(all_vars(!is.na(.)))%>%filter(condition=="B")%>%filter(stimu.ACC == 1)%>%
  filter(stimu.RT<mean(data_B_R$stimu.RT)+2.5*sd(data_B_R$stimu.RT)|stimu.RT>mean(data_B_R$stimu.RT)-2.5*sd(data_B_R$stimu.RT))%>%
  mutate(fix_on = (fix.OnsetTime - dummscan.OffsetTime)/1000)%>%
  mutate(pic_on = (pictures.OnsetTime-dummscan.OffsetTime)/1000)%>%
  mutate(stimu_onset = (stimu.OnsetTime-dummscan.OffsetTime)/1000)%>%select(fix_on,pic_on,stimu_onset)
export(run2_data_B,"run2_data_B.xlsx")
#计算2C osnet
run2_data_C<- select(data2new,dummscan.OffsetTime,condition,fix.OnsetTime,pictures.OnsetTime,stimu.OnsetTime,
                     stimu.ACC,stimu.RT)%>%filter_all(all_vars(!is.na(.)))%>%filter(condition=="C")%>%filter(stimu.ACC == 1)%>%
  filter(stimu.RT<mean(data_C_R$stimu.RT)+2.5*sd(data_C_R$stimu.RT)|stimu.RT>mean(data_C_R$stimu.RT)-2.5*sd(data_C_R$stimu.RT))%>%
  mutate(fix_on = (fix.OnsetTime - dummscan.OffsetTime)/1000)%>%
  mutate(pic_on = (pictures.OnsetTime-dummscan.OffsetTime)/1000)%>%
  mutate(stimu_onset = (stimu.OnsetTime-dummscan.OffsetTime)/1000)%>%select(fix_on,pic_on,stimu_onset)
export(run2_data_C,"run2_data_C.xlsx")
#计算2D osnet
run2_data_D<- select(data2new,dummscan.OffsetTime,condition,fix.OnsetTime,pictures.OnsetTime,stimu.OnsetTime,
                     stimu.ACC,stimu.RT)%>%filter_all(all_vars(!is.na(.)))%>%filter(condition=="D")%>%filter(stimu.ACC == 1)%>%
  filter(stimu.RT<mean(data_D_R$stimu.RT)+2.5*sd(data_D_R$stimu.RT)|stimu.RT>mean(data_D_R$stimu.RT)-2.5*sd(data_D_R$stimu.RT))%>%
  mutate(fix_on = (fix.OnsetTime - dummscan.OffsetTime)/1000)%>%
  mutate(pic_on = (pictures.OnsetTime-dummscan.OffsetTime)/1000)%>%
  mutate(stimu_onset = (stimu.OnsetTime-dummscan.OffsetTime)/1000)%>%select(fix_on,pic_on,stimu_onset)
export(run2_data_D,"run2_data_D.xlsx")

run2_data_error <- select(data2new,dummscan.OffsetTime,condition,fix.OnsetTime,pictures.OnsetTime,stimu.OnsetTime,
                          stimu.ACC,stimu.RT)%>%filter_all(all_vars(!is.na(.)))%>%filter(stimu.ACC == 0)%>%
  mutate(fix_on = (fix.OnsetTime - dummscan.OffsetTime)/1000)%>%
  mutate(pic_on = (pictures.OnsetTime-dummscan.OffsetTime)/1000)%>%
  mutate(stimu_onset = (stimu.OnsetTime-dummscan.OffsetTime)/1000)%>%select(fix_on,pic_on,stimu_onset)

export(run2_data_error,"run2_data_error.xlsx")
#计算提示屏的onset
data_tishi_dongwu <- rbind(data1new,data2new)%>%select(dummscan.OffsetTime,dongwuB1.OnsetTime)%>%filter(!is.na(dongwuB1.OnsetTime))%>%
  mutate(dongwu_onset = (dongwuB1.OnsetTime-dummscan.OffsetTime)/1000)

data_tishi_fushi <- rbind(data1new,data2new)%>%select(dummscan.OffsetTime,fushiB.OnsetTime)%>%filter(!is.na(fushiB.OnsetTime))%>%
  mutate(fushi_onset = (fushiB.OnsetTime-dummscan.OffsetTime)/1000)

data_tishi_shuiguo <- rbind(data1new,data2new)%>%select(dummscan.OffsetTime,shuiguoB1.OnsetTime)%>%filter(!is.na(shuiguoB1.OnsetTime))%>%
  mutate(shuiguo_onset = (shuiguoB1.OnsetTime-dummscan.OffsetTime)/1000)

data_tishi_jiatingyongp <- rbind(data1new,data2new)%>%select(dummscan.OffsetTime,jiatingyongpB1.OnsetTime)%>%filter(!is.na(jiatingyongpB1.OnsetTime))%>%
  mutate(jiatingyongp_onset = (jiatingyongpB1.OnsetTime-dummscan.OffsetTime)/1000)


data_tishi_wenju <- rbind(data1new,data2new)%>%select(dummscan.OffsetTime,wenjuB1.OnsetTime)%>%filter(!is.na(wenjuB1.OnsetTime))%>%
  mutate(wenju_onset = (wenjuB1.OnsetTime-dummscan.OffsetTime)/1000)

data_tishi_run1 <- c(data_tishi_dongwu[1:2,3],data_tishi_fushi[1:2,3],data_tishi_shuiguo[1:2,3],
                     data_tishi_jiatingyongp[1:2,3],data_tishi_wenju[1:2,3])
export(data_tishi_run1,"data_tishi_run1.xlsx")
data_tishi_run2 <- c(data_tishi_dongwu[3:4,3],data_tishi_fushi[3:4,3],data_tishi_shuiguo[3:4,3],
                     data_tishi_jiatingyongp[3:4,3],data_tishi_wenju[3:4,3])
export(data_tishi_run2,"data_tishi_run2.xlsx")
rm(data1,data2,data1new,data2new,data_A,data_B,data_C,data_D)
}
export(data_ACC,"data_ACC.xlsx")
export(data_RT,"data_RT.xlsx")




