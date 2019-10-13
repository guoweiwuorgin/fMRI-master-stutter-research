clear
% '0001';'0002';'0003';'0004';'0005';'0006';'0007';'0008';'0009';'0010';'0011';'0012';'0013';'0014';'0015'
% 被试的文件夹名
number = ['0019';]
for p = 1:size(number,1)
   q = number(p,:);
   data_path = 'G:\data\xingweixuejieguo\'
   real_path = [data_path,q,'\'];
   cd(real_path)
[a,b,c] = xlsread('run1.txt');
% 读入行为学数据
[d,e,f] = xlsread('run2.txt');
for i = 1:size(c,1)
  m{i,1} = c{i,8};
%   dummyscanonset
  m{i,2} = c{i,26};
%   condition
  m{i,3} = c{i,37};
%   fixonset
  m{i,4} = c{i,70};
%   pictureonset
  m{i,5} = c{i,84};
%   stimuACC
  m{i,6} = c{i,91};
%   stimuonset
  m{i,7} = c{i,94};
%   stimuRT
  m{i,8} = c{i,31};
  m{i,9} = c{i,46};
  m{i,10} = c{i,58};
  m{i,11} = c{i,82};
  m{i,12} = c{i,108};
  if strcmp(m{i,2},'A');
    run1_ACC(i,1) = m{i,5};
     if eq(m{i,5},1);
    run1A_data(i,1) = (m{i,3}-m{i,1})/1000;
%     fixonset
    run1A_data(i,2) = (m{i,4}-m{i,1})/1000;
%     piconset
    run1A_data(i,3)= (m{i,6}-m{i,1})/1000;
%     stionset
    run1A_data(i,4) = m{i,7};
%     RT
     end;
 elseif strcmp(m{i,2},'B');
     run1_ACC(i,2) = m{i,5};
        if eq(m{i,5},1);
     run1B_data(i,1) = (m{i,3}-m{i,1})/1000;
%     fixonset
    run1B_data(i,2) = (m{i,4}-m{i,1})/1000;
%     piconset
    run1B_data(i,3)= (m{i,6}-m{i,1})/1000;
%     stionset
    run1B_data(i,4) = m{i,7};
        end;
    elseif strcmp(m{i,2},'C');
        run1_ACC(i,3) = m{i,5};
        if eq(m{i,5},1) ;
    run1C_data(i,1) = (m{i,3}-m{i,1})/1000;
%     fixonset
    run1C_data(i,2) = (m{i,4}-m{i,1})/1000;
%     piconset
    run1C_data(i,3)= (m{i,6}-m{i,1})/1000;
%     stionset
    run1C_data(i,4) = m{i,7};
        end;
    elseif strcmp(m{i,2},'D');
        run1_ACC(i,4) = m{i,5};
         if eq(m{i,5},1);
    run1D_data(i,1) = (m{i,3}-m{i,1})/1000;
%     fixonset
    run1D_data(i,2) = (m{i,4}-m{i,1})/1000;
%     piconset
    run1D_data(i,3)= (m{i,6}-m{i,1})/1000;
%     stionset
    run1D_data(i,4) = m{i,7};
         end;
end
end
for r = 1:size(f,1)
  n{r,1} = f{r,10};
%   dummyscanonset
  n{r,2} = f{r,29};
%   condition
  n{r,3} = f{r,37};
%   fixonset
  n{r,4} = f{r,63};
%   pictureonset
  n{r,5} = f{r,72};
%   stimuACC
  n{r,6} = f{r,80};
%   stimuonset
  n{r,7} = f{r,83};
%   stimuRT
  n{r,8} = f{r,33};
  n{r,9} = f{r,42};
  n{r,10} = f{r,53};
  n{r,11} = f{r,71};
  n{r,12} = f{r,97};
%   instruction
if strcmp(n{r,2},'A');
    run2_ACC(r,1) = n{r,5};
     if eq(n{r,5},1);
    run2A_data(r,1) = (n{r,3}-n{r,1})/1000;
%     fixonset
    run2A_data(r,2) = (n{r,4}-n{r,1})/1000;
%     piconset
    run2A_data(r,3) = (n{r,6}-n{r,1})/1000;
%     stimuonset
    run2A_data(r,4) = n{r,7};
%     stimRT
     end;
 elseif strcmp(n{r,2},'B');
     run2_ACC(r,2) = n{r,5};
        if eq(n{r,5},1);
    run2B_data(r,1) = (n{r,3}-n{r,1})/1000;
%     fixonset
    run2B_data(r,2) = (n{r,4}-n{r,1})/1000;
%     piconset
    run2B_data(r,3) = (n{r,6}-n{r,1})/1000;
%     stimuonset
    run2B_data(r,4) = n{r,7};
%     stimRT
        end;
 elseif strcmp(n{r,2},'C');
        run2_ACC(r,3) = n{r,5};
        if eq(n{r,5},1) ;
    run2C_data(r,1) = (n{r,3}-n{r,1})/1000;
%     fixonset
    run2C_data(r,2) = (n{r,4}-n{r,1})/1000;
%     piconset
    run2C_data(r,3) = (n{r,6}-n{r,1})/1000;
%     stimuonset
    run2C_data(r,4) = n{r,7};
%     stimRT
        end;
elseif strcmp(n{r,2},'D');
        run2_ACC(r,4) = n{r,5};
         if eq(n{r,5},1);
    run2D_data(r,1) = (n{r,3}-n{r,1})/1000;
%     fixonset
    run2D_data(r,2) = (n{r,4}-n{r,1})/1000;
%     piconset
    run2D_data(r,3) = (n{r,6}-n{r,1})/1000;
%     stimuonset
    run2D_data(r,4) = n{r,7};
%     stimRT
         end;
end
end

runA_data = [run1A_data;run2A_data];
runB_data = [run1B_data;run2B_data];
runC_data = [run1C_data;run2C_data];
runD_data = [run1D_data;run2D_data];
%%
A_RT = runA_data(:,4);
A_RT(A_RT==0)=[];
A_RT_ave = mean(A_RT);
A_RT_std = std(A_RT);
numA = find(A_RT>(A_RT_ave+3*A_RT_std)| A_RT<(A_RT_ave-3*A_RT_std));
Aoutdata=A_RT(numA,1);
Aoutdataindex=numA;
% 导出A条件的异常值坐标
B_RT = runB_data(:,4);
B_RT(B_RT==0)=[];
B_RT_ave = mean(B_RT);
B_RT_std = std(B_RT);
numB = find(B_RT>(B_RT_ave+3*B_RT_std)| B_RT<(B_RT_ave-3*B_RT_std));
Boutdata=B_RT(numB,1);
Boutdataindex=numB;
% 导出B条件的异常值坐标
C_RT = runC_data(:,4);
C_RT(C_RT==0)=[];
C_RT_ave = mean(C_RT);
C_RT_std = std(C_RT);
numC = find(C_RT>(C_RT_ave+3*C_RT_std)| C_RT<(C_RT_ave-3*C_RT_std));
Coutdata=C_RT(numC,1);
Coutdataindex = numC;
% 导出C条件的异常值坐标
D_RT = runD_data(:,4);
D_RT(D_RT==0)=[];
D_RT_ave = mean(D_RT);
D_RT_std = std(D_RT);
numD = find(D_RT>(D_RT_ave+3*D_RT_std)| D_RT<(D_RT_ave-3*D_RT_std));
Doutdata=D_RT(numD,1);
Doutdataindex = numD;
% 导出D条件的异常值坐标
%%
% 清除总数据里的异常值，然后求出不同任务下的RT平均值，再分别清除run1和run2异常值对应的数据
if min(Aoutdata,1)>0
     runA_data(Aoutdataindex,:)=[];
for number1 = 1:length(Aoutdataindex)
    index1 = Aoutdataindex(number1,1);
    if index1 <= size(run1A_data,1)
     run1A_data(index1,:)=[];
    else
     run2A_data(index1-size(run1A_data,1),:)=[];
    end
end  
end

% 清除异常值
if min(Boutdata,1)>0
     runB_data(Boutdataindex,:)=[];
for number2 = 1:length(Boutdataindex);
    index2 = Boutdataindex(number2,1);
    if index2 <= size(run1B_data,1)
     run1B_data(index2,:)=[];
    else
     run2B_data(index2-size(run1B_data,1),:)=[];
    end
end  
end
% 清除异常值
if min(Coutdata,1)>0
    runC_data(Coutdataindex,:)=[];
for number3 = 1:length(Coutdataindex);
    index3 = Coutdataindex(number3,1);
    if index3 <=size(run1C_data,1)
     run1C_data(index3,:)=[];
    else
     run2C_data(index3-size(run1C_data,1),:)=[];
    end
end  
end

% 清除异常值
if min(Doutdata,1)>0
    runD_data(Doutdataindex,:)=[];
for number4 = 1:length(Doutdataindex);
    index4 = Doutdataindex(number4,1);
    if index4 <= size(run1D_data,1)
     run1D_data(index4,:)=[];
    else
     run2D_data(index4-size(run1D_data,1),:)=[];
    end
end  
end
% 清除异常值
%%
% 计算不同任务总有效刺激的平均值和标准差
A_RT = runA_data(:,4);
A_RT(A_RT==0)=[];
A_RT_ave = mean(A_RT);
A_RT_std = std(A_RT);
B_RT = runB_data(:,4);
B_RT(B_RT==0)=[];
B_RT_ave = mean(B_RT);
B_RT_std = std(B_RT);
C_RT = runC_data(:,4);
C_RT(C_RT==0)=[];
C_RT_ave = mean(C_RT);
C_RT_std = std(C_RT);
D_RT = runD_data(:,4);
D_RT(D_RT==0)=[];
D_RT_ave = mean(D_RT);
D_RT_std = std(D_RT);
A_zong_RT_ave(p,1)=A_RT_ave;
B_zong_RT_ave(p,1)=B_RT_ave;
C_zong_RT_ave(p,1)=C_RT_ave;
D_zong_RT_ave(p,1)=D_RT_ave;
%%
% 每一个run不同刺激的onset时间和反应刺激的RT长度
run1conA_fixonset = run1A_data(:,1);
run1conB_fixonset = run1B_data(:,1);
run1conC_fixonset = run1C_data(:,1);
run1conD_fixonset = run1D_data(:,1);
run1conA_pic_onset_data = run1A_data(:,2);
run1conB_pic_onset_data = run1B_data(:,2);
run1conC_pic_onset_data = run1C_data(:,2);
run1conD_pic_onset_data = run1D_data(:,2);
run1conA_sti_onset_data = run1A_data(:,3);
run1conB_sti_onset_data = run1B_data(:,3);
run1conC_sti_onset_data = run1C_data(:,3);
run1conD_sti_onset_data = run1D_data(:,3);
run1conA_RT_data = run1A_data(:,4);
run1conB_RT_data= run1B_data(:,4);
run1conC_RT_data = run1C_data(:,4);
run1conD_RT_data= run1D_data(:,4);
run2conA_fixonset = run2A_data(:,1);
run2conB_fixonset = run2B_data(:,1);
run2conC_fixonset = run2C_data(:,1);
run2conD_fixonset = run2D_data(:,1);
run2conA_pic_onset_data = run2A_data(:,2);
run2conB_pic_onset_data = run2B_data(:,2);
run2conC_pic_onset_data = run2C_data(:,2);
run2conD_pic_onset_data = run2D_data(:,2);
run2conA_sti_onset_data = run2A_data(:,3);
run2conB_sti_onset_data = run2B_data(:,3);
run2conC_sti_onset_data = run2C_data(:,3);
run2conD_sti_onset_data = run2D_data(:,3);
run2conA_RT_data = run2A_data(:,4);
run2conB_RT_data= run2B_data(:,4);
run2conC_RT_data = run2C_data(:,4);
run2conD_RT_data= run2D_data(:,4);
%%
% 清除空位数据
run1conA_fixonset(run1conA_fixonset==0) = [];
run1conB_fixonset(run1conB_fixonset==0) = [];
run1conC_fixonset(run1conC_fixonset==0) = [];
run1conD_fixonset(run1conD_fixonset==0) = [];
run1conA_pic_onset_data(run1conA_pic_onset_data==0) = [];
run1conB_pic_onset_data(run1conB_pic_onset_data==0) = [];
run1conC_pic_onset_data(run1conC_pic_onset_data==0) = [];
run1conD_pic_onset_data(run1conD_pic_onset_data==0) = [];
run1conA_sti_onset_data(run1conA_sti_onset_data==0) = [];
run1conB_sti_onset_data(run1conB_sti_onset_data==0) = [];
run1conC_sti_onset_data(run1conC_sti_onset_data==0) = [];
run1conD_sti_onset_data(run1conD_sti_onset_data==0) = [];
run1conA_RT_data(run1conA_RT_data==0) = [];
run1conB_RT_data(run1conB_RT_data==0) = [];
run1conC_RT_data(run1conC_RT_data==0) = [];
run1conD_RT_data(run1conD_RT_data==0) = [];
run2conA_fixonset(run2conA_fixonset==0) = [];
run2conB_fixonset(run2conB_fixonset==0) = [];
run2conC_fixonset(run2conC_fixonset==0) = [];
run2conD_fixonset(run2conD_fixonset==0) = [];
run2conA_pic_onset_data(run2conA_pic_onset_data==0) = [];
run2conB_pic_onset_data(run2conB_pic_onset_data==0) = [];
run2conC_pic_onset_data(run2conC_pic_onset_data==0) = [];
run2conD_pic_onset_data(run2conD_pic_onset_data==0) = [];
run2conA_sti_onset_data(run2conA_sti_onset_data==0) = [];
run2conB_sti_onset_data(run2conB_sti_onset_data==0) = [];
run2conC_sti_onset_data(run2conC_sti_onset_data==0) = [];
run2conD_sti_onset_data(run2conD_sti_onset_data==0) = [];
run2conA_RT_data(run2conA_RT_data==0) = [];
run2conB_RT_data(run2conB_RT_data==0) = [];
run2conC_RT_data(run2conC_RT_data==0) = [];
run2conD_RT_data(run2conD_RT_data==0) = [];
%%
% 保存结果
xlswrite('run1fixonset_A',run1conA_fixonset);
xlswrite('run1fixonset_B',run1conB_fixonset);
xlswrite('run1fixonset_C',run1conC_fixonset);
xlswrite('run1fixonset_D',run1conD_fixonset);
xlswrite('run1piconset_A',run1conA_pic_onset_data);
xlswrite('run1piconset_B',run1conB_pic_onset_data);
xlswrite('run1piconset_C',run1conC_pic_onset_data);
xlswrite('run1piconset_D',run1conD_pic_onset_data);
xlswrite('run1stionset_A',run1conA_sti_onset_data);
xlswrite('run1stionset_B',run1conB_sti_onset_data);
xlswrite('run1stionset_C',run1conC_sti_onset_data);
xlswrite('run1stionset_D',run1conD_sti_onset_data);
xlswrite('run1RT_A',run1conA_RT_data);
xlswrite('run1RT_B',run1conB_RT_data);
xlswrite('run1RT_C',run1conC_RT_data);
xlswrite('run1RT_D',run1conD_RT_data);
xlswrite('run2fixonset_A',run2conA_fixonset);
xlswrite('run2fixonset_B',run2conB_fixonset);
xlswrite('run2fixonset_C',run2conC_fixonset);
xlswrite('run2fixonset_D',run2conD_fixonset);
xlswrite('run2piconset_A',run2conA_pic_onset_data);
xlswrite('run2piconset_B',run2conB_pic_onset_data);
xlswrite('run2piconset_C',run2conC_pic_onset_data);
xlswrite('run2piconset_D',run2conD_pic_onset_data);
xlswrite('run2stionset_A',run2conA_sti_onset_data);
xlswrite('run2stionset_B',run2conB_sti_onset_data);
xlswrite('run2stionset_C',run2conC_sti_onset_data);
xlswrite('run2stionset_D',run2conD_sti_onset_data);
xlswrite('run2RT_A',run2conA_RT_data);
xlswrite('run2RT_B',run2conB_RT_data);
xlswrite('run2RT_C',run2conC_RT_data);
xlswrite('run2RT_D',run2conD_RT_data);
%%
disp([q,' have processed'])
clear run1conA_fixonset run1conB_fixonset run1conC_fixonset run1conD_fixonset run1conA_pic_onset_data run1conB_pic_onset_data run1conC_pic_onset_data run1conD_pic_onset_data run1conA_sti_onset_data run1conB_sti_onset_data...
run1conC_sti_onset_data...
run1conD_sti_onset_data...
run1conA_RT_data...
run1conB_RT_data...
run1conC_RT_data...
run1conD_RT_data...
run1conA_ACC_data...
run1conB_ACC_data...
run1conC_ACC_data...
run1conD_ACC_data...
run2conA_fixonset run2conB_fixonset run2conC_fixonset run2conD_fixonset run2conA_pic_onset_data run2conB_pic_onset_data run2conC_pic_onset_data run2conD_pic_onset_data run2conA_sti_onset_data run2conB_sti_onset_data...
run2conC_sti_onset_data...
run2conD_sti_onset_data...
run2conA_RT_data...
run2conB_RT_data...
run2conC_RT_data...
run2conD_RT_data...
run2conA_ACC_data...
run2conB_ACC_data...
run2conC_ACC_data...
run2conD_ACC_data...
index1 index2 index3 index4 m n a b c d e f number1 number2 number3 number4 r i Aoutdataindex Boutdataindex Coutdataindex Doutdataindex Aoutdata Boutdata Coutdata Doutdata...
runA_data runB_data runC_data runD_data run1A_data run1B_data run1C_data run1D_data run2A_data run2B_data run2C_data run2D_data run1_ACC run2_ACC A_RT B_RT C_RT D_RT
end
xlswrite('A_zong_RT_ave',A_zong_RT_ave)
xlswrite('B_zong_RT_ave',B_zong_RT_ave)
xlswrite('C_zong_RT_ave',C_zong_RT_ave)
xlswrite('D_zong_RT_ave',D_zong_RT_ave)