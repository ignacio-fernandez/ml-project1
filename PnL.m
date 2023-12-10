% Read CSV file
data = readtable('data_ml.csv', 'ReadVariableNames', true);
data.Date = datetime(data.Date, 'InputFormat', 'MM-dd-yyyy');

% Initialize variables
pnl = 0;
positions.GOOG = 100;
positions.TTWO = 100;
buy_sell_signals = {};

% Variables for PNL plotting
dates_for_plot = [];
pnl_values_for_plot = [];

% Iterate through rows
for index = 1:height(data)
    date = data.Date(index);
    delta_xt = data.Delta_xt(index);
    goog_price = data.GOOG(index);
    ttwo_price = data.TTWO(index);

    % Update positions from the previous day
    prev_positions = positions;

    % Execute trading strategy
    if delta_xt < 0
        % Buy 100 shares of GOOG, short 100 shares of TTWO
        positions.GOOG = positions.GOOG + 200;
        positions.TTWO = positions.TTWO - 200;
        buy_sell_signals{end + 1} = {date, 'Buy 100 shares GOOG', 'Short 100 shares TTWO'};
    elseif delta_xt > 0
        % Short 100 shares of GOOG, buy 100 shares of TTWO
        positions.GOOG = positions.GOOG - 200;
        positions.TTWO = positions.TTWO + 200;
        buy_sell_signals{end + 1} = {date, 'Short 100 shares GOOG', 'Buy 100 shares TTWO'};
    end

    % Adjust positions if there is a change in the sign of delta_xt
    if prev_positions.GOOG ~= positions.GOOG && prev_positions.TTWO ~= positions.TTWO
        pnl = pnl + (prev_positions.GOOG - positions.GOOG) * goog_price + (prev_positions.TTWO - positions.TTWO) * ttwo_price;
    end

    % Record PNL for plotting
    dates_for_plot(end + 1) = datenum(date);  % Convert datetime to numerical representation
    pnl_values_for_plot(end + 1) = pnl;
end

% Display PNL and plot
disp(['Total PNL: ', num2str(pnl)]);
disp(['Final Positions: GOOG ', num2str(positions.GOOG), ', TTWO ', num2str(positions.TTWO)]);

% Plot PNL
figure;
plot(dates_for_plot, pnl_values_for_plot);
xlabel('Date');
ylabel('PNL');
title('PNL Over Time');
