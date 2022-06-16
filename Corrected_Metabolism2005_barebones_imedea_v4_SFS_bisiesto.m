% Metabolism2005_barebones_v4.m  
% JJColoso  5/8/07, updated 12/29/09
% this program is designed to calculate GPP,R,NEP from oyxgen sonde data of
% various types conforming to the necessary input style.  It is supposed to
% be simple to import the data and run.
%
% - This version has been modified at IMEDEA by Susana Flecha, 2020 
%   Changes performed:
%       Input parameters reorganization
%       Dissolved oxygen equation: Salinity is includedff
%       Salinity can be included as the 7th column in file (optional)
%       windtok600 subroutine now allows complete date (including year)
%       Wind height measurements is defined in the parameter section
%       If Identifier of deployment is not in the Sonde file, it is set to 1 for all rows in file
%       The Night Respiration is also saved along with temperature
%       Atmospheric pressure (affecting DOsat) is introduced as a parameter
% - This version is like previous IMEDEA version but modifying the matrix
% size in the R/NEP computations. Also, the determination of darkhours is
% now corrected.
%       *It still remains unsolved (in progress), to allow input files to
%       cover more than one year.
%       *We include different formulations for K660 from Kihm and Kortzinger
%       (JGR 2010)
%       *We include different choices to estimate daylight respiration
%       *An output file with information on respiration and temperature is
%       also savecd
%       Changes by Peru Águeda, 2022:
%   New parametrization for k600, based on Dueñas et al. (1986)
%   This version is exclusively for calculations in leap years. 366 days
%   have been considered for all daily calculations.
% *************************************************************************
% Input file requirements:
% The following files should be *.csv files (text files which are comma 
% delimited and have the extension csv).  The first line of the file should
% have data (column) labels.  Therefore the first row is not read into this
% program.    

% (1) Sonde data.  First row should be col headers.  col 1: YEAR, col 2: DayOfYear, 
% col 3:  time (fraction of a day) in UTC, col 4: temperature (degrees C), col 5: 
% dissolved oxygen, percent saturation (relative to sea level=100%), col 
% 6: deployment ID (if deployments are seamless, then they should have the 
% same deployment ID; if deployments have a gaps between them they should be
% numbered as separate deployments.); col 7: salinity (PSU)

% [Because different programs base their dates on different roots, it is
% best to import dates using Year and DOY as separate fields.  For example,
% MS Excel uses January 1, 1900 as date 1, while Matlab uses January 1,
% 0000 as date 1.]

% (2) Zmix - the depth of the mixed layer. Loading this data is optional. A
% constant value can be set for zmix for the length of the deployment.
% First row of data should be col headers. This program requires an input
% file where col 1: Year, col 2: DOY, and col 3: zmix.  This program will
% interpolate the zmix values from this input file if needed.  Thus, as a
% minimum, the input file needs to have 2 entries: 1 from the first day (or
% earlier) of the sonde data and 2 from the last day (or later) of sonde
% data. 
%
% (3) Calibration data.  Data to correct the sonde DO %sat data. Code
% modified from Jon's Mirror Lake program 'MLSondecalc.m' to fit Crampton
% 2005 sonde data. JJC 10/13/05.
% 1)deploymentID, 2)year, 3)preDayfrac (DOY + fraction of day, when sonde
% deployed in lake),4)PreDO%sat (%sat in cup after calibration but before
% deployment), 5)PostDO%sat (%sat in cup after retrieval but before
% calibration), 6)PostDayfrac (when sonde removed from lake)

% (4) k600.  This can be calculated using wind data (Cole and Caraco 1998
% L&O). If no wind data is available, can use a constant.  All information
% suggests this is 0.4 in Peter and Paul. See J.Cole.  To use wind data,
% set calc_k600 to one, if 0 it will calculate it by?
% Wind data cols: 1) Dayfrac (UTC), 2) wind speed (m/s).

% NOTE: In order for this program to run, the functions o2saturation.m and excise.m must be in the
% same directory as this program.  Also need windToK600_imedea.m and DOcorrect.m to use calculate k600 from
% wind and correct DO for drift

% *************************************************************************

clear variables % clear variables from memory, but not global variables
close all % close all open figures 

% *************************************************************************
%  LOAD INPUT FILES
% *************************************************************************
% -- PARAMETERS > Imedea
ik660formulation=4; % 1>Original formulation by Cole&Caraco 98 2> Wanninkhof Quadratic  3> K&K Cubic 4>Dueñas Exponential (Recommended)
daylightRoption=1; % 1> Using Night Resp. for daylight 2> Using Day R as a function of Temp. 3> Using Day R + night anomalies
k600=0.4; % default is 0.4 m/d.
albedo=1; % 1 is no albedo.
cloudiness=1; % 1 is no cloudiness %this is noy used above,?????
lat=39.14; % Put the lattitude manually!!!
windheight=10; % Height of wind measurements if read from file. 
salref=38; % Salinity to be used if it is not in the input file
Patm=0.942; %typical atm. pressure at UNDERC.

%----on/off switches  1=on, 0=off
savefile=1; %For saving daily values to a .csv file.
showfigures=1; %plot daily GPP,R,NEP
correctSondeData=0; %correct DO data for drift
calc_k600=1; %1=use wind data to calc k600; 0=no win data
rememberFileNames=0; %saves file names so they don't have to be selected each run.
%------------

if rememberFileNames==1
    global sfilename; global spathname; global zfilename;global zpathname;
    global zmixdata; global runCount; global cfilename; global cpathname;
    global wfilename; global wpathname;
end

%**********Get files from user****************************
% SONDE DATA
%if remembering file names and 2nd or nth run
if rememberFileNames==1 & runCount>0
    % read in data starting with 2nd row and first column (indices are zero-based)
    sondedata=csvread([spathname sfilename],1,0);   
else % ask user to select file
    [sfilename,spathname]=uigetfile('*.csv','Select sonde data file');
    sondedata=csvread([spathname sfilename],1,0);   
end
% ZMIX DATA
%if remembering file names and nth run
if rememberFileNames==1 & runCount>0
    if zfilename~=0
        zmixdata=csvread([zpathname zfilename],1,0);
    else
        zmixdata=zmixdata; %remembers zmix, if want new zmix each time use line below
%         zmixdata=str2double(inputdlg('Enter default Zmix'));
    end
else  %ask user to select zmix file, or cancel and enter a default zmix
    [zfilename,zpathname]=uigetfile('*.csv', 'Select Zmix data file, or cancel to enter default value');
    if zfilename~=0 %set to selected file
       zmixdata=csvread([zpathname zfilename],1,0);
    else %set to constant value
        zmixdata=str2double(inputdlg('Enter default Zmix'));%enter in default zmix        
    end
end
  
% *************************************************************************
%  Manipulate input data formats
% *************************************************************************
% Create variables from each column
SDYear=sondedata(:,1);
SDDOY=sondedata(:,2);
SDtime=sondedata(:,3);
SDtemp=sondedata(:,4);
SDO2sat=sondedata(:,5);
if size(sondedata,2)<6;
    disp('-> No information about ID deployment - setting it to 1')
    SDdeployID=sondedata(:,1).*0+1;
else;
    SDdeployID=sondedata(:,6);
end
SDdayfrac=sondedata(:,2)+sondedata(:,3);
% > Imedea - Check if salinity is in file
if size(sondedata,2)>=7
    SDsal=sondedata(:,7);
else
    SDsal=SDtemp.*0+ salref;
end

% create one date/time field in Matlab Serial Date format:
SDdate=datenum(SDYear,1,0)+SDDOY+SDtime;

if zfilename~=0 %if loaded zmix data
    ZMYear=zmixdata(:,1);
    ZMDOY=zmixdata(:,2);
    ZMzmix=zmixdata(:,3);
    ZMdate=datenum(ZMYear,1,0)+ZMDOY+(9/24); %assume profile was taken at 9am; 
    % this is a better assumption than assuming it was taken at midnight.
    
    %interpolate zmix data to sonde data; catch errors.
    if min(ZMdate)>min(SDdate)
            warning('cannot interpolate zmix data to sonde dates:  Sonde data begins before Zmix data');
    end
    if max(ZMdate)<min(SDdate)
            warning('cannot interpolate zmix data to sonde dates:  Zmix data ends before sonde data');
    end     
    SDzmix=interp1(ZMdate, ZMzmix, SDdate);    
else
    SDzmix=zmixdata*ones(length(SDdate),1); %vector of default zmix value entered by user
end

% **************************************************************************
%  Correct sonde DO %sat with calibration data
% *************************************************************************
if correctSondeData == 1   
%if remembering file names and 2nd or nth run
    if rememberFileNames==1 & runCount>0
        % read in data starting with 2nd row and first column (indices are zero-based)
        calexist=exist('cpathname','var');
        if calexist==1 %caldata loaded previously, load same file again
            caldata=csvread([cpathname cfilename],1,0);  
        else %have run program, but without correcting DO, need to choose file
            [cfilename,cpathname]=uigetfile('*.csv','Select calibration data file');
            caldata=csvread([cpathname cfilename],1,0); 
        end
    else % first run of program, or not remembering file names -- ask user to select file
            [cfilename,cpathname]=uigetfile('*.csv','Select calibration data file');
            caldata=csvread([cpathname cfilename],1,0);   
    end
    correctedDO=DOcorrect(caldata, sondedata); %uses DOcorrect.m function to correct data
    SDO2sat=correctedDO; %replaces raw DO with corrected DO
end

% **************************************************************************
%  Calculate k600 from Wind data
% *************************************************************************
% Load wind data and calculate k600.  Wind data cols are dayfrac, wind (m/s)
if calc_k600==1
    %if remembering file names and 2nd or nth run
    if rememberFileNames==1 & runCount>0
        % read in data starting with 2nd row and first column (indices are zero-based)
        windexist=exist('wpathname','var');
        if windexist==1
            winddata=csvread([wpathname wfilename],1,0);   
        else %have run program, but without calculating k600, need to choose file 
            [wfilename,wpathname]=uigetfile('*.csv','Select wind data file');
            winddata=csvread([wpathname wfilename],1,0); 
        end
    else % first run of program, or not remembering file names -- ask user to select file
        [wfilename,wpathname]=uigetfile('*.csv','Select wind data file');
        winddata=csvread([wpathname wfilename],1,0);   
    end
%    k600_calc=windToK600(winddata,SDdayfrac); %use windToK600 function to calculate k600
% > Imedea: Generalize the wind function to include year in the time vector
% > Imedea: Include the choice of different k660 formulations from K&K 2010
    k600_calc=windToK600_imedea(winddata,SDdate,windheight,ik660formulation); %use windToK600_imedea function to calculate k600
else
    k600_calc=k600*ones(length(SDdate),1); %create vector of default k600 value
end
%****************


% need to make deploymentIDs consecutive
OriginalDeployID=SDdeployID; %store original deployment numbers in case they're needed later
deployID=unique(SDdeployID);
for i=1:length(deployID)
    for j=1:length(SDdeployID)
        if SDdeployID(j)==deployID(i)
            SDdeployID(j,1)= i;
        end
    end
end
% **************************************************************************
% Calculate time of sunrise for day of year and latitude. 
% based on WisconsinLight.m from Jon Cole
% *************************************************************************
lat=lat/57.297; %lat converted to radians at Paul L. dyke, 57.297 = 180/pi
day=[1:366]';%day of year. could be read in from file
rads=2*pi*day/366; 
%dec is the declination of the sun f of day  Spencer, J.W. 1971: Fourier
%series representation of the position of the Sun. Search, 2(5), 172.
dec=0.006918-0.399912*cos(rads)+0.070257*sin(rads)...
    -0.006758*cos(2*rads)+0.000907*sin(2*rads)...
    -0.00297*cos(3*rads)+0.00148*sin(3*rads);
x=(-1*sin(lat)*sin(dec))./(cos(lat)*cos(dec));
%hours in radians before true noon of sunrise.
SR=(pi/2)-atan(x./(sqrt(1-x.^2))); 
SR=SR*2/.262; %converts SR from radians back to hours of daylight.
%need to adjust clock time which is in Central Daylight Savings time by 1 h.
dates=(1:366)';
sunrise=dates+(12-(SR*0.5)+1)./24; %Sunrise in hours Central Daylight Savings time
sunset=dates+(12+(SR*0.5)+1)./24;	%Sunset in CDST
sunrise=sunrise+datenum(SDYear(1),1,0);  % Format at a Matlab Date/Time
sunset=sunset+datenum(SDYear(1),1,0);    % Format at a Matlab Date/Time
hsunrise=(12-(SR*0.5)+1); % Hour of sunrise for each year day - IMEDEA
hsunset=(12+(SR*0.5)+1);% Hour of sunset for each year day - IMEDEA
datesunrise=floor(SDdate)+interp1(1:366,hsunrise,SDDOY)/24; % Date at which sunrise starts - IMEDEA
datesunset=floor(SDdate)+interp1(1:366,hsunset,SDDOY)/24; % Date at which sunset starts - IMEDEA
clear albedo cloudiness lat day rads dec x SR
%**************************************************************************
% calculate oxygen in mg/L from percent saturation, where percent sat in data is 
% relative to sea level and formula below uses saturation value at sea level to 
% get true O2 concentration in mg/L.  
SDO2mgL=(SDO2sat./100).*(-0.00000002057759.*SDtemp.^5 + 0.000002672016.*SDtemp.^4 ...
+ -0.0001884085.*SDtemp.^3 + 0.009778012.*SDtemp.^2 + -0.4147241.*SDtemp + 14.621);

% -> Imedea : New equation to include salinity
SDO2mgL=(SDO2sat./100).* (14.6244 - 0.367134.*SDtemp + 0.0044972.*SDtemp.^2 ...
    - 0.0966.* SDsal + 0.00205.* SDsal .* SDtemp + 0.0002739.* SDsal.^2);

% change units to uM
SDO2uM=SDO2mgL.*1000./(15.999*2);

% *************************************************************************
%  BEGIN METABOLISM CALCULATIONS
% *************************************************************************
M_all=[]; %create empty matrix to store metabolism values
% (1) iterate through each deployment, calculate gasflux and the change in
% oxygen due to biology (R at night, NEP during the day)
firstdeploy=min(SDdeployID);
lastdeploy=max(SDdeployID);

for i=firstdeploy:lastdeploy
   % find the rows in the full dataset that correspond to deployment i:
   rows_in_deployment_i=find(SDdeployID==i); 
   first_row=min(rows_in_deployment_i);
   last_row=max(rows_in_deployment_i);
   % select data corresponding deployment i
   n=length(rows_in_deployment_i);  % number of intervals in deployment
   DOY=SDDOY(first_row:last_row);   % Day of Year
   time=SDdate(first_row:last_row); % date AND time as a serial number in days
   zmix=SDzmix(first_row:last_row); % zmix in meters
   temp=SDtemp(first_row:last_row); % water temperature in degrees celcius
   sal=SDsal(first_row:last_row);
   O2=SDO2uM(first_row:last_row);   % Oxygen concentration in uM=mmol*(m^-3))
   k600j=k600_calc(rows_in_deployment_i); %create a vector of k600
   
   %calculate Schmidt number for O2 from temperature.
   %schmidt=(1800.6-120.1*temp)+(3.7818*temp.^2)-0.047608*temp.^3;
   % IMEDEA Version - modifying the Schmidt number for salty water
   schmidt=(1953.4-128*temp)+(3.998*temp.^2)-0.050091*temp.^3;

   % Calculate saturation O2 based on dynamic temperature and typical
   % atm. pressure at UNDERC.
   atmpressure=Patm * 760; % typical pressure at UNDERC based on altitude, mmHg
   O2sat=o2saturation(temp, sal); % umol/kg 
   dens=density(sal,temp);
   O2sat=O2sat./dens; %uM      
         
   % Calculate changes in oxygen concentration and time
   dO2=diff(O2);%[(O2 at t2)-(O2 at t1)]
   dt=diff(time).*1440;%change in time in minutes
       
   %calculate k for O2 from k600 and Sc from Wanninkhoff 1992
   %kO2 is in units of m/day
   kO2=k600j.*(schmidt/600).^-0.5; %Jahne et al. 87. exp could also be -.67
   kO2=kO2./(1440);   %change kO2 to units of m/minute
   
   % Account for gasflux, calculate metabolism value
   dO2dt=dO2./dt;%UNITS: mmol*(m^-3)*(minute^-1)
   gasflux=kO2.*(O2sat-O2); %UNITS:mmol*(m^-2)*(minute^-1)
   gasflux(1,:)=[]; zmix(1,:)=[];
   m=((dO2dt).*(zmix))- gasflux;%UNITS:mmol*(m^-2)*(minute^-1) from NEP calculation NEP=AO2-D
   dO2term=(dO2dt).*(zmix);
   
  

figure(90)
   xtime=time;xtime(1)=[];
   xtime = datetime(xtime,'ConvertFrom','datenum');
   plot(xtime,(dO2dt).*(zmix),xtime,gasflux);legend('(dO_2/dt)·z_m_i_x','gas flux');dateaxis('x',2);
   ylabel('(mmol m^-^2 day^-^1)');
   
pause
     %Create a matrix of time, temperature, and metabolism values (R or NEP) from 
   %this deployment (i)   
   time(1,:)=[]; temp(1,:)=[];kO2(1,:)=[]; DOY(1,:)=[];   
   M_i=[DOY time temp m kO2 zmix];
   M_all=[M_all;M_i];
   
end %end deployment loop

%Clear variables so they can be reassigned for complete data set
clear time temp k DOY ;

% unpack variables from the storage matrix
DOY=M_all(:,1); 
time=M_all(:,2);%all midtime values from splined data set
temp=M_all(:,3);
metabolism=M_all(:,4);%all 'metabolism' values from splined data set
k=M_all(:,5);
zmix=M_all(:,6);
%------------------------------------------------------------------------------------
%Calculate 24hour RESPIRATION (R24)
% IMEDEA> We also save in a matrix the night respiration along with
% temperature and date
% IMEDEA> Modification of identification of idarkhours/idayhours
%------------------------------------------------------------------------------------
dailyR24=[];
dailyGF24=[];
dailyDO24=[];
RToutput=[];
RToutputdaily=[];
%for j=min(SDDOY):max(SDDOY) %Days for which we have data
hsunset=repmat(hsunset,2,1);
hsunrise=repmat(hsunrise,2,1);
icont=0;
for xday=min(floor(time)):max(floor(time)) %Days for which we have data ! IMEDEA
    %for each day, find the rows (i_darkhours) in M_all matrix that are during the
    %night of day j and early morning of day j+1.  (1hr after sunset to 1hr before
    %sunrise) These will be used to calculate Respiration.
    icont=icont+1;
    stt=datevec(xday);
    year=stt(:,1);
    j=floor(xday-datenum(year,1,0));
    kdatesunset=floor(xday)+(hsunset(j)+1)/24;
    kdatesunrise=floor(xday+1)+(hsunrise(j+1)-1)/24;
    
    i_darkhours=find(time>=kdatesunset & time<=kdatesunrise);

   if length(i_darkhours) > 0 %Do the following only if we have data for the night      
      timestart=min(time(i_darkhours));
      DOYstart=min(DOY(i_darkhours));
      %Find the mean R per nighttime minute and multiply by 1440 to get R24
      R24j=(mean(metabolism(i_darkhours)).*1440);
      GF24j=(mean(gasflux(i_darkhours)).*1440);
      DO24j=(mean(dO2term(i_darkhours)).*1440);
      %create a matrix of DOY and R24 for day j
      Rj=[DOYstart R24j];
      GFj=[DOYstart GF24j];
      DOj=[DOYstart DO24j];
      dailyR24=[dailyR24;Rj];
      dailyGF24=[dailyGF24;GFj];
      dailyDO24=[dailyDO24;DOj];
      dum=[time(i_darkhours) temp(i_darkhours) metabolism(i_darkhours)*1440];
      RToutput=[RToutput; dum];
      dum=nanmean([time(i_darkhours) temp(i_darkhours) metabolism(i_darkhours)*1440],1);
      RToutputdaily=[RToutputdaily; dum];
  end
end
clear j
%------------------------------------------------------------------------------------
% Calculate total NEP during daylight hours (dailyNEP)
%------------------------------------------------------------------------------------
dailyNEP=[];
%for j=min(SDDOY):max(SDDOY) %Days for which we have data
icont=0;
for xday=min(floor(time)):max(floor(time)) %Days for which we have data ! IMEDEA
    %for each day, find the rows (i_darkhours) in M_all matrix that are during the
    %night of day j and early morning of day j+1.  (1hr after sunset to 1hr before
    %sunrise) These will be used to calculate Respiration.
    icont=icont+1;
    stt=datevec(xday);
    year=stt(:,1);
    j=floor(xday-datenum(year,1,0));
    kdatesunset=floor(xday)+(hsunset(j)+1)/24;
    kdatesunrise=floor(xday)+(hsunrise(j+1)-1)/24;
     %between sunrise and sunset
      i_daylighthours=find(time>=kdatesunrise & time<=kdatesunset);   %For each day, find the rows (i_daylighthours) that correspond to data obtained
%    i_daylighthours = find((sunrise(j))< time & time < (sunset(j)));
   
   %Find rows that correspond to all data from 0000hrs to 2400hrs on DOY j
%    i_wholeday=find(time > (j+datenum(SDYear(1),1,0)) & time < (j+datenum(SDYear(1),1,0)+1));
   i_wholeday=find(time > xday & time < (xday+1));
      
   if length(i_daylighthours)>0; %do this only if data exists for DOY j
      timestart=min(time(i_daylighthours));
      DOYstart=min(DOY(i_daylighthours));
      daylight_hours=((sunset(j)-sunrise(j))*24);%calculate daylight hours for day j
      meantemp24=mean(temp(i_wholeday));%calculate mean temperature for entire day
      meantempday=mean(temp(i_daylighthours));%calculate mean temperature for dayligh
      meank=mean(k(i_wholeday)); % mean k for DOYj; for output to 12box model
      
      if (timestart-sunrise(j))<(4/24) % if sonde deployed within 4 hours of sunrise 
         %find all metabolism values for daylight hours
         NEPperMinute=(metabolism(i_daylighthours));
         %average NEP values and multiply by 60 to get hourly NEP.
         meanNEPperHour=(mean(NEPperMinute)*60);
         %multiply hourlyNEP by daylight hours for daylightNEPj
         NEPdaylightj=meanNEPperHour.*daylight_hours;
         NEPj=[DOYstart daylight_hours NEPdaylightj meantemp24 meank 1 meantempday];
      else
         % sonde was deployed mid-day.  Not a full days worth of data insert NaN
         NEPj=[DOYstart daylight_hours NaN meantemp24 meank 1 meantempday];         
      end
      dailyNEP=[dailyNEP;NEPj];
   end
end


%------------------------------------------------------------------------------------
%average R24 values calculated from night before and night after a given day j
%to be used to calculate GPP
%------------------------------------------------------------------------------------
avg_R24=[]; dailyzmix=[];
for j=min(SDDOY):max(SDDOY)
   %find row, i, containing R24 value from night before DOY j
   i_dailyR24_before=find(dailyR24(:,1)==(j-1));
   %find row, i, containing R24 value from night of DOY j
   i_dailyR24_after=find(dailyR24(:,1)==j);
   
%    meanmeanR24=((dailyR24(i_dailyR24_before,2)+dailyR24(i_dailyR24_after,2))/2);
%    BIEL 4/19 -substitute the mean computation. This is more robust
   meanmeanR24=nanmean([dailyR24(i_dailyR24_before,2) dailyR24(i_dailyR24_after,2)]);
   
   %-------------------------------------------------------------------------------
   %'if tree' to get correct R24 value to use to calculate GPP for a given DOY
   %-------------------------------------------------------------------------------
   % If data exists for at least one of the nights...
   if (length(i_dailyR24_before)==1 || length(i_dailyR24_after)==1)
      %AND if data exists for both nights...
      if (length(i_dailyR24_before)==1 && length(i_dailyR24_after)==1)
         %Then average the two R24 values as a new R24 for DOY i
         avg_R24_j=((dailyR24(i_dailyR24_before,2)+dailyR24(i_dailyR24_after,2))/2);
         
      %If data ONLY exists for one or other of the nights (NOT both)...
      %more specifically, if data only exists for the night before...
      else if (length(i_dailyR24_before)==1 && length(i_dailyR24_after)~=1)
            %the 'average' value is set to the value of the night before
            avg_R24_j=dailyR24(i_dailyR24_before,2);
                        
         %If data only exists for the night after set the 'average' to that value   
         else if (length(i_dailyR24_after)==1 && length(i_dailyR24_before)~=1)
               avg_R24_j=dailyR24(i_dailyR24_after, 2);
            end
         end
      end
      
      %average zmix for each day to use for calculating volumetric metab
      dailyzmix_j=[j mean(zmix(find(DOY==j)))]; 
      
      %Create a vector('AVG_R24_i') with the new averaged R24 values and DOY i
      AVG_R24_j=[j avg_R24_j];
      avg_R24=[avg_R24;AVG_R24_j];
      dailyzmix=[dailyzmix;dailyzmix_j]; %store daily zmix values
   end
 end
%------------------------------------------------------------------------------------
%Create an output matrix and write to a file
%------------------------------------------------------------------------------------
%need to match up R and NEP by day, and remove any days of R where there is
%no NEP.  This occurs sometimes if no data during day X, but there is
%during night X.  It causes an error when calculating daylightR.
i=1;
if length(avg_R24)~=length(dailyNEP)
    while i <= size(avg_R24,1)
       if avg_R24(i,1)~=dailyNEP(i,1)
            avg_R24(i,:)=[];  
            dailyzmix(i,:)=[];
       end
        i=i+1;
    end
end

% IMEDEA - SHOW A PLOT OF NIGHT TEMPERATURE VS RESPIRATION AND FIT A
% LINEAR CURVE
for ifitcase=1:2
    if ifitcase==1;
        dum_t=RToutput(:,2);
        dum_r=RToutput(:,3);
        xtit='High frequency data';
    elseif ifitcase==2;
        dum_t=RToutputdaily(:,2);
        dum_r=RToutputdaily(:,3);
        xtit='Daily data';
    end
    
    if length(dum_t)>2
    %     [B]=bootstrp(100,@robustfit,RToutput(:,2),RToutput(:,3));
    %     M=mean(B(:,1));
    [K]=robustfit(dum_t,dum_r);
    RFIT=dum_t*K(2)+K(1);
    if showfigures==1

        figure(50+ifitcase-1),clf
        plot(dum_t,dum_r,'.', 'MarkerSize',12,  'Color', rgb ('DarkBlue'))
        xlabel('Temperature (ºC)')
        ylabel('Night Respiration')
        hold on,plot(dum_t,RFIT,'Color', rgb ('Orange'), 'LineWidth', 1.5);hold off
        iok=find(~isnan(dum_r+RFIT));
        cdum=corrcoef(RFIT(iok),dum_r(iok));
        legend(sprintf('r = %4.2f',cdum(1,2)));
        title(['Temp vs Resp ' xtit],'fontsize',14,'fontweight','bold')

    end
    if ifitcase==2;
        KFIT=K; % 
    end
    else % BIEL 4/19
        disp('--------------------------------------')
        disp('  ONLY 1 DAY OF DATA , NO FIT PERFORMED')
        disp('--------------------------------------')
        KFIT=[NaN NaN];
    end
end
YEAR=sondedata(:,1);
DOY=dailyNEP(:,1);
daylight=dailyNEP(:,2);
NEPlight=dailyNEP(:,3);
R24=avg_R24(:,2);
mean24htemp=dailyNEP(:,4);
meandaytemp=dailyNEP(:,7);
stdum=datevec(RToutputdaily(1,1));

if size(RToutputdaily,1)>1 ; % BIEL 4/19
    meannighttemp=interp1(RToutputdaily(:,1)-datenum(stdum(1),1,1),RToutputdaily(:,2),DOY);
else
           disp('--------------------------------------')
        disp('  ONLY 1 DAY OF DATA , meannighttemp set to the avilable value')
        disp('--------------------------------------')
     meannighttemp=RToutputdaily(:,2);
end

R24night=R24.*(24-daylight)/24;
disp('***************************************+')
if daylightRoption==1 
    disp('  Assuming Daylight respiration = Night Respiration')
    daylightR=(R24./24).*daylight;
elseif daylightRoption==2
    disp('  Computing Daylight respiration as a function of temperature')
    daylightR=(meandaytemp*KFIT(2)+KFIT(1))/24.*daylight;
elseif daylightRoption==3
    disp('  Computing Daylight respiration as a function of temperature - version 2')
    dayRfunT=(meandaytemp*KFIT(2)+KFIT(1))/24.*daylight;
    nightR=(meannighttemp*KFIT(2)+KFIT(1))/24.*daylight;
    realR=(R24./24).*daylight;
    daylightR=dayRfunT+realR-nightR;
end
R24day=daylightR;
% BIEL 4/19   pause
disp('***************************************+')
GPP=NEPlight-daylightR;
NEPtrue=GPP+R24;
kO2=(dailyNEP(:,5)).*1440; %convert back to m*d^-1

%need to excise out any NaNs
metab = [DOY GPP R24 NEPtrue dailyzmix(:,2) kO2];
metab = excise(metab);

%areal means for entire deployment
mGPP=mean(metab(:,2)); %mmol m^-2 d^-1
mR24=mean(metab(:,3));
mNEP=mean(metab(:,4));

if size(metab,1)>1 % BIEL 4/19
    aenStd=std(metab,1);
else
   disp('Only one day of data, STD copmputation makes no sense')
   aenStd=metab;
end
mtemp=mean(excise(temp));

%volumetric means for entire deployment (divide by zmix) - mmol m^-3 d^-1
vmetab=[metab(:,1) metab(:,2)./metab(:,5) metab(:,3)./metab(:,5) metab(:,4)./metab(:,5)];
mvGPP=mean(metab(:,2)./metab(:,5));
mvR24=mean(metab(:,3)./metab(:,5));
mvNEP=mean(metab(:,4)./metab(:,5));
venGPP=std(metab(:,2)./metab(:,5));
venR24=std(metab(:,3)./metab(:,5));
venNEP=std(metab(:,4)./metab(:,5));

meanOutput=[mGPP mR24 mNEP aenStd(:,2:4) mvGPP mvR24 mvNEP venGPP venR24 venNEP];
       
%**************************************************************************
%Display Results to Command Window                                        *
%**************************************************************************
warning off MATLAB:nonIntegerTruncatedInConversionToChar
disp(' ');disp(sfilename);
heading=char('','','GPP   ','R24   ','NEP   ');
areal=char('areal:','mmol*m^-2*d^-1  ', sprintf('%0.4g',mGPP),sprintf('%0.4g',mR24),sprintf('%0.2f',mNEP));
volumetric=char('volumetric:','mmol*m^-3*d^-1   ',sprintf('%0.4g',mvGPP),sprintf('%0.4g',mvR24),sprintf('%0.4g',mvNEP));
aStd=char('std       ','', sprintf('%0.4g',aenStd(2)),sprintf('%0.4g',aenStd(3)),sprintf('%0.4g',aenStd(4)));
vStd=char('std','',sprintf('%0.4g',venGPP),sprintf('%0.4g',venR24),sprintf('%0.4g',venNEP));
entiredeploy=[heading areal aStd volumetric vStd];
disp(entiredeploy);
warning on MATLAB:nonIntegerTruncatedInConversionToChar

%**************************************************************************
%Create OUTPUT matrix with all data - daily values
OUTPUT=[DOY GPP R24 NEPtrue mean24htemp kO2];
OUTPUT = excise(OUTPUT);
OUTPUT2=[DOY R24 R24day R24night mean24htemp meandaytemp meannighttemp daylight];
OUTPUT2 = excise(OUTPUT2);
if savefile==1
    [savefilename,savepathname] = uiputfile('*.csv','Save Data As');
    savedfilename=[savepathname savefilename];
    fid=fopen(savedfilename,'w'); %open file for writing
    fprintf(fid,'%s\n','DOY, GPP, R24, NEP, Mean24hTemp, k02');
    fprintf(fid, '%f,%f,%f,%f,%f,%f\n',OUTPUT');
    fclose(fid);
    disp(' ');disp(['File saved as:', savedfilename]);
    
    [savefilename,savepathname] = uiputfile('*.csv','Save Respiration and temperature information');
    savedfilename=[savepathname savefilename];
    fid=fopen(savedfilename,'w'); %open file for writing
    fprintf(fid,'%s\n','DOY, R24, Rday, Rnight, Mean24hTemp, MeanDayTemp,MeanNightTemp, Hoursofdaylight ');
    fprintf(fid, '%f,%f,%f,%f,%f,%f,%f,%f\n',OUTPUT2');
    fclose(fid);
    disp(' ');disp(['File saved as:', savedfilename]);
end
%------------------------------------------------------------------------------------
%Create figures
%------------------------------------------------------------------------------------
if showfigures==1  
    figuretitle=sfilename; 
    %set figure size (fill top half of screen)
    bdwidth=5; topbdwidth=90;
    set(0,'Units','pixels')
    scnsize=get(0,'ScreenSize');
    pos1=[bdwidth, 1/2*scnsize(4) + bdwidth, scnsize(3)-2*bdwidth, ...
          scnsize(4)/2-(topbdwidth+bdwidth)];

    figure('Position',pos1)
    clf
    plot(DOY, GPP,'-s','MarkerSize',10,'MarkerEdgeColor','Black','MarkerFaceColor', rgb ('PaleGreen'), 'Color', ...
       rgb ('DarkGreen'),'LineWidth',1.75); dateaxis('x',6);
    hold on;
    plot(DOY, NEPtrue,'-s','MarkerSize',10,'MarkerEdgeColor','Black','MarkerFaceColor', rgb ('LightSkyBlue'), 'Color', ...
        rgb ('DodgerBlue'), 'Linewidth',1.75); dateaxis('x',6);
   hold on;
    plot(DOY, R24,'-s','MarkerSize',10,'MarkerEdgeColor','Black','MarkerFaceColor', rgb ('Bisque'), 'Color', rgb ('Orange'), ...
      'LineWidth',1.75); dateaxis('x',6);
    hold on
    plot([min(SDDOY) max(SDDOY)], [0 0], 'k-')
    xlabel('Date','FontSize',16);
    ylabel('Oxygen: mmol m^{-2} day^{-1}','FontSize',16);

     title(figuretitle,'Interpreter','none','FontSize',18); %interpreter none turns off
    % the feature that interprets '_' as subscript and '^' as superscript, etc.

    legend('GPP','NEP','R24','fontsize',12);

    clear bdwidth pos1 scnsize topbdwidth;
    
   
end
runCount=1; %marks as run for remembering file names

DO=sondedata(:,5);
figure;
plot(SDdate,DO, 'Linewidth', 1, 'Color', rgb ('DarkBlue')); dateaxis('x',2);ylabel('(O_2 Saturation %)',FontSize=12);
ylim([65 145]);...
title('Dissolved Oxygen Saturation %',FontSize=18); yline(100,'--','Saturated');


