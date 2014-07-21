classdef FitG2 < hgsetget
% write a description of the class here.

  properties
    % define the properties of the class here, (like fields of a struct)
    aValue   = 0.6;
    t0Value  = -0.75;
    t1Value  = 1.4;
    t2Value  = 1100;
    pfValue  = 0.9372;

    widthHbt   = 0.296;

    xData;
    yData;

    fitParameters;
    g2Data;

  end

  methods
  % methods, including the constructor are defined in this block

    function obj = FitG2( new_a, new_t0, new_t1, new_t2, new_pf, new_widthHbt, new_xData, new_yData)
    % class constructor, name of constructor function must match name of class
      if ( nargin == 8 )
        obj.aValue     = new_a;
        obj.t0Value    = new_t0;
        obj.t1Value    = new_t1;
        obj.t2Value    = new_t2;
        obj.pfValue    = new_pf;
        obj.widthHbt    = new_widthHbt;
        obj.xData       = new_xData;
        obj.yData       = new_yData;
      elseif ( nargin < 8 )
        error ('Not enough input arguments for fit.')
      else
        error ('Too many arguments for fit.')
      end

    end




    function g2 = g2_equation( obj )

      g2 =@(p) 1-p(5)^2 + p(5)^2*(1-0.5*(1 + p(1))*exp(log  (((exp    (log(1-erf(0.5*((-p(2) + obj.xData)*p(3)...
                       + obj.widthHbt^2)*sqrt(2)/(obj.widthHbt*p(3)))) + (2*obj.xData/p(3)))...
                       + (1 + erf(0.5*((-p(2) + obj.xData)*p(3)-obj.widthHbt^2)*sqrt(2)/(obj.widthHbt*p(3))))*exp(2*p(2)/p(3)))))... 
                       + (0.5*((-2*obj.xData-2*p(2))*p(3) + obj.widthHbt^2)/p(3)^2))... %convolution gaussian with 1st exponential function
                       + 0.5*p(1)*exp(0.5*((-2*obj.xData-2*p(2))*p(4) + obj.widthHbt^2)/p(4)^2)...  
                      .*(exp(2*obj.xData/p(4)) + exp(2*p(2)/p(4))-erf(0.5*((-p(2) + obj.xData)*p(4)...
                       + obj.widthHbt^2)*sqrt(2)/(obj.widthHbt*p(4)))...
                      .*exp(2*obj.xData/p(4)) + erf(0.5*((-p(2) + obj.xData)*p(4)-obj.widthHbt^2)*sqrt(2)/(obj.widthHbt*p(4)))*exp(2*p(2)/p(4))))-obj.yData; %convolution gaussian with 2. exponential function

    end





    function calculate_g2_fit( obj )

      fitParametersStart=[obj.aValue obj.t0Value obj.t1Value obj.t2Value obj.pfValue];

      g2 = obj.g2_equation;

      [calculatedFitParameters, sum_squares_residuals, iterations]=LMFnlsq(g2,fitParametersStart,'maxiter',1000);

      set(obj, 'aValue', calculatedFitParameters(1));
      set(obj, 't0Value', calculatedFitParameters(2));
      set(obj, 't1Value', calculatedFitParameters(3));
      set(obj, 't2Value', calculatedFitParameters(4));
      set(obj, 'pfValue', calculatedFitParameters(5));

      set( obj, 'fitParameters', calculatedFitParameters(:));

      set(obj, 'g2Data', g2(calculatedFitParameters(:)));
    end








    function save_fit_data( obj, myFolder, baseFileName )

      dlmwrite(fullfile(myFolder, [ baseFileName, '_g2_fitdata.txt']), (obj.g2Data+obj.yData),'precision', 8) ;


    end


    function save_fit_parameters( obj, myFolder, baseFileName )

      dlmwrite(fullfile(myFolder, [ baseFileName, '_g2_fitparam.txt']),obj.fitParameters,'delimiter' ,'\t', 'precision', 6);

    end

  end

end