 
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

type_ok = true;

% figure out the lowest dot notation level
z = find(strcmp({S.type},'.'),1,'last');
if z == 1 & strcmp(class(self),'cpplab')
	type_ok = isa(value,'double') || isa(value,'cpplab') || isa(value,'function_handle');
	assert(isscalar(value),['Error assigning value to ' strjoin({S(1:z).subs},'.') , ' :: value must be a scalar  '])
elseif z == 1
	% self is of some derived class, so anything goes
	type_ok = true;
elseif  strcmp(class(subsref(self,S(1:z-1))),'cpplab') && ~isempty(value)
	% derived class, but we may be indexing into a cpplab object
	
	assert(isscalar(value),['Error assigning value to ' strjoin({S(1:z).subs},'.') , ' :: value must be a scalar.  '])
	type_ok = isa(value,'double') || isa(value,'cpplab') || isa(value,'function_handle');

elseif  strcmp(class(subsref(self,S(1:z-1))),'cpplab') && isempty(value)
	error('You cannot assign an empty vector a cpplab object. If you meant to remove this object from the tree, use the "destroy" method')

elseif isa(subsref(self,S(1:z-1)),'struct')
	% assigning to a struct, so anything goes?
	self = builtin('subsasgn',self,S,value);
	return
end


assert(type_ok,['Error assigning value to ' strjoin({S(1:z).subs},'.') , ' :: value must be a scalar.  '])

if isa(subsref(self,S),'cpplab')
	temp = subsref(self,S);
	error(['You cannot overwrite an object of type "' temp.cpp_class_name '" with a scalar'])
elseif isa(subsref(self,S),'double')
	assert(isa(value,'double'),['You cannot replace an object that has type "double" with anything that is not a double'])
end

self = builtin('subsasgn',self,S,value);
