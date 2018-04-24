%exempelskript för att beräkna återkomsttider
%kontakta Johan Södling för hjälp

%addpatha några sökvägar vi behöver

%själva huvudskriptet och dess subrutiner:
addpath('\\winfs-proj\data\proj\au_metod\Workspace\Johan.Sodling\ML_WORK\gev_analyser_workbench');

%några hjälpskript:
addpath('\\winfs-proj\data\proj\au_metod\Workspace\Johan.Sodling\matlab_files\MATLAB');

%start-datum och slutdatum
dnum_start = datenum('1961-01-01');
dnum_end = datenum('2017-12-31');

%vektor med tidsstämplarna
dnums = dnum_start:dnum_end;

%skapa slumpgenererad data från 0 till 1.
%det kommer troligen bli dålig anpassning till årsmaxen från denna data,
%men som exempeldata funkar det nog ok
totd = numel(dnums);
xraw = rand([totd 1]);

%några fler saker vi vill sätta innan vi anropar extremvärdesberäkningen

%vi vill räkna på "snö-år", vilket definieras som juli till juni. Anledningen att 
%det kallas snow är att jag ursprungligen använde det för återkomsttider på
%snödjup, där vi också körde denna period
tstr = 'snow';

%utdata-mapp
%om mappen inte finns så skapas den av skriptet
outfold = [cd,'/return_period_test\'];

%anropa beräkningarna
run('gev_analyser_v2_9');
