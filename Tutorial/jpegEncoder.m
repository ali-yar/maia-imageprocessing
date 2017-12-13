## Author: hp4540 <hp4540@DESKTOP-RBK0R9L>
## Created: 2017-12-11

function [s] = jpegEncoder ()
  ori = imread('cameraman','png');
  m = 8; % bits per pixel
  
  streamBlocks = []; % store the streams to be encoded
  
  % function passed to blockproc()
  fun=@(block_struct) getStream(block_struct);
  
  % transformation matrix
  H = dctmtx(8);
  
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
  
  img = ori - 2.^(m-1); % shift intensity level

  blockproc(img,[8 8],fun);
  
  s = streamBlocks;
  
    function res = getStream(F)
      %T = H .* double(F) .* H'; % 2D DCT
      T = dct2(F);
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
      
      stream = [stream(1:k) -999]; % truncate after last non-zero element
      streamBlocks = [streamBlocks, stream];
      res = T;
    end

end
