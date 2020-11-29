[y,Fs] = audioread('mic_new-1605528495.408.wav');
wlen=200; inc=80;          % 给出帧长和帧移
win=hanning(wlen);         % 给出海宁窗
N=length(y);               % 信号长度
X=enframe(y,win,inc)';     % 分帧
fn=size(X,2);              % 求出帧数
time=(0:N-1)/Fs;           % 计算出信号的时间刻度
for i=1 : fn
    u=X(:,i);              % 取出一帧
    u2=u.*u;               % 求出能量
    En(i)=sum(u2);         % 对一帧累加求和
end
frameTime=frame2time(fn,wlen,inc,Fs);
stamp_i = find(En>0.0009);
trail_1 = frameTime(stamp_i(1));


