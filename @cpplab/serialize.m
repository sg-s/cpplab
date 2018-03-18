%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
% serializes an object so you can pass it easily
% to a mexable C++ binary

function [values, names, is_relational, cpp_class] = serialize(self, prefix)

if nargin < 2
	prefix = '';
else
	prefix = [prefix '_'];
end


props = properties(self);
names = {};
values = [];
is_relational = logical([]);

for i = 1:length(props)
	if length(self.(props{i})) > 1 && isa(self.(props{i}),'cpplab')
		% vector of cpplab objects 
		for j = 1:length(self.(props{i}))
			[V, N, I] = self.(props{i})(j).serialize([prefix props{i} mat2str(j)]);
			values = [values; V];
			names = [names; N];
			is_relational = [is_relational(:); I(:)];
		end
	elseif isa(self.(props{i}),'double') && ~isempty(self.(props{i}))
		names = [names; [prefix props{i}]];
		values = [values; self.(props{i})];
		is_relational(length(values)) = false;

	elseif isa(self.(props{i}),'function_handle') && ~isempty(self.(props{i}))
		names = [names; [prefix props{i}]] ;
		values = [values; self.(props{i})()];
		is_relational(length(values)) = true;

	elseif  isa(self.(props{i}),'cpplab')
		[V, N, I] = self.(props{i}).serialize([prefix props{i}]);
		values = [values; V];
		names = [names; N];
		is_relational = [is_relational(:); I(:)];
	end

end