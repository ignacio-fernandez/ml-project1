retdata=price2ret(stockdata);

%plot(stockdata)
%plot(retdata)

partition=cvpartition(501,"Holdout",.2);
traindata = retdata(training(partition),:);
testdata = retdata(test(partition),:);

[traincoeff,trainscore,trainlatent,traintsquared,trainexplained,trainmu] = pca(traindata);
[testcoeff,testscore,testlatent,testtsquared,testexplained,testmu] = pca(testdata);

% 1st has the same sign - associated with market movements
% 2nd, 3rd and 4th - both signs
%plot(trainexplained)
%plot(testexplained)
