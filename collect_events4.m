% Author: Josefina Algotsson, SPO at SMHI
% Contact: josefina.algotsson@smhi.se
% Date: 2017-11-28
%
% This script loads water level data from all stations within an Omrade and
% creates a matrix containing water height for all station during all
% events. eventheight has each station as a row and the columns have the
% water height or time series in each event. 
clear
close all

%---------------------------edit-------------------------------------------
% File containing station names in Omrade
stationsFile='KattegattStations';
% Deciding station for max sea-level event
deciding_station = 'FALKENBERG 2 SJÖV.RW';
n_picked_values = 10; % half number of measurements to add to event time series
%--------------------------------------------------------------------------
tic
s = 0; % represents station in new event matrix
% Read file containing stations in omrade
load(stationsFile) % Load F_TXT containing station names for Omrade 
% Find where deciding station name matches row in Omradefile
dec_station = strcmp(deciding_station, F_TXT); 
% Find row of deciding station
dec_station = find(dec_station == 1);
% Format string to load event file containing info on maximum events
m = strfind(F_TXT{dec_station},'.');
load(['ExportEventMat/',stationsFile(1:end-8),F_TXT{dec_station}(1:m-1),'events'])
% Prelocate time matrix and height matrix
eventTime = cell(length(F_TXT),size(exportEvents,2));
eventHeight = eventTime; 
files = 1:length(F_TXT);
% Go through all stations but do the deciding station first
for station = [dec_station, files(1:end ~= dec_station)]
    % Update counter for station
    s = s + 1;
    % Find where file format starts
    b = strfind(F_TXT{station},'.');
    % Load the station file containing U_DAT and U_HEIGHT
    load(['ExportStatMat/',F_TXT{station}(1:b-1)])
    % For all events
    for event = 1:size(exportEvents,2)
        if s == 1 % If handling the deciding station
            % Collect timestamps from deciding station
            % Find id in time series which matches time stamp of event
            id_event = find (U_DAT == exportEvents(1,event));
            % Collect n_picked more timestamps than just the one time stamp
            % of the maximum event
            ids = [id_event-n_picked_values:id_event+n_picked_values];
            % Put the selected time series for the event in matrix
            eventTime{station,event} = U_DAT(ids);
            eventHeight{station,event} = U_HEIGHT(ids);
        else
            % define frame in which to look for max in other stations
            id1 = find (U_DAT >= exportEvents(3,event));
            id2 = find (U_DAT <= exportEvents(4,event));
            id_frame = intersect(id1,id2);
            % Find index for maximum height in that frame
            id_max_inframe = find(U_HEIGHT(id_frame) == max(U_HEIGHT(id_frame)));
            % Convert to index in whole series
            id_max = id_max_inframe+id_frame(1)-1;
            id_max =id_max(1);
            % Index for picked interval for that station
            ids = [id_max-n_picked_values:id_max+ n_picked_values];
            % Put date and height in those picked elements in matrix
            eventHeight{station, event} = U_HEIGHT(ids);
            eventTime{station, event} = U_DAT(ids);
        end
    end
end

save(['ExportEventSeries/',stationsFile(1:end-8),F_TXT{dec_station}(1:m-1),'eventsSeries'],...
    'eventHeight','eventTime','F_TXT','dec_station','exportEvents')
toc

% Useful extra code
% datetick(gca,'x','dd/mm/YYYY','keeplimits')
% datetick(gca,'x','dd/mm','keeplimits','keepticks')
% set(gca,'xtick',[datenum('2011-11-27') datenum('2011-11-28') datenum('2011-11-29')])
% coordinates = cell2mat({cursor_info.Position}');
% datevec(coordinates(1))

