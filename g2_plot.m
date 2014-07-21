%{
@file g2.m
@brief Read in g2 data of correlated click lists ( i.e. output of g2calc) and plot a normalized offset-subtracted, fitted g2.
@author Sarah Lindner
@date 12.06.2014

Lines of text which are to be modified by user are maked with >>>

@todo 
only works for data of new lab, build variable 
implement fit class
take maxiter out of fit class

%}

% Initialize parameters
clear all; close all;




% INPUT HERE---------------------------------------------------------

% >>> specify directory which contains the correlation data
myFolder = '/mnt/Daten/measurements/SIQ/goetzinger/SIQ-SG-V2/140606/g2/';
% >>> specify file name of the correlation data file without extension
baseFileName = 'scan_xy_25_25_ll_x20y23_g2';
% >>> specify extension of the correlation data file
dataInFileExtension = '.txt';
dataInFileName = [ baseFileName, dataInFileExtension ]

% >>> specify measurement performed in new or old lab ( for binning of time tag module, width of HBT response function)
lab = 'new'; %'old'

% >>> specify the number of datapoints which should be used as normalization reference
normalization_range = 200;
% >>> specify starting values for g2 fit
a   = 0.6;
t0  = -0.75;
t1  = 1.4;
t2  = 1100;
y0  = 1;
pf  = 0.9372;

%----------------------------------------------------------------------





% read in data
dataFileIn=dlmread(fullfile(myFolder, dataInFileName), '\t');
% save data in 1D arrays
xDataIn = dataFileIn(:,1);
yDataIn = dataFileIn(:,2);

% set binning of time tag module and width of HBT response function
if ( lab == 'new')
	binWidth 	= 0.078;
	widthHbt	= 0.296;
elseif ( lab == 'old')
	binWidth 	= 0.078;%?????????????????????????????????????????????????????????
	widthHbt	= 0.354;
else
	error ('Wrong input for lab')
end

% put measured data in desired format
xDataAdjusted = adjust_x( xDataIn, binWidth );
yDataNormalized = normalize_g2( yDataIn, normalization_range );

%calculate fit function

% fprintf('in main1')
% fitting = FitG2(a, t0, t1, t2, y0, pf, widthHbt, xDataAdjusted, yDataNormalized );
fitting = FitG2(a, t0, t1, t2, y0, pf, widthHbt );

% fprintf('in main2')

fitting.calculate_g2_fit( xDataAdjusted, yDataNormalized );

fprintf('in main3')
get(fitting)
get(fitting, 'fitParameters')
% fprintf('in main4')

%plot

% save output
% fitting.save_fit_data( myFolder, baseFileName );
