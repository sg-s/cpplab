%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
% serializes an object so you can pass it easily
% to a mexable C++ binary

function [values, names, is_relational, real_names] = serialize(self, prefix, real_prefix)

if nargin < 2
	prefix = '';
	real_prefix = '';
else
	prefix = [prefix '_'];
	real_prefix = [real_prefix '.'];

end

% if ~isempty(self.cpp_lab_real_names_hash) && ~isempty(self.cpp_lab_real_names_hash) && strcmp(self.cpp_lab_real_names_hash, self.hash)
	

% 	values = NaN(length(self.cpp_lab_real_names),1);
% 	for i = length(self.cpp_lab_real_names):-1:1
% 		%values(i) = self.get(self.cpp_lab_real_names{i});


% 		% yes, there an ugly eval here, but this
% 		% is the fastest way i know of of doing this
% 		% everything else (using .get(), etc ) is much slower
% 		eval(['values(i) = self.' self.cpp_lab_real_names{i} ';'])
% 	end

% 	is_relational = self.cpp_lab_is_relational;
% 	names = self.cpp_lab_names;
% 	real_names = self.cpp_lab_real_names;
% 	return

% end

props = sort(properties(self));
names = {};
real_names = {};
values = [];
is_relational = logical([]);

for i = 1:length(props)

	% check if it's hidden or should be otherwise ignored
	if strcmp(props{i},'hidden_props')
		continue
	end
	if any(strfind(props{i},'cpp_'))
		continue
	end

	if any(strcmp(props{i},self.hidden_props))
		continue
	end

	if length(self.(props{i})) > 1 && isa(self.(props{i}),'cpplab')
		% vector of cpplab objects 
		for j = 1:length(self.(props{i}))
			[V, N, I, R] = self.(props{i})(j).serialize([prefix props{i} mat2str(j)], [real_prefix props{i} mat2str(j)]);
			values = [values; V];
			names = [names; N];
			R = strrep(R,[props{i} mat2str(j)],[props{i} '(' mat2str(j) ')']);
			real_names = [real_names; R];
			is_relational = [is_relational(:); I(:)];
		end
	elseif isa(self.(props{i}),'double') && ~isempty(self.(props{i})) 
		if ~isscalar(self.(props{i}))
			continue
		end
		names = [names; [prefix props{i}]];
		real_names = [real_names; [real_prefix props{i}]];
		values = [values; self.(props{i})];
		is_relational(length(values)) = false;

	elseif isa(self.(props{i}),'function_handle') && ~isempty(self.(props{i}))
		names = [names; [prefix props{i}]] ;
		real_names = [real_names; [real_prefix props{i}]];
		values = [values; self.(props{i})()];
		is_relational(length(values)) = true;

	elseif  isa(self.(props{i}),'cpplab')
		[V, N, I, R] = self.(props{i}).serialize([prefix props{i}],[real_prefix props{i}]);
		values = [values; V];
		names = [names; N];
		real_names = [real_names; R];
		is_relational = [is_relational(:); I(:)];
	end

end

% if ~isempty(self.hash)
% 	self.cpp_lab_real_names_hash = self.hash;
% 	self.cpp_lab_real_names = real_names;
% 	self.cpp_lab_names = names;
% 	self.cpp_lab_is_relational = is_relational;
% end