%% Author: Berrada Ali <ali@MAIA>
%% Created: 2017-12-11
%% Support: Octave, Matlab

% Test case(s):
% img = uint8(imresize(imread('cameraman', 'png'), 0.05)); imshow(img, []);
% code = jpegEncoder(img);

% Input:  - img: uint[][] | image matrix
% Output: - code: str | jpeg coding of image
function code = jpegEncoder (img)
    
    streamBlocks = []; % to store the streams to be encoded
    fun=@(block_struct) getStream(block_struct); % function passed to blckproc()
    
    endOfBlock = -99; % identifier to terminate a stream block
    
    % normalization matrix
    Q = [ 16 11 10 16  24  40  51  61
          12 12 14 19  26  58  60  55
          14 13 16 24  40  57  69  56
          14 17 22 29  51  87  80  62
          18 22 37 56  68 109 103  77
          24 35 55 64  81 104 113  92
          49 64 78 87 103 121 120 101
          72 92 95 98 112 100 103 99  ];

    % zigzag pattern matrix        
    Z = [ 1   2   6   7  15  16  28  29
          3   5   8  14  17  27  30  43
          4   9  13  18  26  31  42  44
          10 12  19  25  32  41  45  54
          11 20  24  33  40  46  53  55
          21 23  34  39  47  52  56  61
          22 35  38  48  51  57  60  62
          36 37  49  50  58  59  63  64 ];
    
    m = whos('img').bytes / prod(size(img)) * 8; % bits per pixel
    
    img = img - 2.^(m-1); % shift intensities

    blockproc(img,[8 8],fun); % populate streamBlocks variable
    
    code = huffmanImage(streamBlocks);
    
        function retVal = getStream(F)
            T = dct2(F); % similar to T = dctmtx(8) .* F .* dctmtx(8)'
            T = round(T ./ Q); % quantization
            stream = [];
            for k = 1:64
                [i, j] = find(Z == k);
                stream(k) = T(i,j); 
            end
            
            len = length(stream);
            for k = len:-1:1
                if stream(k) ~= 0
                    break;
                end
            end
            % truncate stream after last non-zero element and terminate with EOB
            stream = [stream(1:k) endOfBlock]; 
            streamBlocks = [streamBlocks, stream];
            retVal = T; % blkproc need a returned value
        end

end