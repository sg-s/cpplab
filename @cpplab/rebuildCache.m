
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
	allfiles = getAllFiles(path_names{i});
	for j = 1:length(allfiles)
		if strcmp(allfiles{j}(end-3:end),'.hpp')
			hpp_files{end+1} = allfiles{j};
		end
	end
end
lineWrite(cache_path,hpp_files);

% nuke the cache of saved cpplab files
dir_name = [fileparts(fileparts(which(mfilename))) filesep 'cache'];
if exist(dir_name,'file') == 7
	rmdir(dir_name,'s')
end
mkdir(dir_name)