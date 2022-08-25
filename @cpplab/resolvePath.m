
%                    _       _     
%   ___  _     _    | | __ _| |__
%  / __|| |_ _| |_  | |/ _` | '_ \
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/
%
%
% ### resolvePath
%
% **Syntax**
%
% ```
% cpplab.resolvePath('search_string')
% file_loc = cpplab.resolvePath('search_string')
% [~,all_files] = cpplab.resolvePath()
% ```
%
% **Description**
%
% - **`cpplab.resolvePath('search_string')`** searches for a C++ file in the cache that matches the search string. If nothing is found in the cache, the cache is rebuilt, and folders on the MATLAB path are searched for C++ header files. If more than one file is found, the first file found is displayed.
% - **`file_loc = cpplab.resolvePath('search_string')`** searches for a C++ file in the cache that matches the search string. If nothing is found in the cache, the cache is rebuilt, and folders on the MATLAB path are searched for C++ header files. If more than one file is found, the first file found is returned.
% - **`[~,all_files] = cpplab.resolvePath()`** A cell array containing the paths to all C++ header files in the cache is returned. Nothing is actually searched, so you can call this method with no arguments -- the arguments are ignored.
%
% !!! warning
%     Do not call resolvePath with two arguments. The shallow flag is meant for internal use.
%
%
% !!! info "See Also"
%     ->cpplab.add
%     ->cpplab.search
%     ->cpplab.find



function [resolved_p, hpp_files] = resolvePath(p, shallow)

if nargin < 2
	shallow = false;
end

% remove leading and trailing whitespace
p = strip(p);


resolved_p = [];
cache_path = fullfile(filelib.cachePath('cpplab'), 'paths.cpplab');

if exist(cache_path) == 2
	hpp_files = filelib.read(cache_path);
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
idx = filelib.find(hpp_files,p);

if shallow
	assert(length(idx) == 1,'[cpplab::resolvePath] could not resolve path. Try calling resolvePath without the shallow flag ')
	resolved_p = hpp_files{idx};
	return
end

if isempty(idx)

	cpplab.rebuildCache();
	hpp_files = filelib.read(cache_path);
	idx = filelib.find(hpp_files,p);
end

if length(idx) > 1
	idx = idx(1);
end


assert(length(idx) == 1,['[cpplab::resolvePath] could not resolve path while looking for object: ' p] )
resolved_p = hpp_files{idx};
