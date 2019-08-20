
%                    _       _     
%   ___  _     _    | | __ _| |__
%  / __|| |_ _| |_  | |/ _` | '_ \
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/
%
% a simple class to link MATLAB to C++
% Srinivas Gorur-Shandilya
% https://github.com/sg-s/cpplab




classdef  cpplab < dynamicprops  & matlab.mixin.CustomDisplay

properties (SetAccess = protected)
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

	hash
	cpp_hash

	
end % end protected props


properties (Access = private)
	dynamic_prop_handle
	parent
end

properties
	Children
end


methods



	function self = cpplab(hpp_path, varargin)

		% check that GetMd5 works and is installed
		[~,~,ext]=fileparts(which('hashlib.md5hash'));
		if ~strcmp(['.' mexext,],ext)
			if strcmp(ext,'.m')
				assert(exist('+hashlib/md5hash.c') == 2,'Could not located hashlib.md5hash.c on the path')
				hashlib.md5compile('hashlib.md5hash.c');
			else
				error('Could not find hashlib.md5hash on the path.')
			end
		end

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

		self.cpp_hash = hashlib.md5hash(hpp_path,'File');
		self.hash = self.cpp_hash;

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

			self.cpp_class_name = pathlib.name(hpp_path);
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

		h = self.cpp_hash;
		if isempty(self.cpp_class_name)
			return
		end

		url = ['matlab:edit(' char(39) self.cpp_class_path  char(39) ')'];
		fprintf(['' ' <a href="' url '">' self.cpp_class_name '</a> object (' h(1:7) ') with:\n\n'])

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
			elseif strcmp(props{i},'Children')
				continue
			elseif strcmp(props{i},'dynamic_prop_handle')
				continue

			end
			disp_string = ['  ' props{i} ' : '];
			if length(props{i}) < max_len
				disp_string = [repmat(' ',1,  max_len - length(props{i})) disp_string];
			end

			if isa(self.(props{i}),'cpplab')
			else
				if isnumeric(self.(props{i})) 
					disp_string = [disp_string mat2str(self.(props{i}))];
				elseif strcmp(props{i},'hash')
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
				
				url = ['matlab:' inputname(1) '.' props{i}];
				disp(disp_string)
				fprintf(['\b<a href="' url '">' self.(props{i}).cpp_class_name '</a> object\n'])
			else

			end
		end

	end

end % end protected methods


end % end classdef
