
%                    _       _     
%   ___  _     _    | | __ _| |__
%  / __|| |_ _| |_  | |/ _` | '_ \
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/
%
%
% ### addNoHash
%
% adds a cpplab object to another, but does not
% update the hashes of the object being added to.
% Do not use this method, use `add()` instead.
%
% !!! info "See Also"
%     ->cpplab.add



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

% tell the child what its name is
if ~isempty(thing.cpp_lab_name) && ~strcmp(thing.cpp_lab_name,name)
	% mismatch between what the thing is named and what it should
	% be named. This typically happens when copying objects
	for i = 1:length(thing.cpp_lab_real_names)
		thing.cpp_lab_real_names{i} = strrep(thing.cpp_lab_real_names{i},thing.cpp_lab_name, name);
	end
end
thing.cpp_lab_name = name;


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


% also update the cpp_lab_real_names property on the parent
props = properties(thing);
keep_this = false(length(props),1);


for i = 1:length(props)
	if any(strfind(props{i},'cpp_'))
		continue
	elseif strcmp(props{i},'hidden_props')
		continue
	elseif strcmp(props{i},'hash')
		continue
	elseif strcmp(props{i},'Children')
		continue
	elseif strcmp(props{i},'dynamic_prop_handle')
		continue
	elseif isa(thing.(props{i}),'cpplab')
		continue
	end
	keep_this(i) = true;
	props{i} = [name '.' props{i}];
end

if ~isempty(thing.cpp_lab_real_names)
	thing_real_names = thing.cpp_lab_real_names;
	for i = 1:length(thing_real_names)
		thing_real_names{i} = [thing.cpp_lab_name '.' thing_real_names{i}];
	end
	add_these = unique([props(keep_this); thing_real_names]);
else
	add_these = props(keep_this);
end


if isempty(self.cpp_lab_real_names)
	self.cpp_lab_real_names = sort(add_these);
else
	% unique also sorts
	self.cpp_lab_real_names = unique([self.cpp_lab_real_names; add_these]);
end

% propagate this upwards
if ~isempty(self.parent)
	updateRealNames(self.parent,self.cpp_lab_name,add_these)
end