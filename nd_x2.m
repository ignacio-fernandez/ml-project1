%On the Deep Network Designer start page, pause on Sequence-to-Sequence and click Open. Doing so opens a prebuilt network suitable for sequence-to-sequence classification tasks. You can convert the classification network into a regression network by replacing the final layers.

%Delete the softmax layer and the classification layer and replace them with a regression layer.

%Adjust the properties of the layers so that they are suitable for the chickenpox data set. This data has a single input feature and a single output feature. Select sequenceInputLayer and set the InputSize to 1. Select fullyConnectedLayer and set the OutputSize to 1.

%Check your network by clicking Analyze. The network is ready for training if Deep Learning Network Analyzer reports zero errors.


%Import Data
%To import the training datastore, select the Data tab and click Import Data > Import Custom Data. Select cdsTrain as the training data and None as the validation data. Click Import. 

%The data preview shows a single input time series and a single response time series, each with 448 time steps.


%Specify Training Options
%On the Training tab, click Training Options. Set Solver to adam, InitialLearnRate to 0.005, and MaxEpochs to 500. To prevent the gradients from exploding, set the GradientThreshold to 1. 

%For more information about setting the training options, see trainingOptions.

%Train Network
%Click Train. 
%Deep Network Designer displays an animated plot showing the training progress. The plot shows mini-batch loss and accuracy, validation loss and accuracy, and additional information on the training progress.

%Once training is complete, export the trained network by clicking Export in the Training tab. The trained network is saved as the trainedNetwork_1 variable.

%Forecast Future Time Steps
%Test the trained network by forecasting multiple time steps in the future. Use the predictAndUpdateState function to predict time steps one at a time and update the network state at each prediction. For each prediction, use the previous prediction as input to the function.
%Standardize the test data using the same parameters as the training data.
dataTestStandardized = (dataTest - mu) / sig;

XTest = dataTestStandardized(1:end-1);
YTest = dataTest(2:end);
%To initialize the network state, first predict on the training data XTrain. Next, make the first prediction using the last time step of the training response YTrain(end). Loop over the remaining predictions and input the previous prediction to predictAndUpdateState.
%For large collections of data, long sequences, or large networks, predictions on the GPU are usually faster to compute than predictions on the CPU. Otherwise, predictions on the CPU are usually faster to compute. For single time step predictions, use the CPU. To use the CPU for prediction, set the 'ExecutionEnvironment' option of predictAndUpdateState to 'cpu'.
net = predictAndUpdateState(trainedNetwork_1,XTrain);

[net,YPred] = predictAndUpdateState(net,YTrain(end));

numTimeStepsTest = numel(XTest);
for i = 2:numTimeStepsTest
    [net,YPred(:,i)] = predictAndUpdateState(net,YPred(:,i-1),'ExecutionEnvironment','cpu');
end
%Unstandardize the predictions using the parameters calculated earlier.
YPred = sig*YPred + mu;
%The training progress plot reports the root-mean-square error (RMSE) calculated from the standardized data. Calculate the RMSE from the unstandardized predictions.
rmse = sqrt(mean((YPred-YTest).^2));
%Plot the training time series with the forecasted values.
figure
plot(dataTrain(1:end-1))
hold on
idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
plot(idx,[data(numTimeStepsTrain) YPred],'.-')
hold off
xlabel("day")
ylabel("return")
title("Forecast")
legend(["Observed" "Forecast"])
%Compare the forecasted values with the test data.
figure
subplot(2,1,1)
plot(YTest)
hold on
plot(YPred,'.-')
hold off
legend(["Observed" "Forecast"])
ylabel("Cases")
title("Forecast")

subplot(2,1,2)
stem(YPred - YTest)
xlabel("Month")
ylabel("Error")
title("RMSE = " + rmse)

%Update Network State with Observed Values
%If you have access to the actual values of time steps between predictions, then you can update the network state with the observed values instead of the predicted values.
%First, initialize the network state. To make predictions on a new sequence, reset the network state using resetState. Resetting the network state prevents previous predictions from affecting the predictions on the new data. Reset the network state, and then initialize the network state by predicting on the training data.
net = resetState(net);
net = predictAndUpdateState(net,XTrain);
%Predict on each time step. For each prediction, predict the next time step using the observed value of the previous time step. Set the 'ExecutionEnvironment' option of predictAndUpdateState to 'cpu'.
YPred = [];
numTimeStepsTest = numel(XTest);
for i = 1:numTimeStepsTest
    [net,YPred(:,i)] = predictAndUpdateState(net,XTest(:,i),'ExecutionEnvironment','cpu');
end
%Unstandardize the predictions using the parameters calculated earlier.
YPred = sig*YPred + mu;
%Calculate the root-mean-square error (RMSE).
rmse = sqrt(mean((YPred-YTest).^2))
%Compare the forecasted values with the test data.
figure
subplot(2,1,1)
plot(YTest)
hold on
plot(YPred,'.-')
hold off
legend(["Observed" "Predicted"])
ylabel("return")
title("Forecast with Updates")

subplot(2,1,2)
stem(YPred - YTest)
xlabel("day")
ylabel("Error")
title("RMSE = " + rmse)
%Here, the predictions are more accurate when updating the network state with the observed values instead of the predicted values.
%Copyright 2021 The MathWorks, Inc.
