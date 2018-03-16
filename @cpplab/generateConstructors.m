%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
%
function [constructors, cpp_class_parent, names] = generateConstructors(self, prefix)

if nargin < 2
	prefix = '';
else
	prefix = [prefix '_'];
end

props = properties(self);
constructors = {};
cpp_class_parent = {};
names = {};

for i = 1:length(props)
	if isa(self.(props{i}),'cpplab')
		S = self.(props{i}).cpp_constructor_signature;
		cpp_class_parent = [cpp_class_parent; self.(props{i}).cpp_class_parent];
		names = [names; prefix props{i}];
		this_constructor = [self.(props{i}).cpp_class_name ' ' prefix props{i} '('];
		for j = 1:length(S)
			this_constructor = [this_constructor, [prefix props{i} '_' S{j}] ','];
		end
		this_constructor(end) = ')';
		this_constructor = [this_constructor ';'];
		constructors = [constructors; this_constructor];
		[C, CC, N] = self.(props{i}).generateConstructors(props{i});
		constructors = [constructors; C];
		cpp_class_parent = [cpp_class_parent; CC];
		names = [names; N];
	end
end