%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
%

classdef  cpplab < dynamicprops

properties (SetAccess = private)
	cpp_class_name
	cpp_class_path
	cpp_constructor_signature
	cpp_class_parent
end % end props


methods
	function self = cpplab(hpp_path, varargin)

		if nargin == 0
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
			self.addprop(prop_names{i});
			self.(prop_names{i}) = NaN;
		end

		self.cpp_class_name = pathEnd(hpp_path);
		self.cpp_class_path = hpp_path;


		% validate and accept options
		if iseven(length(varargin))
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
		    	end
		    end
		else
			error('Inputs need to be name value pairs')
		end


	end % end constructor



	% generic method that adds something as a child to this object
	function self = add(self,name,thing)
		self.addprop(name);
		self.(name) = thing;
	end


end % end normal methods


methods (Static)
	function addPath(p)
		L = lineRead(joinPath(fileparts(fileparts(which(mfilename))),'path.cpplab'));
		if any(lineFind(L,p))
			return
		end
		L = [L p];
		lineWrite(joinPath(fileparts(fileparts(which(mfilename))),'path.cpplab'),L);
	end % end addPath


	function resolved_p = resolvePath(p)
		L = lineRead(joinPath(fileparts(fileparts(which(mfilename))),'path.cpplab'));
		resolved_p = '';
		for i = 1:length(L)
			allfiles = getAllFiles(L{i});
			allfiles(~cellfun(@(x) any(strfind(x,'.hpp')),allfiles)) = [];
			idx = lineFind(allfiles,p);
			if ~isempty(idx)
				resolved_p = allfiles{idx};
				return
			end

		end
		error('cpplab::Could not resolve path')

	end

end


end % end classdef
