retdata=price2ret(stockdata);

%plot(stockdata)
%plot(retdata)

partition=cvpartition(501,"Holdout",.2);
idxTrain = training(partition);
traindata = retdata(idxTrain,:);
idxNew = test(partition);
testdata = retdata(idxNew,:);
