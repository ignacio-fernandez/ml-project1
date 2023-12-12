stockdata=readtable('stock_data.csv');
prices=table2array(stockdata(:,3:end));

% GOOG AND TTWO had highest correlation from visual inspection
GOOG=prices(:,3);
TTWO=prices(:,10);

M=7;

% Create returns vector
retGOOG=price2ret(GOOG);
retTTWO=price2ret(TTWO);
N=length(retTTWO);

% Evaluate regression coefficient
alphavec = zeros((N-60),1);
betavec = zeros((N-60),1);
for i = M+1:1:N
    [beta,betaint] = regress(retGOOG((i-M):(i-1)),[ones(M,1) retTTWO((i-M):(i-1))]);
    alphavec(i-M) = beta(1);
    betavec(i-M) = beta(2);
end

delta_X=retGOOG(M:end-1)-betavec.*retTTWO(M:end-1)-alphavec;
X=zeros(length(delta_X),1);
for k=1:length(delta_X)
    X(k)=sum(delta_X(1:k));
end

data=X;
numTimestepsTrain= 397;
numTimestepsTest=length(data)-numTimestepsTrain;
dataTrain=data(1:numTimestepsTrain+1);
dataTest=data(numTimestepsTrain+1:end);
    
%XTrain = [dataTrain(1:end-3),dataTrain(2:end-2),dataTrain(3:end-1)];
XTrain=dataTrain(1:end-1);
YTrain = dataTrain(2:end);

XTest=dataTest(1:end-1);
YTest = dataTest(2:end);
XTestT=XTest';

adsXTrain=arrayDatastore(XTrain);
adsYTrain = arrayDatastore(YTrain);

cdsTrain = combine(adsXTrain,adsYTrain);

deepNetworkDesigner
