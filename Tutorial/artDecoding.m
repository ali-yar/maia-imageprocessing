%% Copyright (C) 2017 hp4540
%% 
%% This program is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 3 of the License, or
%% (at your option) any later version.
%% 
%% This program is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%% GNU General Public License for more details.
%% 
%% You should have received a copy of the GNU General Public License
%% along with this program.  If not, see <http://www.gnu.org/licenses/>.

%% -*- texinfo -*- 
%% @deftypefn {} {@var{plain} =} artDecoding (@var{binaryCode}, @var{plainLength}, @var{symbols}, @var{frequencies})
%%
%% @seealso{}
%% @end deftypefn

%% Author: Berrada Ali <ali@MAIA>
%% Created: 2017-11-30

% plain = artDecoding (code, 6, 'ACTG', [0.5,0.3,0.15,0.05])
% plain = artDecoding (code, 10, 'SWIMc', [0.5,0.2,0.1,0.1,0.1])
% plain = artDecoding (code, 8, 'EBxA', [0.375,0.25,0.25,0.125])

function plain = artDecoding (binaryCode, plainLength, symbols, frequencies)
  format long;
  
  N = length(symbols);
  
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
  
  code = bin2dec(binaryCode); % convert to integer
  
  % make it as decimal in form 0.XXXXX
  while floor(code) ~= 0
    code = code / 10;
  end
  
  plain = ''; % variable for the final result
  c = plainLength;
  while c > 0
    symbol = '';
    % find the symbol whose range contains the value of code
    for i = 1:N
      if code < highRanges.(symbols(i))
        symbol = symbols(i);
        break;
      end
    end
    low = lowRanges.(symbol);
    range = highRanges.(symbol) - low;
    code = (code - low) / range;
    plain = strcat(plain, symbol);
    c = c-1;
  end
  
end