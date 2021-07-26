

%% read excel sheet, plotting all the data in one figure
data = xlsread('PhaseMap_data_v2.xlsx'); % schock velocity data
time = xlsread('PhaseMap_data_v2.xlsx', 'sheet2'); % time data (x-axis)
plot(time,data)
xlabel('time (ns)');
ylabel('shock wave velocity (km/s)');

[row, col] = size(data);

%% dataset reorganization and averaging (for velocity)
marker = 1;
new_vel_array = []; % this is the array of the averaged velocities (5 sections)
uncertainty = []; % this is the array of the uncertanties of each datapoint after averaging 
for x = 1:5 % 155/31 = 5
    a = data(:, [marker : marker + 30]); %store all rows and current 31 columns into var a
    avg1 = mean(a,2); % store average of those 31 columns into one column avg1
    new_vel_array(:,x) = avg1; % store the averaged columns into a single column in new_vel_array
    
    
    for r = 1:row % this part calculates the uncertainty of each row average
        max1 = max(data(r,[marker : marker + 30]));
        min1 = min(data(r,[marker : marker + 30]));
        deltax = (max1 - min1)/2; % uncertainty of measurement (each row)
        deltax_avg = deltax / sqrt(3); % uncertainty of mean of each row
        uncertainty(r,x) = deltax_avg; % fill in uncertainty array with each cell corresponding to newarray cell
    end
    % we used uncertainty eqn for 'small' data sets since we are dealing
    % with 31 values per group, which is not big enough to be considered a
    % 'large' dataset
  
 marker = marker + 31; % shift the marker to the next set of 31 columns
    
end
% now I averaged the dataset into 5 datasets instead of 155 of them, and
% also stored the uncertainties of averaging 


%% assign each column of averaged dataset to individual array
data1 = new_vel_array(:,1);
data2 = new_vel_array(:,2);
data3 = new_vel_array(:,3);
data4 = new_vel_array(:,4);
data5 = new_vel_array(:,5);

%the way this is stored is from left to right of the data sheet -> top to
%bottom of phase chart?
%so data1 is the top portion of the phase chart?

%% given times from zixuan
bot = 14.044169; %bottom
top = 14.265729; %top

%% closest values to top/bottom breakout time (use interpolation if not accurate?)
[val,idx1]=min(abs(time-bot));
bottom_time=time(idx1); %actual timestamp in our data closest to bot
[val,idx2]=min(abs(time-top));
top_time = time(idx2); %actual timestamp in our data closest to top

%assuming first column of 'data' is the top of phase map
top_vel = data(idx2,1);
bottom_vel = data(idx1, col);

%so basically the two coordinates for top/bottom are (top_time, top_vel)
%(bottom_time, bottom_vel)

diff = top_time - bottom_time;
inc = diff / 154; % this is the time increment between top_time and bottom_time spread across 155 sets of data

new_time = []; % array for time values between bottom_time and top_time using increment
for z = 0:154
   new_time(z+1, 1) = bottom_time + inc*z; 
end


%% dataset reorganization and averaging (for interface time)
%now I have an array of interface time values for every single row (155) on phase map
%next I will section them into 5 sections with averaged interface time
%careful with which row section corresponds to which column section

marker = 1;
new_time_array = [];
for x = 1:5 % 155/31 = 5
    a = new_time([marker : marker + 30],1); %temporarily store 31 rows into a 
    avg1 = mean(a,1); % store average of those 31 rows into one column avg1
    new_time_array(x,1) = avg1; % store the averaged columns into a single column in newarray
    
    marker = marker + 31;
    
end

%now I have a column array new_time_array with 5 interface time values of
%each section 
%from top to bottom of this column array, it corresponds to bottom to top of phase
%map


%basically I have 5 interface times (averaged from 5 sections) so now I can
%plug these times into the linear regression eqn, but I have to make sure
%it is plugged into the corresponding linear eqn since there are 5
%different ones

%% plot the 5 different datasets vs. time, and also the line of best fit from t = 15-18ns
choice = menu('which dataset to plot?','1','2','3', '4', '5'); 
time = xlsread('PhaseMap_data_v2.xlsx', 'sheet2');
global c1
global c2


if choice == 1
    disp('dataset1');
    plot(time,data1);
    title('dataset 1 after lineouts');
    xlabel('time (ns)');
    ylabel('shock wave velocity (km/s)');
    
    hold on
    x = time;
    y = data1;
    ind = x >= 15 & x<= 18;
    p = polyfit(x(ind), y(ind), 1); %linear(1) poly fit for data in specified range (returns coefficients of poly function)
    plot(x(ind), polyval(p,x(ind)), 'r'); %plot the best fit line     
    c1 = p(1); %storing the coefficients for linear regression 
    c2 = p(2);
    interface_vel = bestfit(new_time_array(5)); % since new_time_array is ascending in time top to bottom, the first dataset is the last item (5)
    disp(['interface velocity ' num2str(choice) ': ' num2str(interface_vel)]); % display the interface velocity of averaged dataset 1 (top of phase map)
    
elseif choice == 2
    disp('dataset2');
    plot(time,data2);
    title('dataset 2 after lineouts');
    xlabel('time (ns)');
    ylabel('shock wave velocity (km/s)');
    
    hold on
    x = time;
    y = data2;
    ind = x >= 15 & x<= 18;
    p = polyfit(x(ind), y(ind), 1); %linear(1) poly fit for data in specified range (returns coefficients of poly function)
    plot(x(ind), polyval(p,x(ind)), 'r'); %plot the best fit line
    c1 = p(1);
    c2 = p(2);
    interface_vel = bestfit(new_time_array(4));
    disp(['interface velocity ' num2str(choice) ': ' num2str(interface_vel)]);
    
elseif choice == 3
    disp('dataset3');
    plot(time,data3);
    title('dataset 3 after lineouts');
    xlabel('time (ns)');
    ylabel('shock wave velocity (km/s)');
    
    hold on
    x = time;
    y = data3;
    ind = x >= 15 & x<= 18;
    p = polyfit(x(ind), y(ind), 1); %linear(1) poly fit for data in specified range (returns coefficients of poly function)
    plot(x(ind), polyval(p,x(ind)), 'r'); %plot the best fit line 
    c1 = p(1);
    c2 = p(2);
    interface_vel = bestfit(new_time_array(3));
    disp(['interface velocity ' num2str(choice) ': ' num2str(interface_vel)]);
    
elseif choice == 4
    disp('dataset4');
    plot(time,data4);
    title('dataset 4 after lineouts');
    xlabel('time (ns)');
    ylabel('shock wave velocity (km/s)');
    
    hold on
    x = time;
    y = data4;
    ind = x >= 15 & x<= 18;
    p = polyfit(x(ind), y(ind), 1); %linear(1) poly fit for data in specified range (returns coefficients of poly function)
    plot(x(ind), polyval(p,x(ind)), 'r'); %plot the best fit line
    c1 = p(1);
    c2 = p(2);
    interface_vel = bestfit(new_time_array(2));
    disp(['interface velocity ' num2str(choice) ': ' num2str(interface_vel)]);
    
else
    disp('dataset5');
    plot(time,data5);
    title('dataset 5 after lineouts');
    xlabel('time (ns)');
    ylabel('shock wave velocity (km/s)');
    
    hold on
    x = time;
    y = data5;
    ind = x >= 15 & x<= 18;
    p = polyfit(x(ind), y(ind), 1); %linear(1) poly fit for data in specified range (returns coefficients of poly function)
    plot(x(ind), polyval(p,x(ind)), 'r'); %plot the best fit line
    c1 = p(1);
    c2 = p(2);
    interface_vel = bestfit(new_time_array(1));
    disp(['interface velocity ' num2str(choice) ': ' num2str(interface_vel)]);
    
    
end


%% root mean squared error of linear regression

time_regression = x(ind); % time values between 15 and 18
velocity_regression = y(ind); % velocity values for time between 15 and 18
bestfit_vel = []; %array for the best fit data between 15 and 18 ns
for i = 1:numel(time_regression) %filling in bestfit_vel 
   bestfit_vel(i,1) = bestfit(time_regression(i)); 
end

rms_error = rmse(velocity_regression, bestfit_vel); %root mean squared error for best fit line


%{
%% more efficient method of taking lineouts and averaging data
for x = 0:4
   newarray2(:, x + 1) = mean(data(:, x*31+1 : (x+1)*31), 2); 
  
end

%}


%%




%{
%% interpolation between two coordinates (don't need?)
global slope %linear slope of interpolated line
slope = (top_vel - bottom_vel) / (top_time - bottom_time);

global solx %y-intercept of interpolated line
syms b
eqn = slope*top_time + b == top_vel;
solx = double(solve(eqn,b));

% now we have the linear equation for the interpolated line

%}
