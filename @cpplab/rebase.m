%{ 
                   _       _     
  ___  _     _    | | __ _| |__  
 / __|| |_ _| |_  | |/ _` | '_ \ 
| (_|_   _|_   _| | | (_| | |_) |
 \___||_|   |_|   |_|\__,_|_.__/ 


### rebase

**Syntax**

```
C.rebase
```

**Description**

`rebase` traverses a nested cpplab object tree, and checks that the `cpp_class_path` of every cpplab object in the tree resolves correctly. If it doesn't, it calls `resolvePath` to identify and link to the correct C++ file wherever it may be on your computer. MD5 hashing is used to ensure that the correct C++ file is linked against. If no C++ file with the correct hash is found, an error is thrown. 

You will need to call this method if you save a cpplab object to disk, move it to a different computer, and load it there. 

!!! info "See Also"
    ->cpplab.resolvePath
    ->cpplab.search

%}

function rebase(self)

% check that GetMD5 has been compiled
temp = which('hashlib.md5hash');
if isempty(temp)
	hashlib.md5compile;
end
[~,~,ext] = fileparts(temp);
if ~strcmp(ext,['.' mexext])
	hashlib.md5compile;
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
		assert(strcmp(self.cpp_hash,hashlib.md5hash(new_path,'File')),'Hashes do not match! This means the C++ file that corresponds to this object cannot be identified or located.')

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