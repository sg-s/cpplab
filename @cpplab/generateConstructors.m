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
	if isa(self.(props{i}),'cpplab') && length(self.(props{i})) == 1

		S = self.(props{i});
		
		cpp_con_sig = S.cpp_constructor_signature;
		cpp_class_parent = [cpp_class_parent; S.cpp_class_parent];
		names = [names; prefix props{i}];
		this_constructor = [S.cpp_class_name ' ' prefix props{i} '('];
		for j = 1:length(cpp_con_sig)
			this_constructor = [this_constructor, [prefix props{i} '_' cpp_con_sig{j}] ','];
		end
		this_constructor(end) = ')';
		this_constructor = [this_constructor ';'];
		constructors = [constructors; this_constructor];
		[C, CC, N] = S.generateConstructors(props{i});
		constructors = [constructors; C];
		cpp_class_parent = [cpp_class_parent; CC];
		names = [names; N];

	elseif isa(self.(props{i}),'cpplab') && length(self.(props{i})) > 1
		for j = 1:length(self.(props{i}))
			S = self.(props{i})(j);
			
			cpp_con_sig = S.cpp_constructor_signature;
			cpp_class_parent = [cpp_class_parent; S.cpp_class_parent];
			names = [names; prefix props{i} mat2str(j)];
			this_constructor = [S.cpp_class_name ' ' prefix props{i} mat2str(j) '('];
			for k = 1:length(cpp_con_sig)
				this_constructor = [this_constructor, [prefix props{i} mat2str(j) '_' cpp_con_sig{k}] ','];
			end
			this_constructor(end) = ')';
			this_constructor = [this_constructor ';'];
			constructors = [constructors; this_constructor];
			[C, CC, N] = S.generateConstructors(props{i});
			constructors = [constructors; C];
			cpp_class_parent = [cpp_class_parent; CC];
			names = [names; N];

		end
	end
end