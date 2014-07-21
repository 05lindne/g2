function[dataNormalized] = normalize_g2(data, normalizationRange)
% Normalizes the g2 function by setting the mean of the outermost data points (number given by normalizationRange) to 1.
	
	% sanity checks
	if  ~isvector(data)
		error ('Input data is not an array.')
	end

	if nargin ~= 2
	    error('Wrong number of input arguments')
	end


	dataInRange = data(1:normalizationRange); % use the first few values

	dataNormalized = data./ mean(dataInRange);