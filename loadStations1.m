% Author: Josefina Algotsson, Spo at SMHI
% Contact: josefina.algotsson@smhi.se
% Date: 2017-11-27
%
% This script reads the stations named in the OmradeStations.xlsx file,
% scans the corresponding excel file containing sea-level data and
% saves
% U_HEIGHT - double array containing the raw scanned information of the sea-level
% U_DAT - double array containing datenums of timestamps of measurements
% in one mat file for each station.

clear all
close all

k = 0;       % Counter
%---------------------------edit-------------------------------------------
% File containing all station names i one Omrade
stationsFile='KattegattStations';
% Folder containing excel sheets of downloaded WISKI data
inputFolder = '..\ExportStatWISKI\';
% place to put mat-files
outputFolder = 'ExportStatMat';
% Rows in excel file of new station names
newstationrow = 1:13;
% Read what stations are in the Omrade
[F_NUM, F_TXT, F_RAW] = xlsread([stationsFile,'.xlsx'],'A1:A13');
savestuff = 1;
%--------------------------------------------------------------------------
% For all selected stations in the excel file
for n=newstationrow
    stationload = F_TXT{n};             % Find name of station to open
    fid = fopen([inputFolder,stationload,'.csv']);
    % Scan excel file
    U = textscan(fid,'%s %s %f %*s','delimiter','\t','headerlines',16);
    fclose(fid);
    
    U_DATE=U{1,1}(:);                   % pick out dates as cells
    U_TIME=U{1,2}(:);                   % pick out timestamp as cells
    U_HEIGHT=U{1,3}(:);                 % pick out height as numbers
    
    strDay = cell2mat(U_DATE);          % make matrices of cells
    strTime = cell2mat(U_TIME);         % make matrices of cells
    % Concatenate date and time and make datenum of time
    U_DAT = datenum([strDay, (' ')*ones(size(strTime)), strTime], 'yy-mm-dd HH:MM:SS');
    % Format strings to save with nice name
    k = strfind(F_TXT{n},'.');
    if savestuff
         if not(exist(outputFolder,'dir'))
            mkdir(outputFolder);        % make directory if output folder doesn't exist
         end
        outputFolder = fix_folder(outputFolder); % add / at end of output folder path if necessary
        % Save mat file of time series (datenum and height) in the output folder
        save([outputFolder,F_TXT{n}(1:k-1)],'U_HEIGHT','U_DAT','U_DATE')
    end
end
if savestuff
    save([stationsFile(1:end)],'F_TXT') % save excel file of stations in one område as matfile
end
