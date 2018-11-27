
% here, we are overloading the subscript assignation
% method built in to matlab to strongly type
% things that go into the cpplab tree 
function self = subsasgn(self, S, value)

type_ok = true;

% figure out the lowest dot notation level
z = find(strcmp({S.type},'.'),1,'last');
if z == 1 & strcmp(class(self),'cpplab')
	type_ok = isa(value,'double') || isa(value,'cpplab') || isa(value,'function_handle');
	assert(isscalar(value),['Error assigning value to ' strjoin({S(1:z).subs},'.') , ' :: value must be a scalar  '])
elseif z == 1
	% self is of some dervied class, so anything goes
	type_ok = true;
else
	% derived class, but we may be indexing into a cpplab object
	if  strcmp(class(subsref(self,S(1:z-1))),'cpplab')


		assert(isscalar(value),'Error assigning value. Value must be a scalar ')
		type_ok = isa(value,'double') || isa(value,'cpplab') || isa(value,'function_handle');

	end
end


assert(type_ok,'Error assigning value. Value must be a scalar ')

if isa(subsref(self,S),'cpplab')
	temp = subsref(self,S);
	error(['You cannot overwrite an object of type "' temp.cpp_class_name '" with a scalar'])
end

self = builtin('subsasgn',self,S,value);
