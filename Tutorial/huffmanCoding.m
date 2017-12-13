% Author: Berrada Ali <ali@MAIA>
% Created: 2017-12-05

% [codes, codeList] = huffmanCoding('ABCDE',[15,7,6,6,5])

function [codes, codeList] = huffmanCoding (symbols, frequencies)
  
  N = length(frequencies);
  
  list = {}; 
  for i = 1:N
    node{1} = symbols(i);
    node{2} = frequencies(i);
    node{3} = {};
    node{4} = {};
    list{i} = node;
  end

  while length(list) > 1
    % l = cell2mat(list);
    % [tmp, ind] = sort(cell2mat(l(1:3:end)));
    % list = list(ind); 
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
  
  
  
  codes = []; % reorder the codes of the symbols in same order as in input
  for i = 1:N
    codes{i} = codeList.(symbols(i));
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


