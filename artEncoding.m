## Copyright (C) 2017 ali@MAIA
## 
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {} {@var{lowRanges, highRanges} =} arithmeticCoding (@var{symbols}, @var{frequencies}, @var{plain})
##
## @seealso{}
## @end deftypefn

## Author: Berrada Ali <ali@MAIA>
## Created: 2017-11-24

% [binaryCode, code] = artEncoding ('ACTAGC', 'ACTG', [0.5,0.3,0.15,0.05])
function [code, oldLow] = artEncoding (plain, symbols, frequencies)
  N = length(symbols);
  
  oldLow = 0;
  oldHigh = 1;
  
  lowRanges = struct;
  highRanges = struct;
  
  lowRange = 0; % initializing the low bound of a symbol
  
  % calculating the low and high bound of each symbol
  for i = 1:N
    lowRanges.(symbols(i)) = lowRange;
    highRange = lowRange + frequencies(i);
    highRanges.(symbols(i)) = highRange;
    lowRange = highRange; % high bound of current symbol = low bound of next symbol
  end
  
  k = length(plain);
  for i = 1:k
    range = oldHigh - oldLow;
    newLow = oldLow + range * lowRanges.(plain(i));
    newHigh = oldLow + range * highRanges.(plain(i));
    oldLow = newLow;
    oldHigh = newHigh;
  end
 
  % for easier conversion to binary,
  % we convert only the numbers after the decimal point, e.g.: if 0.23, take 23
  code  = str2num(num2str(oldLow)(3:end));
  code = fliplr(de2bi(code)); % convert to binary
  
endfunction