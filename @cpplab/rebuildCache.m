%{ 
                   _       _     
  ___  _     _    | | __ _| |__  
 / __|| |_ _| |_  | |/ _` | '_ \ 
| (_|_   _|_   _| | | (_| | |_) |
 \___||_|   |_|   |_|\__,_|_.__/ 


### rebuildCache

**Syntax**

```
cpplab.rebuildCache
```

**Description**

This static method does two things:

1. searches the MATLAB path and containing folders for C++ header files (with the extension .hpp), and makes a list of them that is stored in a file called `paths.cpplab`
2. Destroys the `cache` folder, including all files in it, in the `cpplab` directory. 

If you find that you are getting errors where cpplab complains it can't find certain files, a good first step is to run this method to rebuild the cache. 

!!! info "See Also"
    ->cpplab.resolvePath
    ->cpplab.search

%}


function rebuildCache(path_names)

if nargin == 0
	path_names = strsplit(path,pathsep);
else
	assert(iscell(path_names),'Input must be a cell array');

	% check that these path_names exist
	for i = 1:length(path_names)
		assert(exist(path_names{i},'dir') == 7,[path_names{i} ' not found'])
		temp = dir(path_names{i});
		path_names{i} = temp(1).folder;
	end
end



cache_path = [fileparts(fileparts(which(mfilename))) filesep 'paths.cpplab'];

% rebuild the cache
hpp_files = {};
for i = 1:length(path_names)
	if any(strfind(path_names{i},matlabroot))
		continue
	end
	allfiles = filelib.getAll(path_names{i});
	for j = 1:length(allfiles)
		if strcmp(allfiles{j}(end-3:end),'.hpp')
			hpp_files{end+1} = allfiles{j};
		end
	end
end
filelib.write(cache_path,hpp_files);

% nuke the cache of saved cpplab files
dir_name = [fileparts(fileparts(which(mfilename))) filesep 'cache'];
if exist(dir_name,'file') == 7
	rmdir(dir_name,'s')
end
mkdir(dir_name)