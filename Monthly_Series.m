% The present script was used to build plots with daily metabolism data
% (GPP, R24, NEP) obtained as output from the 'Corrected_Metabolism2005_barebones_imedea_v4_SFS'
% script, working with measurements by CTD and hydrolab.

% Input date, GPP, R24, NEP by CTD and Hydrolabs for each month.
Feb_2020=readtable('Feb_2020.xlsx');
Feb=Feb_2020{:,1};
GPP_HL_Feb_2020=Feb_2020{:,5};
R24_HL_Feb_2020=Feb_2020{:,6};
NEP_HL_Feb_2020=Feb_2020{:,7};
GPP_CT_Feb_2020=Feb_2020{:,2};
R24_CT_Feb_2020=Feb_2020{:,3};
NEP_CT_Feb_2020=Feb_2020{:,4};

GPP_HL_Feb_2020=str2double(GPP_HL_Feb_2020);
R24_HL_Feb_2020=str2double(R24_HL_Feb_2020);
NEP_HL_Feb_2020=str2double(NEP_HL_Feb_2020);


Aug_2020=readtable('Aug_2020.xlsx');
Aug=Aug_2020{:,1};
GPP_HL_Aug_2020=Aug_2020{:,5};
R24_HL_Aug_2020=Aug_2020{:,6};
NEP_HL_Aug_2020=Aug_2020{:,7};
GPP_CT_Aug_2020=Aug_2020{:,2};
R24_CT_Aug_2020=Aug_2020{:,3};
NEP_CT_Aug_2020=Aug_2020{:,4};

GPP_HL_Aug_2020=str2double(GPP_HL_Aug_2020);
R24_HL_Aug_2020=str2double(R24_HL_Aug_2020);
NEP_HL_Aug_2020=str2double(NEP_HL_Aug_2020);
GPP_CT_Aug_2020=str2double(GPP_CT_Aug_2020);
R24_CT_Aug_2020=str2double(R24_CT_Aug_2020);
NEP_CT_Aug_2020=str2double(NEP_CT_Aug_2020);

Nov_2020=readtable('Nov_2020.xlsx');
Nov=Nov_2020{:,1};
GPP_HL_Nov_2020=Nov_2020{:,5};
R24_HL_Nov_2020=Nov_2020{:,6};
NEP_HL_Nov_2020=Nov_2020{:,7};
GPP_CT_Nov_2020=Nov_2020{:,2};
R24_CT_Nov_2020=Nov_2020{:,3};
NEP_CT_Nov_2020=Nov_2020{:,4};

GPP_HL_Nov_2020=str2double(GPP_HL_Nov_2020);
R24_HL_Nov_2020=str2double(R24_HL_Nov_2020);
NEP_HL_Nov_2020=str2double(NEP_HL_Nov_2020);
GPP_CT_Nov_2020=str2double(GPP_CT_Nov_2020);
R24_CT_Nov_2020=str2double(R24_CT_Nov_2020);
NEP_CT_Nov_2020=str2double(NEP_CT_Nov_2020);

Jan_2021=readtable('Jan_2021.xlsx');
Jan=Jan_2021{:,1};
GPP_HL_Jan_2021=Jan_2021{:,5};
R24_HL_Jan_2021=Jan_2021{:,6};
NEP_HL_Jan_2021=Jan_2021{:,7};
GPP_CT_Jan_2021=Jan_2021{:,2};
R24_CT_Jan_2021=Jan_2021{:,3};
NEP_CT_Jan_2021=Jan_2021{:,4};

GPP_HL_Jan_2021=str2double(GPP_HL_Jan_2021);
R24_HL_Jan_2021=str2double(R24_HL_Jan_2021);
NEP_HL_Jan_2021=str2double(NEP_HL_Jan_2021);


May_2021=readtable('May_2021.xlsx');
May=May_2021{:,1};
GPP_HL_May_2021=May_2021{:,5};
R24_HL_May_2021=May_2021{:,6};
NEP_HL_May_2021=May_2021{:,7};
GPP_CT_May_2021=May_2021{:,2};
R24_CT_May_2021=May_2021{:,3};
NEP_CT_May_2021=May_2021{:,4};

GPP_HL_May_2021=str2double(GPP_HL_May_2021);
R24_HL_May_2021=str2double(R24_HL_May_2021);
NEP_HL_May_2021=str2double(NEP_HL_May_2021);

Jun_2021=readtable('Jun_2021.xlsx');
Jun=Jun_2021{:,1};
GPP_HL_Jun_2021=Jun_2021{:,5};
R24_HL_Jun_2021=Jun_2021{:,6};
NEP_HL_Jun_2021=Jun_2021{:,7};
GPP_CT_Jun_2021=Jun_2021{:,2};
R24_CT_Jun_2021=Jun_2021{:,3};
NEP_CT_Jun_2021=Jun_2021{:,4};

GPP_HL_Jun_2021=str2double(GPP_HL_Jun_2021);
R24_HL_Jun_2021=str2double(R24_HL_Jun_2021);
NEP_HL_Jun_2021=str2double(NEP_HL_Jun_2021);


Jul_2021=readtable('Jul_2021.xlsx');
Jul=Jul_2021{:,1};
GPP_HL_Jul_2021=Jul_2021{:,5};
R24_HL_Jul_2021=Jul_2021{:,6};
NEP_HL_Jul_2021=Jul_2021{:,7};
GPP_CT_Jul_2021=Jul_2021{:,2};
R24_CT_Jul_2021=Jul_2021{:,3};
NEP_CT_Jul_2021=Jul_2021{:,4};

GPP_HL_Jul_2021=str2double(GPP_HL_Jul_2021);
R24_HL_Jul_2021=str2double(R24_HL_Jul_2021);
NEP_HL_Jul_2021=str2double(NEP_HL_Jul_2021);

Sep_2021=readtable('Sep_2021.xlsx');
Sep=Sep_2021{:,1};
GPP_HL_Sep_2021=Sep_2021{:,5};
R24_HL_Sep_2021=Sep_2021{:,6};
NEP_HL_Sep_2021=Sep_2021{:,7};
GPP_CT_Sep_2021=Sep_2021{:,2};
R24_CT_Sep_2021=Sep_2021{:,3};
NEP_CT_Sep_2021=Sep_2021{:,4};

GPP_HL_Sep_2021=str2double(GPP_HL_Sep_2021);
R24_HL_Sep_2021=str2double(R24_HL_Sep_2021);
NEP_HL_Sep_2021=str2double(NEP_HL_Sep_2021);


%Build the figures comparing metabolic rates by CTD and Hydrolabs.
figure;
subplot(3,1,1);
plot(Feb,GPP_CT_Feb_2020,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(Feb,GPP_HL_Feb_2020, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('GPP',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim([-500 1000])

subplot(3,1,2);
plot(Feb,R24_CT_Feb_2020,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(Feb,R24_HL_Feb_2020, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('R24',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim([-600 600])
yticks([-600 -200 0 200 600])


subplot(3,1,3);
plot(Feb,NEP_CT_Feb_2020,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(Feb,NEP_HL_Feb_2020, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('NEP',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim([-600 600])
yticks([-600 -200 0 200 600])

figure;
subplot(3,1,1);
plot(Aug,GPP_CT_Aug_2020,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(Aug,GPP_HL_Aug_2020, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('GPP',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim ([-400 400])
yticks([-400 -200 0 200 400]);

subplot(3,1,2);
plot(Aug,R24_CT_Aug_2020,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(Aug,R24_HL_Aug_2020, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('R24',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim ([-400 400])
yticks([-400 -200 0 200 400]);

subplot(3,1,3);
plot(Aug,NEP_CT_Aug_2020,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(Aug,NEP_HL_Aug_2020, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('NEP',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim ([-400 400])
yticks([-400 -200 0 200 400]);

figure;
subplot(3,1,1);
plot(Nov,GPP_CT_Nov_2020,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(Nov,GPP_HL_Nov_2020, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('GPP',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim([-500 1000])
yticks([-500 0 500 1000]);

subplot(3,1,2);
plot(Nov,R24_CT_Nov_2020,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(Nov,R24_HL_Nov_2020, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('R24',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim([-500 1000])
yticks([-500 0 500 1000]);

subplot(3,1,3);
plot(Nov,NEP_CT_Nov_2020,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(Nov,NEP_HL_Nov_2020, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('NEP',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim([-500 1000])
yticks([-500 0 500 1000]);

figure;
subplot(3,1,1);
plot(Jan,GPP_CT_Jan_2021,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(Jan,GPP_HL_Jan_2021, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('GPP',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim([-200 1000])
yticks([-200 0 200 400 600 800 1000]);

subplot(3,1,2);
plot(Jan,R24_CT_Jan_2021,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(Jan,R24_HL_Jan_2021, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('R24',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim([-200 1000])
yticks([-200 0 200 400 600 800 1000]);

subplot(3,1,3);
plot(Jan,NEP_CT_Jan_2021,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(Jan,NEP_HL_Jan_2021, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('NEP',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim([-200 1000])
yticks([-200 0 200 400 600 800 1000]);

figure;
subplot(3,1,1);
plot(May,GPP_CT_May_2021,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(May,GPP_HL_May_2021, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('GPP',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim([-1000 1500])
yticks([-1000 -500 0 500 1000 1500]);

subplot(3,1,2);
plot(May,R24_CT_May_2021,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(May,R24_HL_May_2021, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('R24',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim([-1000 1500])
yticks([-1000 -500 0 500 1000 1500]);

subplot(3,1,3);
plot(May,NEP_CT_May_2021,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(May,NEP_HL_May_2021, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('NEP',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim([-1000 1500])
yticks([-1000 -500 0 500 1000 1500]);

figure;
subplot(3,1,1);
plot(Jun,GPP_CT_Jun_2021,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(Jun,GPP_HL_Jun_2021, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('GPP',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim([-500 500])
yticks([-500 -250 0 250 500]);

subplot(3,1,2);
plot(Jun,R24_CT_Jun_2021,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(Jun,R24_HL_Jun_2021, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('R24',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim([-500 500])
yticks([-500 -250 0 250 500]);

subplot(3,1,3);
plot(Jun,NEP_CT_Jun_2021,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(Jun,NEP_HL_Jun_2021, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('NEP',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim([-500 500])
yticks([-500 -250 0 250 500]);

figure;
subplot(3,1,1);
plot(Jul,GPP_CT_Jul_2021,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(Jul,GPP_HL_Jul_2021, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('GPP',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim([-1000 1000])
yticks([-1000 -500 0 500 1000]);


subplot(3,1,2);
plot(Jul,R24_CT_Jul_2021,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(Jul,R24_HL_Jul_2021, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('R24',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim([-1000 1000])
yticks([-1000 -500 0 500 1000]);

subplot(3,1,3);
plot(Jul,NEP_CT_Jul_2021,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(Jul,NEP_HL_Jul_2021, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('NEP',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim([-1000 1000])
yticks([-1000 -500 0 500 1000]);

figure;
subplot(3,1,1);
plot(Sep,GPP_CT_Sep_2021,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(Sep,GPP_HL_Sep_2021, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('GPP',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim ([-400 400])
yticks([-400 -200 0 200 400]);

subplot(3,1,2);
plot(Sep,R24_CT_Sep_2021,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(Sep,R24_HL_Sep_2021, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('R24',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim ([-400 400])
yticks([-400 -200 0 200 400]);

subplot(3,1,3);
plot(Sep,NEP_CT_Sep_2021,'-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('FireBrick'),'MarkerSize',8);
hold on; plot(Sep,NEP_HL_Sep_2021, '-s','Color','black','MarkerEdgeColor', rgb ('Black'), ...
    'MarkerFaceColor',rgb ('DarkBlue'),'MarkerSize',8);
set(gca,'XGrid','on','XMinorGrid','on','GridColor','black');
title('NEP',FontSize=12);
ylabel('mmol O_2 m^{-2} day^{-1}','FontSize',10);
hold on;
yline(0,'--',' ');
legend('CT', 'Hydrolab');
ylim ([-400 400])
yticks([-400 -200 0 200 400]);