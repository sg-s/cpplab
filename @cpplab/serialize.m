%{ 
                   _       _     
  ___  _     _    | | __ _| |__  
 / __|| |_ _| |_  | |/ _` | '_ \ 
| (_|_   _|_   _| | | (_| | |_) |
 \___||_|   |_|   |_|\__,_|_.__/ 


# serialize

**Syntax**

```
values = C.serialize;
[values, names] = C.serialize;
[values, names, is_relational] = C.serialize;
[values, names, is_relational, real_names] = C.serialize;
```

**Description**

`serialize` is a method that traverses the cpplab object tree, collects the value of every parameter in every object and packs them into a vector. 

- **`values = C.serialize`** returns a vector of all parameters in the nested cpplab object C. 
- **`[values, names] = C.serialize`** also returns the names of all parameters. The order of names matches the order of values
- **`[values, names, is_relational] = C.serialize`** also returns a logical vector that is the same length as the other two outputs. Each element in this vector is either true or false based on whether the parameter is a scalar value or a relational function handle. 
- **`[values, names, is_relational, real_names] = C.serialize`** also returns a fourth cell vector which contains the real names of all parameters, that allows you to directly use it to reference those parameters. 

!!! info "See Also"
    ->cpplab.find
    ->cpplab.deserialize
    ->cpplab.get

%}


function [values, names, is_relational, real_names] = serialize(self, prefix, real_prefix)

if nargin < 2
	prefix = '';
	real_prefix = '';
else
	prefix = [prefix '_'];
	real_prefix = [real_prefix '.'];

end


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
