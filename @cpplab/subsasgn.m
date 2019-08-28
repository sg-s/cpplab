 
%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 


% ### subsasgn

% **Syntax**

% ```
% subsasgn(self, S, value)
% ```


% **Description**

% `subsasgn` is an overloaded method of cpplab that 
% first checks that assignation that you're trying to do
% is legal. It prevents you from overwriting a cpplab object
% in a nested cpplab tree with a scalar, and prevents you
% from nesting vectors when it expects scalars. 


% !!! info "See Also"
%     ->cpplab.find
%     ->cpplab.get



function self = subsasgn(self, S, value)


% how many levels of dot notation are we at?
if length(S) > 1
	obj = subsref(self,S(1:end-1));
	if isa(obj,'cpplab')
		obj.subsasgn(S(end),value);
	else
		% not a cpplab object, so no rules apply
		self = builtin('subsasgn',self,S,value);
		return
	end
	return
end

% prevent overwriting protected members of cpplab
mc = metaclass(self);
idx = (strcmp({mc.PropertyList.Name},S.subs));
if any(idx)
	if ~strcmp(mc.PropertyList(idx).SetAccess,'public')
		error(['The property you are trying to change, "' S.subs '", is read only and cannot be changed'])
	end

	% check if there is a defined set method, and if so, defer to it
	if ~isempty(mc.PropertyList(idx).SetMethod)
		% call that
		mc.PropertyList(idx).SetMethod(self,value);
		return
	end

end

% at this point we can assume that self is a cpplab object
% and that we are allowed write access to the property


% get the value of the thing 
current_class = class(self.(S.subs));

% enforce scalar values for doubles
if isa(self.(S.subs),'double')
	err_msg = ['The value you are trying to assing has size ' mat2str(size(value)) ' but it must be a scalar'];

	assert(length(value)==1,err_msg)
end

% check that new value and old value are same class
err_msg = ['You cannot assign an object of class "' class(value) '" to an object of class "' current_class '"'];
assert(strcmp(class(value),current_class),err_msg)

% assign
self.(S.subs) = value;

