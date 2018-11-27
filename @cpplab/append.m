% appends a cpplab object 
% to an existing one to 
% make a vector

function self = append(self, new_obj)
if length(self) == 0
	self = new_obj;

else
	self = [self; new_obj];
end

self.hashSource;