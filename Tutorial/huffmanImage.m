%% Author: Berrada Ali <ali@MAIA>
%% Created: 2017-12-05
%% Support: Octave, Matlab

% Test case(s):
% img = uint8(imresize(imread('cameraman', 'png'), 0.05)); imshow(img, []);
% [code, codeList] = huffmanImage(img);
% img = [0,0,0; 100,100,100; 150,150,150];
% [code, codeList] = huffmanImage(img);

% Input:  - img: uint[][] | image matrix
% Output: - code: str | huffman coding of image
%         - codeList: struct(str, str) | dictionary of (intensity,coding) pair
function [code, codeList] = huffmanImage(img)
    
    list = {}; % list will emulate a binary tree
    codeList = struct; % build a dictionary of (key,value)=(symbol,code)
    code = []; % to store the coding of the image 
    
    [rw , cl] = size(img); % total rows and columns
    S = rw * cl; % size of image
    img = reshape(img', 1, S); % flatten image matrix to a row vector
    
    prefix = 'x'; % used when assigning a symbol for each image intensity

    % find the frequency for each intensity
    [intensities, frequencies] = histCount(img); 
    
    % Build the tree starting from the leaf nodes with each leaf node
    % representing an intensity. Every node has 4 attributes: symbol,
    % frequency, pointer for left child, pointer for right child.
    N = length(frequencies);
    for i = 1:N
        node{1} = sprintf('%s%d', prefix, intensities(i)); % e.g 'x255'
        node{2} = frequencies(i);
        node{3} = {}; % leaf node is not pointing to any other node
        node{4} = {}; % leaf node is not pointing to any other node
        list{i} = node;
    end

    % Complete the tree by recursively finding parent nodes until the root
    % node. A parent node points to the 2 nodes in the list with the lowest
    % frequencies and has a frequency that is equal to the sum of their
    % frequencies. Assigning a symbol to a parent node is useless.
    while length(list) > 1
        sortList(); % sort the list
        nodeLeft = list{1};
        nodeRight = list{2};
        node{2} = nodeLeft{2} + nodeRight{2}; % frequency of new node
        node{3} = nodeLeft; % left child of new node 
        node{4} = nodeRight; % right child of new node
        list{end+1} = node; % add the new node to the tree
        list([1,2]) = []; % remove the 2 nodes with lowest frequencies
    end

    readCode(list{1}, ''); % populate the codeList variable
    
    % build the image coding by traversing the image
    for i = 1:S
        intensity = sprintf('%s%d', prefix, img(i));
        code = strcat(code, codeList.(intensity));
    end

    % utlity function to sort the nodes in a list based on node's frequency 
        function sortList()
            len = length(list);
            sortedList = {}; % the new sorted list
            % store the frequencies in a temporary array
            tmp = [];
            for j = 1:len
                tmp = [tmp, list{j}{2}];
            end
            % sort the frequencies and keep track of index rearrangement 
            [tmp, ind] = sort(tmp);
            % make a sorted list based on the previous index rearrangement
            for j = 1:len
                sortedList{j} = list{ind(j)};
            end
            list = sortedList; % override the original list with sorted one
        end
    
    % utlity function to read the code of leaf nodes by traversing the tree
        function readCode(node, c)
            % check if the node is a leaf node, i.e has no child node
            flag = isempty(node{3}) && isempty(node{4}); 
            % if it is not a leaf node, check the child nodes while
            % carrying a 0 for the left child and a 1 for the right child
            if ~flag
                readCode(node{3}, [c, '0']); 
                readCode(node{4}, [c, '1']);
            else
                % this is a leaf node, store it in the dictionary as 
                % a (symbol,code) pair
                codeList.(node{1}) = c; 
            end
        end
        
    % utlity function to find all the intensities and their frequencies
        function [intensities, frequencies] = histCount(data)
            minI = min(data); % get minimum intensity
            maxI = max(data); % get maximum intensity
            % Scaling down all intensities such that the min intensity maps to 
            % index 1 in the hist. This is to reduce size of hist.
            data = data - minI +1;
            lenHist = maxI - minI + 1; % total intensities for the hist
            hist = zeros(1,lenHist); % init the hist with 0 frequencies
            % iterate through the intensities in data and increment the 
            % frequency count in the hist correspondingly
            lenData = length(data);
            for i = 1:lenData
                intensity = data(i);
                hist(intensity) = hist(intensity) + 1; 
            end
            l = find(hist ~= 0); % return indexes where there is non-zero value
            intensities = (l - 1) + minI; % intensities present in the image
            frequencies = hist(l); % frequencies of intensities
        end
        
end