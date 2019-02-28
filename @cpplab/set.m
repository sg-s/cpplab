
%                    _       _     
%   ___  _     _    | | __ _| |__
%  / __|| |_ _| |_  | |/ _` | '_ \
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/
%
%
% ### set
%
% **Syntax**
%
% ```
% C.set('child_parameter',value)
% C.set('*wildcard*string',scalar_value)
% C.set('*wildcard*string',vector_value)
% ```
%
% **Description**
%
% `set` is a method that allows you to quickly assign values to
% multiple objects and parameters in a nested cpplab tree.
%
% - **`C.set('child_parameter',value)`** sets the value of the parameter specified by the character vector in the first argument to the value in the second argument. 'child_parameter' must be a resolvable name, i.e., C.child_parameter should exist as a scalar.
% - **`C.set('*wildcard*string',scalar_value)`** sets the values of all parameters in the cpplab object tree found using the wildcard search string to the scalar value provided. If multiple parameters are found, then all of them will be set to scalar_value.
% - **`C.set('*wildcard*string',vector_value)`** sets the values of all parameters in the cpplab object tree found using the wildcard search string to the vector value provided. The number of parameters matching the search string must be equal to the length of the vector_value, otherwise an error is thrown.
%
%
% !!! info "See Also"
%     ->cpplab.find
%     ->cpplab.get




function set(self,thing,value)

if iscell(thing)
	if length(value) == 1
		value = repmat(value,length(thing),1);
	end

	assert(length(value) == length(thing),'[cpplab::set] Lengths of values does not match the lengths of parameters being updated.')

	for i = 1:length(thing)
		self.set(thing{i},value(i))
	end
	return
end

if any(strfind(thing,'*'))
	% first find objects, then get them
	self.set(self.find(thing),value);
	return
end


ctree = strsplit(thing,'.');
V = self;

for i = 1:length(ctree)
	if any(strfind(ctree{i},'('))
		fn = ctree{i}(1:strfind(ctree{i},'(')-1);
		a = strfind(ctree{i},'(') + 1;
		z = strfind(ctree{i},')') - 1;
		fidx = str2double(ctree{i}(a:z));
		if i < length(ctree)
			V = V.(fn)(fidx);
		else
			V.(fn)(fidx) = value;
		end
	else
		if i < length(ctree)
			V = V.(ctree{i});
		else
			V.(ctree{end}) = value;
		end
	end
end
