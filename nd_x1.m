%Train Network for Time Series Forecasting Using Deep Network Designer
%This example shows how to forecast time series data by training a long short-term memory (LSTM) network in Deep Network Designer.
%Deep Network Designer allows you to interactively create and train deep neural networks for sequence classification and regression tasks.
%To forecast the values of future time steps of a sequence, you can train a sequence-to-sequence regression LSTM network, where the responses are the training sequences with values shifted by one time step. That is, at each time step of the input sequence, the LSTM network learns to predict the value of the next time step.
%This example uses the data set chickenpox_dataset. The example creates and trains an LSTM network to forecast the number of chickenpox cases given the number of cases in previous months.

%Load Sequence Data
%Load the example data. chickenpox_dataset contains a single time series, with time steps corresponding to months and values corresponding to the number of cases. The output is a cell array, where each element is a single time step. Reshape the data to be a row vector.

dataTrain = xxd';
dataTest = xxt';

figure
plot(dataTrain)
xlabel("day")
ylabel("return")
title("Daily returns")

numTimeStepsTrain = numel(dataTrain);

%Standardize Data
%For a better fit and to prevent the training from diverging, standardize the training data to have zero mean and unit variance. For prediction, you must standardize the test data using the same parameters as the training data.
mu = mean(dataTrain);
sig = std(dataTrain);

dataTrainStandardized = (dataTrain - mu) / sig;
%Prepare Predictors and Responses
%To forecast the values of future time steps of a sequence, specify the responses as the training sequences with values shifted by one time step. That is, at each time step of the input sequence, the LSTM network learns to predict the value of the next time step. The predictors are the training sequences without the final time step.
XTrain = dataTrainStandardized(1:end-1);
YTrain = dataTrainStandardized(2:end);
%To train the network using Deep Network Designer, convert the training data to a datastore object. Use arrayDatastore to convert the training data predictors and responses into ArrayDatastore objects. Use combine to combine the two datastores. 
adsXTrain = arrayDatastore(XTrain);
adsYTrain = arrayDatastore(YTrain);

cdsTrain = combine(adsXTrain,adsYTrain);

%Define LSTM Network Architecture
%To create the LSTM network architecture, use Deep Network Designer. The Deep Network Designer app lets you build, visualize, edit, and train deep learning networks.
deepNetworkDesigner
