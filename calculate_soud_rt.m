[y,Fs] = audioread('mic_new-1605528495.408.wav');
wlen=200; inc=80;          % ����֡����֡��
win=hanning(wlen);         % ����������
N=length(y);               % �źų���
X=enframe(y,win,inc)';     % ��֡
fn=size(X,2);              % ���֡��
time=(0:N-1)/Fs;           % ������źŵ�ʱ��̶�
for i=1 : fn
    u=X(:,i);              % ȡ��һ֡
    u2=u.*u;               % �������
    En(i)=sum(u2);         % ��һ֡�ۼ����
end
frameTime=frame2time(fn,wlen,inc,Fs);
stamp_i = find(En>0.0009);
trail_1 = frameTime(stamp_i(1));


