%Nora Basha-Range Estimation using grid method-300 Monte-Carlo runs
clc
clear
%DATA GENERATION
Iterations=200;
 Estimates=zeros(1,Iterations);
 A=logspace(-1,1);
 MSE=zeros(1, length(A));
 SNR=zeros(1, length(A));
 Bias=zeros(1, length(A));
CRLB=zeros(1, length(A));
 for k=1:length(A)
     Amp=A(k);
for j=1:Iterations
N=1000;
ts=1/N;
t0=0:ts:0.1;
t1=0.1:ts:0.9;
t2=0.9:ts:1;
t3=1:ts:10;
t4=10:ts:15;
y0=zeros(1,length(t0));
y1=ones(1,length(t1));
y2=zeros(1,length(t2));
y3=zeros(1,length(t3));

N0=0.001;
for i=1: length(t0)
    y0(i)=t0(i)/0.1;
end

for i=1: length(t2)
    y2(i)=(1-(t2(i)))/(1-0.9);
end
s=Amp*[y0,y1,y2,y3];
t=[t0,t1,t2,t3];
plot(t,s)
sd=[zeros(1,5),s];%delayed version
%AWGN with 0 mean and unit variance
y=(sd)+ sqrt((N0/2)*N)*randn(size(sd));
%Maximum Likelihood Estimator
[r,lags]= xcorr(y,s);
rabs=abs(r);
% taus=lags(109:end);% to ensure the delay is non-negative
% rabsValid=rabs(109:end);
[~,I] = max(rabs);
Estimates(j)=lags(I);
MSE(k)=mean((Estimates-5).^2);
Bias(k)= mean(Estimates)-5;
SNR(k)= (20*Amp^2)/((N0/2)*N);
CRLB(k)=1/(20*SNR(k)*N);
% hold on
% plot(lags,rabs)
end
 end
 figure(1)
 axes('XScale', 'log', 'YScale', 'log')
 hold on
 loglog(SNR,MSE,'DisplayName','MSE')
  xlabel('SNR')
  ylabel('MSE')
  loglog(SNR,CRLB,'DisplayName','CRLB')
  grid on
  hold off
  figure(2)
  plot(log(SNR),Bias,'DisplayName','Bias')
  xlabel(' log SNR')
  ylabel('Bias')
 figure(3)
stem(Estimates, 'DisplayName','Estimates')
xlabel('Iterate no')
  ylabel('Estimated Delay')
  
