%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
% returns the children of any cpplab object
% children are also cpplab objects

function children = Children(self)
children = {};
props = sort(properties(self));
for i = 1:length(props)
	if isa(self.(props{i}),'cpplab')
		children{end+1} = props{i};
	end
end