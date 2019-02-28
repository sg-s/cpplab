
%                    _       _     
%   ___  _     _    | | __ _| |__
%  / __|| |_ _| |_  | |/ _` | '_ \
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/
%
%
% ### find
%
% **Syntax**
%
% ```
% object_names = find(self,cpp_parent_class_name)
% object_names = find(self,object_name)
% object_names = find(self,'*wildcard*parameter')
% ```
%
% **Description**
%
% finds objects in a structure cpplab tree that consists
% of nested objects.
%
%
% `object_names = find(self,cpp_parent_class_name)`
%
%
%
%
% !!! info "See Also"
%     ->cpplab.get
%     ->cpplab.set




function objects = find(self,pattern,prefix)

if any(strfind(pattern,'*'))
	% do a wildcard search

	if ~isempty(self.cpp_lab_real_names_hash) && ~isempty(self.cpp_lab_real_names_hash) && strcmp(self.cpp_lab_real_names_hash, self.hash)
		real_names = self.cpp_lab_real_names;
	else
		[~,~,~,real_names] = self.serialize;
		if ~isempty(self.hash)
			self.cpp_lab_real_names_hash = self.hash;
			self.cpp_lab_real_names = real_names;
		end
	end



	regStr = ['^',strrep(strrep(pattern,'?','.'),'*','.{0,}'),'$'];
	starts = regexpi(real_names, regStr);
	iMatch = ~cellfun(@isempty, starts);
	idx = find(iMatch);

	objects = real_names(idx);
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

	elseif  length(self.(c{i})) == 0
		% empty, skip
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
