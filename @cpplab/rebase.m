%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
% 
% goes through the entire tree and re-writes
% all cpp_class_paths

function rebase(self)

% check that GetMD5 has been compiled
if exist('GetMD5','file') ~= 3
	GetMD5;
end


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
			continue
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
		%disp([strjoin(old_path,old_file_sep) '->' new_path ])

		% verify that the hash of the new C++ file matches
		assert(strcmp(self.cpp_hash,GetMD5(new_path,'File')),'Hashes do not match! This means the C++ file that corresponds to this object cannot be identified or located.')

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