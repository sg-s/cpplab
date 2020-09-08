
%                    _       _     
%   ___  _     _    | | __ _| |__
%  / __|| |_ _| |_  | |/ _` | '_ \
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/
%
%
% ### search
%
% **Syntax**
%
% ```
% cpplab.search('search_string')
% cpplab.search('*search*pattern*')
% objects = cpplab.search('*search*pattern*');
% ```
%
% **Description**
%
% `search` is a static method that looks for C++ files that match certain criterion.
%
% - **`cpplab.search('search_string')`** searches the `paths.cpplab` cache for C++ objects whose location contains `search_string`, and displays all objects that match this in the command prompt
% - **`cpplab.search('*search*pattern*')`** searches the `paths.cpplab` cache for C++ objects whose location contains the specified search pattern, allowing for wild cards, and displays all objects that match this in the command prompt.
% - **`objects = cpplab.search('*search*pattern*');`** searches the `paths.cpplab` cache for C++ objects whose location contains the specified search pattern, allowing for wild cards, and returns them in a cell array. Nothing is written to STDOUT.
%
%
% !!! info "See Also"
%     ->cpplab.find




function varargout = search(pattern)

files = strsplit(fileread(fullfile(filelib.cachePath('cpplab'),'paths.cpplab')),'\n')';
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

idx = all(~diff(char(objects(:))));
common_stub = objects{1}(1:find(~idx,1,'first')-1);

for i = 1:length(objects)
	objects{i} = strrep(objects{i},common_stub,'');
end


if nargout == 1
	varargout{1} = objects;
else
	
	disp('------------------------------------------------------------------------------------')
	disp(' Name                   Parent Class        Object Information')
	disp('------------------------------------------------------------------------------------')

	for i = 1:length(objects)
		try
			temp = cpplab(objects{i});
			[~,name]=fileparts(objects{i});

			padding = 0;
			if length(name) > 23
				name = name(1:23);
			else
				padding = 23 - length(name);
			end

			url = ['matlab:edit(' char(39) temp.cpp_class_path  char(39) ')'];
			fprintf(['' ' <a href="' url '">' name '</a>'])

			for j = 1:padding
				fprintf(' ')
			end

			
			fprintf(strlib.fix(temp.cpp_class_parent,20))
			fprintf(strlib.fix(temp.docstring,50))
			fprintf('\n')
		catch
		end
	end

	disp('------------------------------------------------------------------------------------')


end
