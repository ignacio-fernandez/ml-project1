net = predictAndUpdateState(trainedNetwork_1,XTrain');

[net,YPred] = predictAndUpdateState(net,YTrain(end));

numTimeStepsTest = numel(XTest);
for i = 2:numTimeStepsTest
    [net,YPred(:,i)] = predictAndUpdateState(net,YPred(:,i-1),'ExecutionEnvironment','cpu');
end

net = resetState(net);
net = predictAndUpdateState(net,XTrain');
%Predict on each time step. For each prediction, predict the next time step using the observed value of the previous time step. Set the 'ExecutionEnvironment' option of predictAndUpdateState to 'cpu'.
YPred = [];
numTimeStepsTest = numel(XTest);
for i = 1:numTimeStepsTest
    [net,YPred(:,i)] = predictAndUpdateState(net,XTestT(:,i),'ExecutionEnvironment','cpu');
end


% 
rmse = sqrt(mean((YPred-YTest).^2));

figure
plot(dataTest(1:end-1))
hold on
idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
plot(YPred,'.-')
hold off
xlabel("Timestep")
ylabel("P&L")
title("Forecast")
legend(["Observed" "Forecast"])


spread=mean(YPred-YTest');
YPred2=YPred-spread;

rmse2 = sqrt(mean((YPred2-YTest).^2));

figure
plot(rmse2)

figure
plot(dataTest(1:end-1))
hold on
idx = numTimestepsTrain:(numTimestepsTrain+numTimestepsTest);
plot(YPred-spread,'.-')
hold off
xlabel("Timestep")
ylabel("P&L")
title("Forecast")
legend(["Observed" "Forecast"])
