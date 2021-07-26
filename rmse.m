function r_error = rmse (data, estimate) %root mean squared error with data as the actual vs. estimate as the fit
    r_error = sqrt(sum((data(:) - estimate(:)) .^2) / numel(data))
end