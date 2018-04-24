%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
% reads all hashes from the tree
% does not rehash anything
% if hash is empty, it returns an empty char
function H = getAllHashes(self)

H = {};
if isempty(self.hash)
	H{1} = repmat('0',1,32);
else
	H{1} = self.hash;
end

for i = 1:length(self.Children)
	these_hashes = self.(self.Children{i}).getAllHashes;
	H = [H; these_hashes];
end
