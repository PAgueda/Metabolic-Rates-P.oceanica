%This script has been used to build monthly series plots of metabolism
%calculations from measurements by CTD devices. The secondary y axis is
%used to plot a time series of temperature measured by CTD.

Datos=readtable('CT_time_series.xlsx'); %Input is an Excel file with date, GPP, R24 and NEP daily calculations.
date=(Datos{:,2});
CT_GPP=(Datos{:,4});
CT_R24=Datos{:,5};
CT_NEP=Datos{:,6};

%timetable/retime functions to obtain monthly mean and SD of metabolic
%parameters. Do it for GPP, R24 and NEP. It will create several table files
%that need to be concatenated manually and saved (in our case) as 'CT_input_correct.xlsx'
%to be used later
timevals1=datetime(date);
GPP_ts=timetable( timevals1,CT_GPP,'VariableNames',{'GPP'});
GPP_SD=retime(GPP_ts,'monthly',@std);
GPP_mean=retime(GPP_ts,'monthly','mean');

R24_ts=timetable( timevals1,CT_R24,'VariableNames',{'R24'});
R24_SD=retime(R24_ts,'monthly',@std);
R24_mean=retime(R24_ts,'monthly','mean');

NEP_ts=timetable( timevals1,CT_NEP,'VariableNames',{'NEP'});
NEP_SD=retime(NEP_ts,'monthly',@std);
NEP_mean=retime(NEP_ts,'monthly','mean');

%Set the time in x axis. Monthly data.
t=datetime(['1-Oct-2019';'1-Nov-2019';'1-Dec-2019';'1-Jan-2020';'1-Feb-2020';'1-Mar-2020';'1-Apr-2020';
    '1-May-2020';'1-Jun-2020';'1-Jul-2020';'1-Aug-2020';'1-Sep-2020';'1-Oct-2020';'1-Nov-2020';
    '1-Dec-2020';'1-Jan-2021';'1-Feb-2021';'1-Mar-2021';'1-Apr-2021';'1-May-2021';'1-Jun-2021';
    '1-Jul-2021';'1-Aug-2021';'1-Sep-2021';'1-Oct-2021']);
y1=GPP_mean(:,1);

%Input of the file with all CTD measurements (2019, 2020 and 2021 in our case)
%of time and temperature (T).
CTD=readtable('CTD_raw.xlsx');
time=CTD{:,1};
T=CTD{:,2};



CT = readtable('CT_input_correct.xlsx');    %Excel file with time (1), GPP mean and SD (2 and 3),
% R24 mean and SD (4 and 5), NEP mean and SD (6 and 7) as columns, with data obtained using timetable/retime.
GPP_CT_mean=CT{:,2};
GPP_CT_SD=CT{:,3};
R24_CT_mean=CT{:,4};
R24_CT_SD=CT{:,5};
NEP_CT_mean=CT{:,6};
NEP_CT_SD=CT{:,7};


%Errorbar plots with monthly GPP, R24 and NEP mean and SD values, and daily
%temperature plot.
figure;
subplot(3,1,1);
errorbar(t,GPP_CT_mean,GPP_CT_SD, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
title('GPP',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
yline(0,'--',' ');
set(gca,'XTickLabel',[],'XGrid','on','XMinorGrid','on','GridColor','black');
ylim([-400 400])
xticklabels auto
hold on;
yyaxis right;
set(gca,'YTickLabel',[15 20 25 30],'YColor','black');
plot(time,T,'Color',rgb('DarkBlue'));
legend('Metabolism', 'Temperature (ºC)', Location='northwest')
ylabel('ºC','Rotation',0)
xlim(['1-Oct-2019' '1-Oct-2021'])

subplot(3,1,2);
errorbar(t,R24_CT_mean,R24_CT_SD, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor', rgb ('FireBrick'),'MarkerSize',8);
title('R24',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
yline(0,'--',' ');
set(gca,'XTickLabel',[],'XGrid','on','XMinorGrid','on','GridColor','black');
ylim([-400 400])
xticklabels auto
hold on;
yyaxis right;
set(gca,'YTickLabel',[15 20 25 30],'YColor','black');
plot(time,T,'Color',rgb('DarkBlue'));
legend('Metabolism', 'Temperature (ºC)', Location='northwest')
ylabel('ºC','Rotation',0)
xlim(['1-Oct-2019' '1-Oct-2021'])

subplot(3,1,3);
errorbar(t,NEP_CT_mean,NEP_CT_SD, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor', rgb ('FireBrick'),'MarkerSize',8);
title('NEP',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
yline(0,'--',' ');
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black')
ylim([-400 400])
xticklabels auto
hold on;
yyaxis right;
set(gca,'YTickLabel',[15 20 25 30],'YColor','black');
plot(time,T,'Color',rgb('DarkBlue'));
legend('Metabolism', 'Temperature (ºC)', Location='northwest')
ylabel('ºC','Rotation',0)
xlim(['1-Oct-2019' '1-Oct-2021'])


