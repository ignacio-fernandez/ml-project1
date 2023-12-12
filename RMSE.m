% Read the CSV file
data = readtable('final_pnl.csv');

% Extract data from the table
dates = data.Date;
ridge = data.ridge;
poly = data.poly;
linear = data.linear;
lasso = data.lasso;
actual = data.actual;

% Convert dates to datetime objects
dates = datetime(dates, 'InputFormat', 'MM/dd/yy');

% Plot the data
figure;
plot(dates, ridge, 'DisplayName', 'Ridge', 'Color', [0.9294, 0.6941, 0.1255], 'LineWidth', 2);
hold on;
plot(dates, poly, 'DisplayName', 'Poly', 'Color', [0, 0.5, 0], 'LineWidth', 2);
plot(dates, linear, 'DisplayName', 'Linear', 'Color', 'blue', 'LineWidth', 2);
plot(dates, lasso, 'DisplayName', 'Lasso', 'Color', 'red', 'LineWidth', 2);
plot(dates, actual, 'DisplayName', 'Actual', 'Color', 'black', 'LineWidth', 2);

% Add labels and title
xlabel('Date');
ylabel('Values');
title('Data Plot');
legend('show', 'Location', 'northwest');
grid on;

% Display the date on the x-axis
xtickformat('MM/dd/yy');

% Assuming you have the Statistics and Machine Learning Toolbox
rmse_ridge = rmse(ridge, actual);
rmse_poly = rmse(poly, actual);
rmse_linear = rmse(linear, actual);
rmse_lasso = rmse(lasso, actual);

% Display or use the RMSE values as needed
disp(['RMSE Ridge: ', num2str(rmse_ridge)]);
disp(['RMSE Poly: ', num2str(rmse_poly)]);
disp(['RMSE Linear: ', num2str(rmse_linear)]);
disp(['RMSE Lasso: ', num2str(rmse_lasso)]);

