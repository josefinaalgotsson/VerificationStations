% Author: Josefina Algotsson, SPO at SMHI
% Contact: josefina.algotsson@smhi.se
% Date: 2017-11-28
%
% This script loads water level data from mat file created in 
% loadStations and finds n events of maximum water height
% (considering one deciding station), exports a matrix with 4 rows and n 
% columns where the rows are datenum of the events, the water height of
% the event and the start and end date in datenums of the selected events. 
% The user can specify what station should be deciding the maximum events,
% and specify in days how long the period describing the event should be. 
clear all
close all

%---------------------------edit-------------------------------------------
% File containing station names in Omrade without extension
stationsFile='KattegattStations'; 
% Station with the shortest available time series and which will decide
% what monthly maximums are picked as maximum events. 
deciding_station = 'FALKENBERG 2 SJÖV.RW'; 
halfperiod = 10;% Number of days to include in search window
n_events = 5;   % Number of max events you want to select
klass1 = 80;    % Sea-level limit in cm of class 1 warning
klass2 = 120;   % Sea-level limit in cm of class 2 warning
%--------------------------------------------------------------------------
tic
k = 0; % Counter
load(stationsFile) % Load F_TXT containing station names for Omrade
dec_station = strcmp(deciding_station, F_TXT); % Pick row of deciding station
% Load only the station in the omrade we want to choose 5 max events from
b = strfind(F_TXT{dec_station},'.');
load(['ExportStatMat/',F_TXT{dec_station}(1:b-1),'.mat']) 
% Convert format of dates from cell to char
dates_char=char(U_DATE);
% Pick out the strings for year and make numeric variable
years = str2num(dates_char(:,1:4));
% Pick out the strings for month and make numeric variable
months = str2num(dates_char(:,6:7));
% Find out what unique years we have
uniq_years = unique(years);
% Find out how many unique months we have
uniq_months = unique(months);
% To find monthly maximums create a matrix with year, month, sea-level and
% datenum of the event as rows
for y = uniq_years' % For all unique years
    for m = uniq_months' % For all unique months
        % Update counter
        k = k+1;
        month_max_table(k,1) = y;   % Log what year the max is for
        month_max_table(k,2) = m;   % Log what month the max is for
        %Find in time series
        id_y = find(years == y); % id for all rows with right year
        id_m = find(months == m);% id for all rows with right month
        % id for all rows with right year and month 
        id = intersect(id_y,id_m);   
        if length(id)>=1 % If data for that year-month combination exists
            % Find the maximum sea-level that year and month
            [month_max] = max(U_HEIGHT(id)); 
            % Find row id for that event in the U_HEIGHT vector
            id_max = intersect(id,find(U_HEIGHT == month_max));
            % In case that sea-level was reached more than one time that
            % month
            id_max = id_max(1);
            % Put datenum of the occurrence in the table
            month_max_table(k,3) = U_DAT(id_max);  
            % put sea-level of the occurrence in the table
            month_max_table(k,4) = U_HEIGHT(id_max);    
        else % If no data was found for that year-month combination
            month_max_table(k,3) = nan;    % put nan instead of datnum
            month_max_table(k,4) = nan;    % put nan instead of sea-level
        end
    end
end

% Plot all height data from the deciding station
plot(U_DAT,U_HEIGHT,'-')
hold on
% Circle the month maximums
plot(month_max_table(:,3),month_max_table(:,4),'o')
grid on
datetick('x','mmm yyyy','keeplimits')
% Sort the events so that the highest heights are at the top
[B,I]=sortrows(month_max_table,4,'descend','MissingPlacement','last');
% Max events are the 5 highest monthly maximums. Flip matrix so events are
% in columns
maxEvents = B(1:n_events,:)';
% Mark the 5 highest monthly maximums in plot
plot(maxEvents(3,:),maxEvents(4,:),'ok')
hold on
% Plot warning-limits
plot([min(U_DAT) max(U_DAT)],[klass1 klass1])
plot([min(U_DAT) max(U_DAT)],[klass2 klass2])
legend('Sea-level','Monthly max','Events','Klass 1','Klass 2')
title(deciding_station(1:b-1))
ylabel('Sea level [cm]')
toc
% Calculate start and end time for events 
for n = 1:size(maxEvents,2) % For all events
    % start date in datenum
    from(1,n) = addtodate(maxEvents(3,n), -halfperiod, 'day');
    % end date in datenum
    to(1,n) = addtodate(maxEvents(3,n), halfperiod, 'day');
end
% concatenate matrix containing datenum of events and max sea-level of events with
% start and end datenums of event period
exportEvents = [maxEvents(3:4,:);from;to];
save(['ExportEventMat/',stationsFile(1:end-8),F_TXT{dec_station}(1:b-1),'events'],'exportEvents')
% exportEvents columns are constructed
% datenum of event
% sea level of event
% datenum of start of event
% datenum of end of event

%ca 6 sek
% Useful extra code
% datetick(gca,'x','dd/mm/YYYY','keeplimits')
% datetick(gca,'x','dd/mm','keeplimits','keepticks')
% set(gca,'xtick',[datenum('2011-11-27') datenum('2011-11-28') datenum('2011-11-29')])
% coordinates = cell2mat({cursor_info.Position}');
% datevec(coordinates(1))

