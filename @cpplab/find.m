%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
% 
% finds objects in the tree whose class
% or parent class matches a certain pattern 

function objects = find(self,pattern,prefix)

if any(strfind(pattern,'*'))
	% do a wilfcard search
	[~,~,~,real_names] = self.serialize;
	objects = real_names(lineFind(real_names,'gbar'));
	return
else
end

if nargin < 3
	prefix = '';
else
	prefix = [prefix '.'];
end


objects = {};

c = sort(self.Children);

for i = 1:length(c)
	if length(self.(c{i})) > 1
		for j = 1:length(self.(c{i}))
			obj = self.(c{i})(j).find(pattern, [prefix c{i} mat2str(j)]);
			objects = [objects; obj];

			this_class = self.(c{i})(j).cpp_class_name;
			this_parent = self.(c{i})(j).cpp_class_parent;
			if any(strfind(this_class,pattern)) || any(strfind(this_parent,pattern))
				objects = [objects; [prefix c{i} '(' mat2str(j) ')']];
			end

		end

	else
		this_class = self.(c{i}).cpp_class_name;
		this_parent = self.(c{i}).cpp_class_parent;
		if any(strfind(this_class,pattern)) || any(strfind(this_parent,pattern))
			objects = [objects; [prefix c{i}]];
		end
		% go one level down
		obj = self.(c{i}).find(pattern,[prefix c{i}]);
		objects = [objects; obj];
	end
end