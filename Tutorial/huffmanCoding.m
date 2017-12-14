%% Author: Berrada Ali <ali@MAIA>
%% Created: 2017-12-05
%% Support: Octave, Matlab

% Test case(s):
% [codes, codeList] = huffmanCoding('ABCDE',[15,7,6,6,5]);

% Input:  - symbols: str | symbols to encode
%         - frequencies: double[] | frequencies of symbols
% Output: - codes: cell(str) | huffman coding of symbols
%         - codeList: struct(str, str) | dictionary of (symbol,coding) pair
function [codes, codeList] = huffmanCoding (symbols, frequencies)
    list = {}; % list will emulate a binary tree
    codeList = struct; % build a dictionary of (key,value)=(symbol,code)
    codes = {}; % to store only the coding of the respective input 
    
    % Build the tree starting from the leaf nodes with each leaf node
    % representing a symbol. Every node has 4 attributes: symbol,
    % frequency, pointer for left child, pointer for right child.
    N = length(frequencies);
    for i = 1:N
        node{1} = symbols(i);
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
    
    % reorder the codes of the symbols to match the order in the input
    for i = 1:N
        codes{i} = codeList.(symbols(i));
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
end

