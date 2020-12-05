clc;
% load('M_&_N');
%% 单点epo的ss波标定
% rec = N';
% hyp = M;
% epo = 287;
% Fs = 250;
% LEN = Fs*30;
% win_width = 0.5*Fs;
% SS=[0.5,3,4,7,8,13,12,16,18,30,40,49];
% SK=[1,2,5,6,9,11,13,14,20,27,44,48];
% x =1:win_width:LEN-win_width;
% judge = zeros(20,length(hyp));
% judge_ins = zeros(20,length(x));
% 
% sigma = zeros(length(x),1);
% Sig = rec(1,(epo-1)*LEN+1:epo*LEN);
% 
% tic;
% for i=1:6
%     %%%% build filter
%     Wp = [2*SS(i*2-1)/Fs,2*SS(i*2)/Fs];
%     Ws =  [2*SK(i*2-1)/Fs,2*SK(i*2)/Fs]; 
%     [n,Wn] = buttord(Wp,Ws,1,20);
%     [b,a]=butter(n,Wn);    
%     Result = filter(b,a,Sig);
%     judge(i,epo) = mean(abs(Result));   %%cul the whole 30s epoch judge
%     %%%%%%%%%%%%%%%%%%
%     p = 1;
%     for poi=1:win_width:LEN-win_width 
%         Sig_ins = Sig(poi:poi+win_width);        
%         Result = filter(b,a,Sig_ins);
%         judge_ins(i,p) = mean(abs(Result));   %% cul the instantaneous judge with 2s windows
%         p=p+1;
%     end
% end
% toc;
% 
% cD = judge_ins(4,:)-judge_ins(1,:);
% cT = judge_ins(4,:)-judge_ins(2,:);
% cA = judge_ins(4,:)-judge_ins(3,:);
% cc = find(cD>0&cT>0&cA>0);
% ccy = zeros(1,length(x));
% ccy(cc) = 1;
% 
% figure;
% sub = 4;
% subplot(sub,1,1);
% plot(x,judge_ins(4,:));hold on;
% plot([0,LEN-win_width ],[judge(4,epo),judge(4,epo)],'r-'); hold on;
% subplot(sub,1,2);
% plot(x,judge_ins(1,:),'b');hold on;
% plot(x,judge_ins(2,:),'g');hold on;
% plot(x,judge_ins(3,:),'y');hold on;
% plot(x,judge_ins(4,:),'r');hold on;
% subplot(sub,1,3);
% plot(ccy,'r-');hold on;
% subplot(sub,1,4);
% plot(Sig);hold on;
%% 全部点ss波计数

rec = N';
hyp = M;
epo = 287;
Fs = 250;
LEN = Fs*30;
win_width = 0.5*Fs;
SS=[0.5,3,4,7,8,13,12,16,18,30,40,49];
SK=[1,2,5,6,9,11,13,14,20,27,44,48];
x =1:win_width:LEN-win_width;%% sweep windows
judge = zeros(20,length(hyp));%% all epoch in whole night
judge_ins = zeros(20,length(x),length(hyp));

tic;
for i=1:6 %% 6 kinds of filters
    
    %%%% build filter
    Wp = [2*SS(i*2-1)/Fs,2*SS(i*2)/Fs];
    Ws =  [2*SK(i*2-1)/Fs,2*SK(i*2)/Fs]; 
    [n,Wn] = buttord(Wp,Ws,1,20);
    [b,a]=butter(n,Wn);
    %%%%%%%%%%%%%%%%%%
    
    for epo = 1:length(hyp)-1
        Sig = rec(1,(epo-1)*LEN+1:epo*LEN);   %% signal of this epoch
        Result = filter(b,a,Sig);
        judge(i,epo) = mean(abs(Result));   %%cul the whole 30s epoch judge
        %%%%%%%%%  sweep with 0.5s windows     
        p=1;       
        for poi=1:win_width:LEN-win_width 
            Sig_ins = Sig(poi:poi+win_width);        
            Result = filter(b,a,Sig_ins);
            judge_ins(i,p,epo) = mean(abs(Result));   %% cul the instantaneous judge with 0.5s windows
            p=p+1;
        end
    end
end
toc;

tic;
ss_num_all_epoch = zeros(1,length(hyp));
for epo=1:length(hyp)
    num=0;
    for p=1:length(x)
        sigma = judge_ins(4,p,epo);
        delta = judge_ins(1,p,epo);
        theta = judge_ins(2,p,epo);
        alpha = judge_ins(3,p,epo);
        if sigma>2*judge(4,epo)%% larger than 2 times of average Sigma of 30s epoch
            if sigma>delta && sigma>theta && sigma>alpha*0.8 %% larger than all other freq in same window
                num = num+1;
            end
        end
    end
    ss_num_all_epoch(1,epo) = num;
end
toc;

figure;
sub = 1;
subplot(sub,1,1);
plot(M,'b');hold on;
plot(ss_num_all_epoch,'r'); hold on;




%%

