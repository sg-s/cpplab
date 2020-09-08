
%                    _       _     
%   ___  _     _    | | __ _| |__
%  / __|| |_ _| |_  | |/ _` | '_ \
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/
%
%
% ### cachePath
%
% **Syntax**
%
% ```
% cpplab.cachePath
% ```
%
% **Description**
%
% This static method returns the path to a safe, writeable location
% where we can store the cache. Should work on all platforms, including 
% MATLAB online

function cache_path = cachePath()

if isempty(userpath)
	userpath('reset');
end


cache_path = fullfile(userpath,'cpplab');

if ~exist(cache_path,'dir')
	mkdir(cache_path)
end
