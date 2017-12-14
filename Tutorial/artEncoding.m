%% Author: Berrada Ali <ali@MAIA>
%% Created: 2017-11-24
%% Support: Octave, Matlab

% Test case(s):
% code = artEncoding ('ACTAGC', 'ACTG', [0.5,0.3,0.15,0.05]);
% code = artEncoding ('SWISSxMISS', 'SWIMx', [0.5,0.2,0.1,0.1,0.1]);
% code = artEncoding ('BExAxBEE', 'EBxA', [0.375,0.25,0.25,0.125]);

% Input:  - plain: str | text to encode
%         - symbols: str | symbols in the text
%         - frequencies: double[] | frequencies of symbols
% Output: - code: str | coding in binary format
function code = artEncoding (plain, symbols, frequencies)
    
    % symbols low and high ranges will be stored in a dictionary style
    lowRanges = struct;
    highRanges = struct;
    
    % init values
    oldLow = 0;
    oldHigh = 1;
    lowRange = 0; % low bound of a symbol

    % calculating the low and high bound of each symbol
    N = length(symbols);
    for i = 1:N
        lowRanges.(symbols(i)) = lowRange;
        highRange = lowRange + frequencies(i);
        highRanges.(symbols(i)) = highRange;
        % high bound of current symbol = low bound of next symbol
        lowRange = highRange; 
    end
    
    % iterate through all characters and find final oldLow and oldHigh
    k = length(plain);
    for i = 1:k
        range = oldHigh - oldLow;
        newLow = oldLow + range * lowRanges.(plain(i));
        newHigh = oldLow + range * highRanges.(plain(i));
        oldLow = newLow;
        oldHigh = newHigh;
    end

    % we take the code to be the average of oldLow and oldHigh instead of
    % oldLow only. This will avoid errors due to large decimals during the 
    % decoding part.
    code = (oldLow + oldHigh) / 2;
    
    % for easier conversion to binary, we convert only the numbers after 
    % the decimal point, e.g.: if 0.23, take 23
    tmp = sprintf('%.15f',code);
    code = str2double(tmp(3:end));
    
    % remove zeroes at the end of the number before converting to binary
    while floor(code/10) - code/10 == 0
        code = code/10;
    end
    code = dec2bin(code); % convert to binary

end