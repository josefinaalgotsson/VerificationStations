%exempelskript f�r att ber�kna �terkomsttider
%kontakta Johan S�dling f�r hj�lp

%addpatha n�gra s�kv�gar vi beh�ver

%sj�lva huvudskriptet och dess subrutiner:
addpath('\\winfs-proj\data\proj\au_metod\Workspace\Johan.Sodling\ML_WORK\gev_analyser_workbench');

%n�gra hj�lpskript:
addpath('\\winfs-proj\data\proj\au_metod\Workspace\Johan.Sodling\matlab_files\MATLAB');

%start-datum och slutdatum
dnum_start = datenum('1961-01-01');
dnum_end = datenum('2017-12-31');

%vektor med tidsst�mplarna
dnums = dnum_start:dnum_end;

%skapa slumpgenererad data fr�n 0 till 1.
%det kommer troligen bli d�lig anpassning till �rsmaxen fr�n denna data,
%men som exempeldata funkar det nog ok
totd = numel(dnums);
xraw = rand([totd 1]);

%n�gra fler saker vi vill s�tta innan vi anropar extremv�rdesber�kningen

%vi vill r�kna p� "sn�-�r", vilket definieras som juli till juni. Anledningen att 
%det kallas snow �r att jag ursprungligen anv�nde det f�r �terkomsttider p�
%sn�djup, d�r vi ocks� k�rde denna period
tstr = 'snow';

%utdata-mapp
%om mappen inte finns s� skapas den av skriptet
outfold = [cd,'/return_period_test\'];

%anropa ber�kningarna
run('gev_analyser_v2_9');
