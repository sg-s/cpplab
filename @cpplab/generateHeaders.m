%{
%                    _       _     
%   ___  _     _    | | __ _| |__
%  / __|| |_ _| |_  | |/ _` | '_ \
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/
%
%
% ### generateHeaders
%
% **Syntax**
%
% ```
% H = C.generateHeaders
% ```
%
% **Description**
%
% Do not use this method.

%}

function H = generateHeaders(self)

H = {};
H{1} = self.cpp_class_path;

props = sort(properties(self));
for i = 1:length(props)
	if length(self.(props{i})) > 1 && isa(self.(props{i}),'cpplab')
		for j = 1:length(self.(props{i}))
			H = [H; self.(props{i})(j).generateHeaders];
		end
	elseif isa(self.(props{i}),'cpplab')
		H = [H; self.(props{i}).generateHeaders];
	end
end
