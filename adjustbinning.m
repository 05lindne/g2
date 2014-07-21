function [dataAdjusted] = adjust_x(data, binwidth)
% Adjusts binnig to specified bin width.
	
	dataAdjusted =  subtract_offset(data, timeWindow) * binwidth;