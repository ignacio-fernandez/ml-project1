% Replace Linear with Ridge regression

M = 5;  % Number of data points to use for regression
retGOOG = price2ret(GOOG);  % Convert stock prices to returns
retTTWO = price2ret(TTWO);
N = length(retTTWO);  % Length of the return vectors

alphavec = zeros((N-20), 1);  % Initialize vector to store alpha (intercept)
betavec = zeros((N-20), 1);   % Initialize vector to store beta (slope)

% Ridge regression parameter (adjust lambda based on your needs)
lambda = 0.1;

for i = M+1:1:N
    % Fit a ridge regression model using the last M data points
    X = [ones(M,1) retTTWO((i-M):(i-1))];
    y = retGOOG((i-M):(i-1));
    
    % Perform ridge regression using the 'ridge' function
    beta = ridge(y, X, lambda);
    
    % Store the regression coefficients in the vectors
    alphavec(i-M) = beta(1);  % Intercept
    betavec(i-M) = beta(2);   % Slope
end



% Replace Linear with Lasso regression

M = 5;  % Number of data points to use for regression
retGOOG = price2ret(GOOG);  % Convert stock prices to returns
retTTWO = price2ret(TTWO);
N = length(retTTWO);  % Length of the return vectors

alphavec = zeros((N-20), 1);  % Initialize vector to store alpha (intercept)
betavec = zeros((N-20), 1);   % Initialize vector to store beta (slope)

% Lasso regression parameter (adjust alpha based on your needs)
alpha = 0.1;

for i = M+1:1:N
    % Fit a lasso regression model using the last M data points
    X = [ones(M,1) retTTWO((i-M):(i-1))];
    y = retGOOG((i-M):(i-1));
    
    % Perform lasso regression using the 'lasso' function
    B = lasso(X, y, 'Alpha', alpha);
    
    % Store the regression coefficients in the vectors
    alphavec(i-M) = B(1);  % Intercept
    betavec(i-M) = B(2);   % Slope
end



% Replace Linear with polynomial regression

M = 5;  % Number of data points to use for regression
retGOOG = price2ret(GOOG);  % Convert stock prices to returns
retTTWO = price2ret(TTWO);
N = length(retTTWO);  % Length of the return vectors

deg = 2;  % Degree of the polynomial (adjust based on your needs)

alphavec = zeros((N-20), 1);  % Initialize vector to store alpha (intercept)
betavec = zeros((N-20), 1);   % Initialize vector to store beta (slope)

for i = M+1:1:N
    % Fit a polynomial regression model using the last M data points
    X = [ones(M, 1), (1:M)', retTTWO((i-M):(i-1))];  % Polynomial features
    y = retGOOG((i-M):(i-1));
    
    % Perform polynomial regression using the 'polyfit' function
    coeff = polyfit(X(:, 3), y, deg);
    
    % Store the regression coefficients in the vectors
    alphavec(i-M) = coeff(1);  % Intercept
    betavec(i-M) = coeff(2);   % Slope
end


