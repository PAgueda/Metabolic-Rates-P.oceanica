%windToK600.m
%7/12/06
%JJColoso
%
% IMEDEA > Modification to include year in the wind field
%     Wind file must have three columns: 
%       YEAR   DAY  DAYFRACTION  WIND SPEED
%
%Function to calculate k600 from wind data.  Wind data does not need to
%have same interval as sonde data - it will be interpolated to it.
%winddata: time in dayfrac, wind speed m/s
%interpTime: the time (in dayfrac) to interpolate wind data to.  i.e. the sonde data time
%Found new parametrization by Dueñas et al. (1986)

function k600=windToK600_imedea(winddata,interpTime,windheight,ik660choice) 

% Control
if size(winddata,2) <4
    errordlg('Error in the wind file - Wind file needs 4 columns (Year Day Dayfrac Windspeed)')
end
windtime=datenum(winddata(:,1),1,0)+winddata(:,2)+winddata(:,3);
wind=abs(winddata(:,4)); %wind speed -> Imedea Force to be always positive !
wind10=wind./(windheight/10)^0.15; %wind at 10m assuming wind mesured at 2m (as it was on Crampton 2005 Buoy) (Smith 1985)
disp('******************************************************')
if ik660choice==1 
    disp('K600!!! from Cole&Caraco 98 but converted to m/d');
    k600_calc=(2.07+0.215.*wind10.^(1.7))/100 *24; 
elseif ik660choice==2
    disp('K660 From Wanninkhof (2014) - Quadratic converted to m/2');
    k600_calc=[0.2705*wind10.^2]/100*24;
elseif ik660choice==3
    disp('K660 From Kihm & Kortzinger (2010) - Cubic converted to m/2');
    k600_calc=[ 0.042*wind10.^3]/100*24;
elseif ik660choice==4
    disp('K660 From Dueñas et al (1986) - Exponential converted to m/2');
    k600_calc=[0.49*2.72.^(0.16*wind10)]/100*24;
end    
disp('******************************************************')
k600_bar=nanmean(k600_calc);
k600_calc=interp1(windtime,k600_calc,interpTime,'linear');
k600NaN=find(isnan(k600_calc));
k600_calc(k600NaN)=k600_bar; %if interpTime data extends beyond wind data it results in NaNs when interpolated.
                        %This replaces them w/ average calculated k600
k600=k600_calc;   
