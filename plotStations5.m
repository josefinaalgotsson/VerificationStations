% Author: Josefina Algotsson, SPO at SMHI
% Contact: josefina.algotsson@gmail.com
% Date: 2017-11-29
%
% This script loads the matrix contianing water height during each event
% and plots and compares them

clear
close all

%---------------------------edit-------------------------------------------
% File containing station names in Omrade
eventsFile='KattegattFALKENBERG 2 SJÖVeventsSeries';
set(0,'defaultaxeslinestyleorder',{'-o','--o','--.'}) %or whatever you want
%--------------------------------------------------------------------------
% Load file containing time series for events
load(['ExportEventSeries/',eventsFile]);
% Generate correlation coefficients for each event
for ev = 1:size(eventHeight,2) %For each event
    % Collect all sea-level series for one event and put in A
    A{1,ev} = cell2mat(eventHeight(:,ev)');
    % Calculate the correlation coefficient and significance for the event
    [R{1,ev}, P{1,ev}] = corrcoef(A{1,ev},'Rows','Complete');
    R{1,ev}= abs(R{1,ev});  % Correlation coefficient
    P{1,ev}= P{1,ev};       % Significance level
    P{1,ev}(P{1,ev}>0.05) = nan; % Non significant cells are nan
end

% Plot the events
for e = 1:size(eventHeight,2) % for all events
    % Plot the sea level of all stations against the time series of the
    % deciding station
    figure(e)
    plot(eventTime{10,e},cat(2,eventHeight{:,e}))
    grid on
    legend(F_TXT,'location','eastoutside')
    
    figure(e+10)
    % Take correlation coefficients of that event
    data = R{1,e};
    imAlpha=ones(size(data));
    imAlpha(isnan(data))=0;
    imagesc(data,'AlphaData',imAlpha);
    grid on
    caxis([0 1])
    
    
    figure(e+20)
    % Take significance level 
    data2 = P{1,e};
    imAlpha2=ones(size(data2));
    imAlpha2(isnan(data2))=0;
    imagesc(data2,'AlphaData',imAlpha2);
    caxis([0.005 0.05])
    grid on
end
% Put datetick and ticklabels according to stationposition
for e = 1:size(eventHeight,2) % for events
    figure(e)
    title(['Event ', datestr(exportEvents(1,e),'dd-mmm-yyyy')])
    xlabel('Time')
    ylabel('Sea level [cm]')
    tick_use=eventTime{10,e};
    set(gca,'xtick',tick_use)
    datetick(gca,'x','hh','keepticks')
    set(gcf,'position',[710 543 1135 420],'color','w')
    savefig(['Figures/Correlation/','Figure',num2str(e),'.fig'])
    export_fig(gcf,['Figures/Correlation/','Figure',num2str(e)],'-pdf')
    
    figure(e+10)
    xticks([1:size(eventHeight,1)])
    labels = char (F_TXT);
    labels = labels(:,1:4);
    xticklabels(labels)
    yticks([1:size(eventHeight,1)])
    yticklabels(labels)
    title(['Correlation ', datestr(exportEvents(1,e),'dd-mmm-yyyy')])
    colorbar
    xtickangle(45)
    set(gcf,'color','w')
    savefig(['Figures/Correlation/','Figure',num2str(e+10),'.fig'])
    export_fig(gcf,['Figures/Correlation/','Figure',num2str(e+10)],'-pdf')
    
    figure(e+20)
    xticks([1:size(eventHeight,1)])
    labels = char (F_TXT);
    labels = labels(:,1:4);
    xticklabels(labels)
    yticks([1:size(eventHeight,1)])
    yticklabels(labels)
    title(['Significance ', datestr(exportEvents(1,e),'dd-mmm-yyyy')])
    colorbar
    xtickangle(45)
    set(gcf,'color','w')
    savefig(['Figures/Correlation/','Figure',num2str(e+20),'.fig'])
    export_fig(gcf,['Figures/Correlation/','Figure',num2str(e+20)],'-pdf')
   
end




