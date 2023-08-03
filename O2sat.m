% o2sat.m                                          by:  Edward T Peltzer, MBARI
%                                                  revised:  2007 Apr 26.
%
% CALCULATE OXYGEN CONCENTRATION AT SATURATION
%
% Source:  The concentration and isotopic fractionation of oxygen dissolved
% in freshwater and seawater in equilibrium with the atmosphere, Limnol
% Oceanography, 29(3), 1984, 620-632
% Molar volume of oxygen at STP obtained from NIST website on the
%          thermophysical properties of fluid systems:
%
%          
%
%
% Input:       S = Salinity (pss-78)
%              T = Temp (deg C)
%
% Output:      Oxygen saturation at one atmosphere (umol/kg).
%
%                        O2 = o2sat(S,T).

function [O2sat] = o2sat(SDtemp,sal)


% DEFINE CONSTANTS, ETC FOR SATURATION CALCULATION

%    The constants -177.7888, etc., are used for units of ml O2/kg.

  T1 = (SDtemp + 273.15); 

  OSAT = -135.29996 + 157228.8 ./(T1) - 66371490 ./(T1 .^2) + 12436780000 ./(T1 .^3) - 862106100000 ./(T1 .^4)- sal .* (0.020573 - 12.142 ./T1 + 2363.1 ./(T1 .^2));
  OSAT = exp(OSAT); %umol/kg


  O2sat = OSAT;