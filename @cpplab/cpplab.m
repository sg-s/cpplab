%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
%

classdef  cpplab < dynamicprops  & matlab.mixin.CustomDisplay

properties (SetAccess = private)
	cpp_class_name
	cpp_class_path
	cpp_constructor_signature
	cpp_class_parent
	cpp_child_functions
	cpp_lab_real_names
	cpp_lab_real_names_hash
	hidden_props
end % end props

properties
	hash
	skip_hash@logical = false;
end


methods
	function self = cpplab(hpp_path, varargin)

		if nargin == 0
			return
		end

		d = dbstack;
		if any(strcmp({d.name},'copy'))
			return
		end

		% resolve the path
		if exist(hpp_path,'file') == 2
			% all good
		else
			% search in path 
			hpp_path = cpplab.resolvePath(hpp_path);
		end

		
		[prop_names, prop_types] = self.readCPPClass(hpp_path);
		self.cpp_constructor_signature = prop_names;

		% to do: figure out how to type dynamic props 
		for i = 1:length(prop_names)
			p = self.addprop(prop_names{i});
			p.NonCopyable = false;
			self.(prop_names{i}) = NaN;
		end

		self.cpp_class_name = pathEnd(hpp_path);
		self.cpp_class_path = hpp_path;


		% read child functions of this class 
		self.readChildFunctions();


		% validate and accept options
		if iseven(length(varargin))

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

		self.md5hash;


	end % end constructor


	function setHiddenProps(self,hidden_props)
		self.hidden_props = hidden_props;
	end


end % end normal methods


methods (Static)


	function [resolved_p, hpp_files] = resolvePath(p, shallow)

		if nargin < 2
			shallow = false;
		end

		path_names = strsplit(path,pathsep);
		resolved_p = [];
		cache_path = [fileparts(fileparts(which(mfilename))) filesep 'paths.cpplab'];
		if exist(cache_path) == 2
			hpp_files = lineRead(cache_path);
		else
			hpp_files = {};
		end

		if nargout == 2
			return
		end

		if ispc
			p = strrep(p,'/','\');
		end

		% first search the cache
		idx = lineFind(hpp_files,p);

		if shallow
			assert(length(idx) == 1,'cpplab::could not resolve path')
			resolved_p = hpp_files{idx};
			return 
		end

		if isempty(idx)
			% rebuild the cache
			hpp_files = {};
			for i = 1:length(path_names)
				if any(strfind(path_names{i},matlabroot))
					continue
				end
				allfiles = getAllFiles(path_names{i});
				for j = 1:length(allfiles)
					if strcmp(allfiles{j}(end-3:end),'.hpp')
						hpp_files{end+1} = allfiles{j};
					end
				end
			end
			lineWrite(cache_path,hpp_files);
			idx = lineFind(hpp_files,p);
		end

		if length(idx) > 1
			idx = idx(1);
		end
		assert(length(idx) == 1,'cpplab::could not resolve path')
		resolved_p = hpp_files{idx};

	end
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
