function [dataOffsetCorrected] = subtract_offset(data)
% Subtracts the offset of the x data such that g2 dip is at 0.
	
	% sanity checks
	if  ~isvector(data)
		error ('Input data is not an array.')
	end

	if nargin ~= 1
	    error('Wrong number of input arguments')
	end


	dataOffsetCorrected = (data - length(data)/2);