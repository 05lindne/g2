classdef FitG2
% write a description of the class here.

  properties
    % define the properties of the class here, (like fields of a struct)
    a   = 0.6;
    t0  = -0.75;
    t1  = 1.4;
    t2  = 1100;
    y0  = 1;
    pf  = 0.9372;
    w   = 0.296;
  end

  methods
  % methods, including the constructor are defined in this block

    function obj = FitG2( new_a, new_t0, new_t1, new_t2, new_y0, new_pf, new_w)
    % class constructor, name of constructor function must match name of class
      if ( nargin == 7 )
        obj.a   = new_a;
        obj.t0  = new_t0;
        obj.t1  = new_t1;
        obj.t2  = new_t2;
        obj.y0  = new_y0;
        obj.pf  = new_pf;
        obj.w   = new_w;
      elseif ( nargin < 7 )
        error ('Not enough input arguments for fit.')
      else
        error ('Too many arguments for fit.')
      end

    end

    function obj = calculate_g2_fit( obj, xData, yData )

      fitParameters=[obj.a obj.t0 obj.t1 obj.t2 obj.pf];

      g2 =@(p) 1-p(5)^2+p(5)^2*(1-0.5*(1+p(1))*exp(log  (((exp    (log(1-erf(0.5*((-p(2)+xData)*p(3)+obj.w^2)*sqrt(2)/(obj.w*p(3))))+(2*xData/p(3)))...%convolution gaussian obj.with 1. exponential function
                      +(1+erf(0.5*((-p(2)+xData)*p(3)-obj.w^2)*sqrt(2)/(obj.w*p(3))))*exp(2*p(2)/p(3)))))... %convolution gaussian obj.with 1. exponential function
                      +(0.5*((-2*xData-2*p(2))*p(3)+obj.w^2)/p(3)^2))... %convolution gaussian obj.with 1. exponential function
                      +0.5*p(1)*exp(0.5*((-2*xData-2*p(2))*p(4)+obj.w^2)/p(4)^2)...  %convolution gaussian obj.with 2. exponential function
                      .*(exp(2*xData/p(4))+exp(2*p(2)/p(4))-erf(0.5*((-p(2)+xData)*p(4)+obj.w^2)*sqrt(2)/(obj.w*p(4)))... %convolution gaussian obj.with 2. exponential function
                      .*exp(2*xData/p(4))+erf(0.5*((-p(2)+xData)*p(4)-obj.w^2)*sqrt(2)/(obj.w*p(4)))*exp(2*p(2)/p(4))))-yData; %convolution gaussian with 2. exponential function

      [x,ssq,cnt]=LMFnlsq(g2,fitParameters,'maxiter',1000)

    end

  end

end