% Author: Josefina Algotsson, SPO at SMHI
% Contact: josefina.algotsson@smhi.se
% Date: 2017-11-28
%
% This script plots all stations and the whole time series for ome Omrade.
% If the user want, it can also plot all or some stations for a specific
% event.

clear
close all
%---------------------------edit-------------------------------------------
stationsFile='KattegattStations'; % File containing station names in Omrade
set(0,'defaultaxeslinestyleorder',{'-','--','--.'}) 
stations = [1:4,6:13];    % Row number in excel file of stations you want to 
                          % plot together
events = 1;         % Set to 1 if you want to plot selected max event 
                    % for a station along with the station sea-levels
event_number = 2;   % Selected max event number
deciding_station = 'FALKENBERG 2 SJÖV';    % Name  without file-extension of station you
                                           % want to show events for
savestuff = 1;  
tick_use=[];
app = 'KattFalkEvent';                      % How to name figures
%--------------------------------------------------------------------------
tic
load(stationsFile)
% Find row in Område file where deciding station is
IndexC = strfind(F_TXT, deciding_station);
Index = find(not(cellfun('isempty', IndexC)));

figure
% For all stations in Omrade
for n =stations
    p = strfind(F_TXT{n},'.');                  % Format string to load station file
    load(['ExportStatMat/',F_TXT{n}(1:p-1)])    % Load mat file with data from one station
    plot(U_DAT,U_HEIGHT)                        % Plot time against water height
    hold on
end

% Circle the maximum events
load(['ExportEventSeries/',stationsFile(1:end-8),deciding_station,'eventsSeries'])
plot(exportEvents(1,:),exportEvents(2,:),'ok')

if events 
% For all events 
    for e = 1:size(eventHeight,2)
        set(gca, 'ColorOrder', circshift(get(gca, 'ColorOrder'), length(stations)))
        % Put stars in matching colors for all stations on that event
        for s = stations
            plot(eventTime{s,e},eventHeight{s,e},'*');
            % If we handle the event number we want to see
            if e==event_number
                % collect time stamps from all stations
                tick_use(end+1:end+length(eventTime{1,e}),1)=eventTime{s,e};
            end
        end
             
    end
    % Set xlim to show all stations data from the specific event
    limita=[min(tick_use) max(tick_use)];
    % Use only the unique time stamps as ticks
    tick_use= sort(unique(tick_use));
    % Set ticks
    set(gca,'xtick',tick_use,'xlim',limita)
    % Make it datetick
    datetick(gca,'x','hh','keepticks','keeplimits')
    title(['Event ',datestr(exportEvents(1,event_number),'dd-mmm-yyyy')])
    % Plot maximum events again to show better
    plot(exportEvents(1,:),exportEvents(2,:),'ok')
end
grid on
ylabel('Sea level [cm]')
xlabel('Time')
legend(F_TXT{stations},'location','northeastoutside')

if savestuff
    set(gcf,'position',[710 543 1135 420],'color','w') % Make figure a nice size
    savefig(['Figures/OmradeEvent/',app,num2str(event_number),'.fig'])
    export_fig(gcf,['Figures/OmradeEvent/',app,num2str(event_number)],'-pdf')
end
toc
% Useful extra code
% datetick(gca,'x','dd/mm/YYYY','keeplimits')
% datevec(cursor_info.Position)

