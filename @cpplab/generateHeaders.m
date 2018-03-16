%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
%
function H = generateHeaders(self)

H = {};
H{1} = self.cpp_class_path;

props = properties(self);
for i = 1:length(props)
	if isa(self.(props{i}),'cpplab')
		H = [H; self.(props{i}).generateHeaders];
	end
end
