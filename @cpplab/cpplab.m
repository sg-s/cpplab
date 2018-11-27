%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
% cpplab
% cpplab is a MATLAB class that allows you to bind
% classes and types defined in C++ code to bonafide
% MATLAB objects

classdef  cpplab < dynamicprops  & matlab.mixin.CustomDisplay

properties (SetAccess = private)
	cpp_class_name
	cpp_class_path
	cpp_constructor_signature
	cpp_class_parent
	cpp_child_functions
	cpp_lab_real_names
	cpp_lab_names
	cpp_lab_real_names_hash
	cpp_lab_is_relational
	hidden_props
end % end props

properties
	hash
	skip_hash@logical = false;
end


methods

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
	end
		



	function self = cpplab(hpp_path, varargin)

		if nargin == 0
			return
		end

		d = dbstack;
		if any(strcmp({d.name},'copy'))
			return
		end

		% resolve the path
		if exist(hpp_path,'file') ~= 2
			% search in path 
			hpp_path = cpplab.resolvePath(hpp_path);
		end

		self.hash = GetMD5(hpp_path,'File');

		cache_name = [fileparts(fileparts(which(mfilename))) filesep 'cache' filesep self.hash '.cpplab'];

		if exist(cache_name,'file') == 2
			% already cached. load that. 
			load(cache_name,'-mat');
		else
			% cache miss
			[prop_names, prop_types, default_values] = self.readCPPClass(hpp_path);
			self.cpp_constructor_signature = prop_names;

			% to do: figure out how to type dynamic props 
			for i = 1:length(prop_names)
				p = self.addprop(prop_names{i});
				p.NonCopyable = false;
				self.(prop_names{i}) = default_values(i);
			end

			self.cpp_class_name = pathEnd(hpp_path);
			self.cpp_class_path = hpp_path;

			% read child functions of this class 
			self.readChildFunctions();


			dir_name = [fileparts(fileparts(which(mfilename))) filesep 'cache'];
			if exist(dir_name,'file') ~= 7
				mkdir(dir_name)
			end

			save(cache_name,'self','prop_names','-v7.3','-nocompression');
		end


		% validate and accept options
		lv = length(varargin);
		if round(lv/2)*2 == lv % iseven(lv)

			% half of them have to be char

			for ii = 1:2:length(varargin)-1
				temp = varargin{ii};
		    	if ischar(temp)
			    	if ~any(find(strcmp(temp,prop_names))) 
			    		disp(['Unknown option: ' temp])
			    		disp('The allowed options are:')
			    		disp(prop_names)
			    		error('UNKNOWN OPTION')
			    	else
			    		self.(temp) = varargin{ii+1};
			    	end
			    else
			    	error('Expected argument to be a char')
		    	end
		    end
		else
			error('Inputs need to be name value pairs')
		end

	end % end constructor


	function setHiddenProps(self,hidden_props)
		self.hidden_props = hidden_props;
	end




end % end normal methods


methods (Static)

	varargout = search(pattern);
	rebuildCache(path_names)
	[resolved_p, hpp_files] = resolvePath(p, shallow)

end % end static methods


methods (Access = protected)
	
	function displayScalarObject(self)

		url = ['matlab:edit(' inputname(1) '.cpp_class_path)'];
		fprintf(['' ' <a href="' url '">' self.cpp_class_name '</a> object with:\n\n'])

		props = properties(self);
		max_len = 0;
		for i = 1:length(props)
			if any(strfind(props{i},'cpp_'))
				continue
				
			end
			max_len = max([length(props{i}) max_len]);
		end

		for i = 1:length(props)
			if any(strfind(props{i},'cpp_'))
				continue	
			elseif strcmp(props{i},'hidden_props')
				continue
			end
			disp_string = ['  ' props{i} ' : '];
			if length(props{i}) < max_len
				disp_string = [repmat(' ',1,  max_len - length(props{i})) disp_string];
			end

			if isa(self.(props{i}),'cpplab')
			else
				if isnumeric(self.(props{i})) && ~strcmp(props{i},'skip_hash')
					disp_string = [disp_string mat2str(self.(props{i}))];
				elseif strcmp(props{i},'hash')
					h = (self.(props{i}));
					disp_string = [disp_string h(1:7)];
				elseif strcmp(props{i},'skip_hash')
					continue
				else
					disp_string = [disp_string class(self.(props{i}))];
				end
				disp(disp_string);
			end
		end

		for i = 1:length(props)
			if any(strfind(props{i},'cpp_'))
				continue	
			end
			disp_string = ['  ' props{i} ' : '];
			if length(props{i}) < max_len
				disp_string = [repmat(' ',1,  max_len - length(props{i})) disp_string];
			end

			if isa(self.(props{i}),'cpplab')
				child_type = self.(props{i}).cpp_class_name;
				url = ['matlab:' inputname(1) '.' props{i}];
				disp(disp_string)
				fprintf(['\b<a href="' url '">' self.(props{i}).cpp_class_name '</a> object\n'])
			else
				
			end
		end

	end

end % end protected methods


end % end classdef
