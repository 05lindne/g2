function [dataAdjusted] = adjust_x(data, binwidth)
% Adjusts binnig to specified bin width.
	
	% sanity checks
	if  ~isvector(data)
		error ('Input data is not an array.')
	end

	if nargin ~= 2
	    error('Wrong number of input arguments')
	end



	dataAdjusted =  subtract_offset(data) * binwidth;