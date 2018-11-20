function [resolved_p, hpp_files] = resolvePath(p, shallow)

if nargin < 2
	shallow = false;
end


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
	
	cpplab.rebuildCache();

	idx = lineFind(hpp_files,p);
end

if length(idx) > 1
	idx = idx(1);
end
assert(length(idx) == 1,'cpplab::could not resolve path')
resolved_p = hpp_files{idx};

