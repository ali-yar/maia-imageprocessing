% Author: Berrada Ali <ali@MAIA>
% Created: 2017-12-05

% works on integer images only

% img = [0,0,0; 100,100,100; 150,150,150];
% [code, codeList] = huffmanImage(img)
function [code, codeList] = huffmanImage(img)
  prefix = "x"; % used when assigning a symbol for each image intensity
  
  shape = size(img); % get number of rows and columns
  S = prod(shape); % find total size of image 
  img = reshape(img', 1, S); % flatten the image matrix to a row vector
  
  counts = hist(img, [min(img):max(img)]);
  l = find(counts~=0);
  intensities = l - 1; % the different intensities of the image
  frequencies = counts(l); % frequency of each intensity
  
  N = length(frequencies);

  list = {}; 
  for i = 1:N
    node{1} = sprintf('%s%d', prefix, intensities(i)); 
    node{2} = frequencies(i);
    node{3} = {};
    node{4} = {};
    list{i} = node;
  end

  while length(list) > 1
    sortList(); % sort the list
    nodeLeft = list{1};
    nodeRight = list{2};
    node{2} = nodeLeft{2} + nodeRight{2}; % frequency of new node
    node{3} = nodeLeft; 
    node{4} = nodeRight;
    list([1,2]) = []; % remove the 2 nodes with lowest frequencies
    list{end+1} = node; % add the new node
  end

  codeList = struct;
  
  readCode(list{1}, '');
  
  code = [];
  for i = 1:S
    codeList.(sprintf('%s%d', prefix, img(i)))
    code = [code codeList.(sprintf('%s%d', prefix, img(i)))];
  end
  
    function sortList()
        len = length(list);
        sortedList = {};
        tmp = [];
        for j = 1:len
            tmp = [tmp, list{j}{2}];
        end
        [tmp, ind] = sort(tmp);
        for j = 1:len
            sortedList{j} = list{ind(j)};
        end
        list = sortedList;
    end

    function readCode(node, c)
        flag = isempty(node{3}) && isempty(node{4}); % check if node is leaf
        if ~flag
          readCode(node{3}, [c, '0']);
          readCode(node{4}, [c, '1']);
        else
          codeList.(node{1}) = c; % store a dict of (key,value)=(symbol,code)
        end 
    end
  
end
