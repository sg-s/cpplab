%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
% searches the paths.cpplab cache for C++ header files

function varargout = search(pattern)

files = strsplit(fileread('paths.cpplab'),'\n')';
files(cellfun(@isempty,files)) = [];
 
if strcmp(pattern,'') | strcmp(pattern,'*')
	objects = files;
else

	pattern = strrep(pattern,'/','\/');
	pattern = strrep(pattern,'+','\+');

	starts = regexpi(files, pattern);
	iMatch = ~cellfun(@isempty, starts);
	idx = find(iMatch);

	objects = files(idx);

end

if length(objects) == 0
	disp('No objects found')
	return
end

common_stub = objects{1}(all(~diff(char(objects(:)))));

for i = 1:length(objects)
	objects{i} = strrep(objects{i},common_stub,'');
end


if nargout == 1
	varargout{1} = objects;
else
	disp(objects)
end
