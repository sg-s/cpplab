%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
% 
% goes through the entire tree and re-writes
% all cpp_class_paths

function rebase(self)



props = sort(properties(self));

for i = 1:length(props)

	if any(strfind(props{i},'cpp_class_path'))
		new_path = '';
		old_path = self.cpp_class_path;
		if any(strfind(old_path,'/'))
			old_file_sep = '/';
		else
			old_file_sep = '\';
		end
		if isempty(old_path)
			return
		end
		old_path = strsplit(old_path,old_file_sep);


		for i = 1:length(old_path)
			try
				new_path = cpplab.resolvePath(strjoin(old_path(i:end),old_file_sep),true);
				break
			catch err
				if any(strfind(err.message,'could not resolve path'))
					% OK, no worries
				else
					error('Unknown error')
				end
			end
			
		end
		disp([strjoin(old_path,old_file_sep) '->' new_path ])
		self.cpp_class_path = new_path;


	end



	if length(self.(props{i})) > 1 && isa(self.(props{i}),'cpplab')
		% vector of cpplab objects 
		for j = 1:length(self.(props{i}))
			rebase(self.(props{i})(j));
		end

	elseif  isa(self.(props{i}),'cpplab')
		rebase(self.(props{i}));
	end

end