%{ 
                   _       _     
  ___  _     _    | | __ _| |__  
 / __|| |_ _| |_  | |/ _` | '_ \ 
| (_|_   _|_   _| | | (_| | |_) |
 \___||_|   |_|   |_|\__,_|_.__/ 


### addNoHash

adds a cpplab object to another, but does not 
update the hashes of the object being added to.
Do not use this method, use `add()` instead. 

!!! info "See Also"
    ->cpplab.add

%}

function addNoHash(self,varargin)
switch length(varargin)
case 1

	if ischar(varargin{1})
		thing = cpplab(varargin{1});
		name = thing.cpp_class_name;
	elseif (isa(varargin{1},'cpplab'))
		name = varargin{1}.cpp_class_name;
		thing = varargin{1};
	else
		error('One argument provided, which is neither a string nor a cpplab object. I dont know what you want me to do')
	end

	
case 2
	if isa(varargin{2},'cpplab') && isa(varargin{1},'char')
		name = varargin{1};
		thing = varargin{2};
	elseif isa(varargin{1},'cpplab') && isa(varargin{2},'char')
		name = varargin{2};
		thing = varargin{1};
	elseif isa(varargin{1},'cpplab') && isa(varargin{2},'cpplab')
		error('cpplab::add "add one object at a time"')
	elseif isa(varargin{1},'char') && isa(varargin{2},'char')
		% interpret the first string to be the type, and the second to be the name
		name = varargin{2};
		thing = cpplab(varargin{1});
	else
		error('cpplab::add "I dont know what you want me to do"')
	end
otherwise

	if isa(varargin{1},'cpplab')
		error('A cpplab object was detected. If you want to add a cpplab object to another one, you must first configure it, then add it.')

	end


	lv = length(varargin);
	if round(lv/2)*2 == lv % iseven (lv)
		name = varargin{2};
		hpp_path = varargin{1};
		varargin(1:2) = [];
	else
		hpp_path = varargin{1};
		varargin(1) = [];
	end

	thing = cpplab(hpp_path,varargin{:});
	if ~exist('name','var')
		name = thing.cpp_class_name;
	end
end


% wire up connectors

p = self.addprop(name);
p.NonCopyable = false;
self.(name) = thing;
p.Hidden = false;
self.(name).dynamic_prop_handle = p;

self.(name).parent = self;

if isempty(self.Children)
	self.Children = {name};
else
	self.Children = sort([self.Children name]);
end
