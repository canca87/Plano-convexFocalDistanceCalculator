function [ f, n ] = LensFocalDistanceReal(d, h, varargin)
%LensFocalDistanceRead calculated the focal distance of a real plano-convex lens
%   Measure the diameter, d, of the lens in micrometers
%   Measure the sag (heigh), h, of the lens in micrometers
%   Optionally, include either refactive index of the lens material 'n'
%               or the three cauchy coefficients (N1,N2,N3 respecitvely)
%   To change the wavelength, use the text 'wavelength' followed by the
%   numerical value for the wavelength in nanometers.. EG:
%   (d,h,'wavelength',785)

%% Real world lenses:
if (d <= 0) %check to see if diameter is valid
    error('Error. \nDiameter must be greater than ZERO.')
end
if (h <= 0) %check to see if height is valid
    error('Error. \nHeight must be greater than ZERO (plano convex lenses only).')
end
%can now use diameter and height to calculate the curvature of the lens.
R_curvature = ((d^2) + (4 * (h^2))) / (8 * h);


optargin = size(varargin,2);
%scan varargin for any text strings
lambda_um = 785 * 10^-3;
for i = 1 : optargin
    if strcmp(varargin(i),'wavelength')
        %found the wavelength parameter
        lambda_um = varargin{i+1} * 10^-3;
        optargin = optargin - 2;
        varargin(i+1) = [];
        varargin(i) = [];
        break
    end
end

%Default values for Cauchy coefficients for AZ 9260
cN1 = 1.6089;
cN2 = 0.0025069;
cN3 = 0.00428;
%default refractive index
n1 = cN1 + (cN2/(lambda_um^2)) + (cN3/(lambda_um^4)); %refractive index of AZ

if optargin == 0
    % nothing!
elseif optargin == 1
    % can only be refractive index
    n1 = varargin{1};
elseif optargin == 2
    % unknown!!
    error('Error. \nInvalid parameters. Only two parameters found.')
elseif optargin == 3
    % cauchy coefficients
    %Default values for Cauchy coefficients for AZ 9260
    cN1 = varargin{1};
    cN2 = varargin{2};
    cN3 = varargin{3};
    %default refractive index
    n1 = cN1 + (cN2/(lambda_um^2)) + (cN3/(lambda_um^4)); %refractive index of AZ

elseif optargin == 4
    % refractive and cauchy (not possible!)
    error('Error. \nProvide refactive index OR cauchy coefficients. NOT BOTH.')
else
    % something unknown going on here .. too many variables
    error('Error. \nInvalid parameters. Too many parameters were supplied.')
end

%now for the actual calculation!...
n2 = 1.000277; %refractive index of air
f = n2 * (((n1 * R_curvature) - ((n1 - 1) * h)) / (n1 * (n1 - 1)));
n = n1;

end

