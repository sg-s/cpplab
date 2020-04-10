
%                    _       _     
%   ___  _     _    | | __ _| |__
%  / __|| |_ _| |_  | |/ _` | '_ \
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/
%
%
% ### readCPPClass
%
% **Syntax**
%
% ```
%  [class_members, input_types, default_values] = C.readCPPClass(cppfilename)
%
% ```
%
% **Description**
%
% Do not use this method.



function [class_members, input_types, default_values] = readCPPClass(self,cppfilename)

% check that it exists
assert(exist(cppfilename,'file') == 2,'C++ file not found.')

class_name = pathlib.name(cppfilename);
lc = length(class_name);
lines = filelib.read(cppfilename);

% find the lines where the class is declared
constructor_lines = [];
for i = 1:length(lines)
	this_line = strtrim(lines{i});
	if length(this_line) < lc + 1
		continue
	end
	if strcmp(strtrim(this_line(1:lc+1)),[class_name '('])
		constructor_lines = [constructor_lines; i];
	end
end


% find the longest constructor
[~,use_this] = max(cellfun(@length,lines(constructor_lines)));
constructor_lines = constructor_lines(use_this);
assert(length(constructor_lines) == 1, 'Expected exactly one constructor line; this was not what I found')


constructor_line = lines{constructor_lines};

classdef_line = lines{filelib.find(lines,['class ' class_name])};
if ~isempty(strfind(classdef_line,'public'))
	self.cpp_class_parent = strtrim(strrep(classdef_line(strfind(classdef_line,'public')+6:end),'{',''));
else
	self.cpp_class_parent = 'N/A';
end


% figure out the input variables to the constructor
input_variables = {};
input_types = {};

a = strfind(constructor_line,'(');
z = strfind(constructor_line(a:end),',');

while length(z) > 0
	z = z(1);
	this_input = strtrim(constructor_line(a+1:a+z-2));
	space_loc = strfind(this_input,' ');
	assert(length(space_loc)==1,'Expected exactly one space in this input')
	input_types = [input_types; strtrim(this_input(1:space_loc))];
	input_variables = [input_variables; strtrim(this_input(space_loc:end))];
	a = a+z;
	z = strfind(constructor_line(a:end),',');
end

% get the last one too
z = strfind(constructor_line(a:end),')'); z = z(1);
this_input = strtrim(constructor_line(a+1:a+z-2));
space_loc = strfind(this_input,' ');
assert(length(space_loc)==1,'Expected exactly one space in this input')
input_types = [input_types; strtrim(this_input(1:space_loc))];
input_variables = [input_variables; strtrim(this_input(space_loc:end))];


% assume that the input variables are class members with an underscore after them
class_members = input_variables;
for i = 1:length(class_members)
	class_members{i} = class_members{i}(1:end-1);
end


% now figure out the defaults
default_values = NaN(length(class_members),1);

for i = 1:length(class_members)

	r1 = [input_types{i} '\s*' class_members{i} '(\s|;|=)'];
	r2 = ['if(.+)isnan(.+)\(' class_members{i}  '\)(.+)' class_members{i} '(.+)=\s*(\-+)\d+'];
	r3 = ['if(.+)isnan(.+)\(' class_members{i}  '\)(.+)' class_members{i} '(.+)=\s*\d+'];


	for j = 1:length(lines)

		if any(strfind(lines{j},'=')) && any(regexp(lines{j},r1))
			default_values(i) = str2double(lines{j}(strfind(lines{j},'=')+1:strfind(lines{j},';')-1));

		elseif any(regexp(lines{j},r2))
			default_values(i) = str2double(lines{j}(strfind(lines{j},'=')+1:strfind(lines{j},';')-1));
		elseif any(regexp(lines{j},r3))
			default_values(i) = str2double(lines{j}(strfind(lines{j},'=')+1:strfind(lines{j},';')-1));

		end
	end
end


% now read the metadata
self.docstring = '';
self.sourceurl = '';
self.sourcename = '';

temp = filelib.find(lines,'component info');
if ~isempty(temp)
	temp = temp(1);
	self.docstring = lines{temp}(strfind(lines{temp},'component info')+16:end);

end

temp = filelib.find(lines,'component source');
if ~isempty(temp)
	temp = temp(1);
	self.sourcename = lines{temp}(strfind(lines{temp},'[')+1:strfind(lines{temp},']')-1);
	self.sourceurl = lines{temp}(strfind(lines{temp},'(')+1:strfind(lines{temp},')')-1);
end