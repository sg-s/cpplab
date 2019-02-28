%{
%                    _       _     
%   ___  _     _    | | __ _| |__
%  / __|| |_ _| |_  | |/ _` | '_ \
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/
%
%
% ### get
%
% **Syntax**
%
% ```
% V = C.get('child_parameter')
% V = C.set('*wildcard*string')
% V = C.set('*wildcard*string')
% ```
%
% **Description**
%
% `get` is a method that allows you to quickly read values from
% multiple objects and parameters in a nested cpplab tree.
%
% - **`V = C.get('child_parameter')`** gets the value of the parameter specified by the character vector. 'child_parameter' must be a resolvable name, i.e., C.child_parameter should exist as a scalar.
% - **`V = C.set('*wildcard*string')`** gets the values of all parameters in the cpplab object tree found using the wild card search string to the scalar value provided.
% - **`V = C.set('*wildcard*string')`** gets the values of all parameters in the cpplab object tree found using the wild card search string.
%
%
% !!! info "See Also"
%     ->cpplab.find
%     ->cpplab.get

%}


function V = get(self,thing)

if iscell(thing)
	V = NaN(length(thing),1);
	for i = 1:length(V)
		value = self.get(thing{i});
		if isa(value,'function_handle')
			value = value();
		end
		V(i) = value;
	end
	return
end

if any(strfind(thing,'*'))
	% first find objects, then get them
	V = self.get(self.find(thing));
	return
end


ctree = strsplit(thing,'.');
V = self;

for i = 1:length(ctree)
	if any(strfind(ctree{i},'('))
		a = strfind(ctree{i},'(');
		z = strfind(ctree{i},')');
		idx = str2double(ctree{i}(a+1:z-1));
		V = V.(ctree{i}(1:a-1))(idx);
	else
		V = V.(ctree{i});
	end
end
