classdef FitG2
% write a description of the class here.

  properties
    % define the properties of the class here, (like fields of a struct)
    aStart   = 0.6;
    t0Start  = -0.75;
    t1Start  = 1.4;
    t2Start  = 1100;
    y0Start  = 1;
    pfStart  = 0.9372;

    widthHbt   = 0.296;

    xData;
    yData;

    fitParametersEnd;

  end

  methods
  % methods, including the constructor are defined in this block

    function obj = FitG2( new_a, new_t0, new_t1, new_t2, new_y0, new_pf, new_widthHbt, new_xData, new_yData)
    % class constructor, name of constructor function must match name of class
      if ( nargin == 9 )
        obj.aStart     = new_a;
        obj.t0Start    = new_t0;
        obj.t1Start    = new_t1;
        obj.t2Start    = new_t2;
        obj.y0Start    = new_y0;
        obj.pfStart    = new_pf;
        obj.widthHbt    = new_widthHbt;
        obj.xData       = new_xData;
        obj.yData       = new_yData;
      elseif ( nargin < 9 )
        error ('Not enough input arguments for fit.')
      else
        error ('Too many arguments for fit.')
      end

    end

    function obj = calculate_g2_fit( obj )

      fitParametersStart=[obj.aStart obj.t0Start obj.t1Start obj.t2Start obj.pfStart];

      g2 =@(p) 1-p(5)^2 + p(5)^2*(1-0.5*(1 + p(1))*exp(log  (((exp    (log(1-erf(0.5*((-p(2) + obj.xData)*p(3)...
                       + obj.widthHbt^2)*sqrt(2)/(obj.widthHbt*p(3)))) + (2*obj.xData/p(3)))...
                       + (1 + erf(0.5*((-p(2) + obj.xData)*p(3)-obj.widthHbt^2)*sqrt(2)/(obj.widthHbt*p(3))))*exp(2*p(2)/p(3)))))... 
                       + (0.5*((-2*obj.xData-2*p(2))*p(3) + obj.widthHbt^2)/p(3)^2))... %convolution gaussian with 1st exponential function
                       + 0.5*p(1)*exp(0.5*((-2*obj.xData-2*p(2))*p(4) + obj.widthHbt^2)/p(4)^2)...  
                      .*(exp(2*obj.xData/p(4)) + exp(2*p(2)/p(4))-erf(0.5*((-p(2) + obj.xData)*p(4)...
                       + obj.widthHbt^2)*sqrt(2)/(obj.widthHbt*p(4)))...
                      .*exp(2*obj.xData/p(4)) + erf(0.5*((-p(2) + obj.xData)*p(4)-obj.widthHbt^2)*sqrt(2)/(obj.widthHbt*p(4)))*exp(2*p(2)/p(4))))-obj.yData; %convolution gaussian with 2. exponential function

      [fitParametersEnd, sum_squares_residuals, iterations]=LMFnlsq(g2,fitParametersStart,'maxiter',1000)

    end

    function obj = g2_equation(obj, p)

      obj.g2 = 1-p(5)^2 + p(5)^2*(1-0.5*(1 + p(1))*exp(log  (((exp    (log(1-erf(0.5*((-p(2) + obj.xData)*p(3)...
                       + obj.widthHbt^2)*sqrt(2)/(obj.widthHbt*p(3)))) + (2*obj.xData/p(3)))...
                       + (1 + erf(0.5*((-p(2) + obj.xData)*p(3)-obj.widthHbt^2)*sqrt(2)/(obj.widthHbt*p(3))))*exp(2*p(2)/p(3)))))... 
                       + (0.5*((-2*obj.xData-2*p(2))*p(3) + obj.widthHbt^2)/p(3)^2))... %convolution gaussian with 1st exponential function
                       + 0.5*p(1)*exp(0.5*((-2*obj.xData-2*p(2))*p(4) + obj.widthHbt^2)/p(4)^2)...  
                      .*(exp(2*obj.xData/p(4)) + exp(2*p(2)/p(4))-erf(0.5*((-p(2) + obj.xData)*p(4)...
                       + obj.widthHbt^2)*sqrt(2)/(obj.widthHbt*p(4)))...
                      .*exp(2*obj.xData/p(4)) + erf(0.5*((-p(2) + obj.xData)*p(4)-obj.widthHbt^2)*sqrt(2)/(obj.widthHbt*p(4)))*exp(2*p(2)/p(4))))-obj.yData; %convolution gaussian with 2. exponential function

    end

    function save_fit_data( obj, myFolder, baseFileName )

      % dlmwrite(fullfile(myFolder, [ baseFileName, '_g2_fitdata.txt']),obj.g2_equation( obj.fitParametersEnd),'precision', 8) ;
      % dlmwrite(fullfile(myFolder, [ baseFileName, '_g2_fitparam.txt']),x,'delimiter' ,'\t', 'precision', 6);

    end

  end

end