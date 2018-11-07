%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
% returns the children of any cpplab object
% children are also cpplab objects

function children = Children(self)

props = sort(properties(self));
is_child = false(length(props),1);
children = props;
for i = 1:length(props)

	if isa(self.(props{i}),'cpplab')
		is_child(i) = true;
	end
end

children = children(is_child);