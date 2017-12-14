%% Author: Berrada Ali <ali@MAIA>
%% Created: 2017-11-30
%% Support: Octave, Matlab

% Test case(s):
% plain = artDecoding(code, 6, 'ACTG', [0.5,0.3,0.15,0.05]);
% plain = artDecoding(code, 10, 'SWIMx', [0.5,0.2,0.1,0.1,0.1]);
% plain = artDecoding(code, 8, 'EBxA', [0.375,0.25,0.25,0.125]);

% Input:  - binaryCode: str | encoded text in binary format
%         - plainLength: double[] | length of the original text
%         - symbols: str | symbols in the original text
%         - frequencies: double[] | frequencies of symbols
% Output: - plain: str | original text decoded
function plain = artDecoding (binaryCode, plainLength, symbols, frequencies)
  
    % low and high ranges of symbols will be stored in a dictionary style
    lowRanges = struct;
    highRanges = struct;
    
    % init values
    lowRange = 0; % low bound of a symbol
    plain = ''; % variable to store the decoded text

    % calculating the low and high bound of each symbol
    N = length(symbols);
    for i = 1:N
        lowRanges.(symbols(i)) = lowRange;
        highRange = lowRange + frequencies(i);
        highRanges.(symbols(i)) = highRange;
        % the high bound of current symbol is the low bound of next symbol
        lowRange = highRange; 
    end

    code = bin2dec(binaryCode); % convert to integer

    % make it as decimal in form 0.XXXXX
    while floor(code) ~= 0
        code = code / 10;
    end

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