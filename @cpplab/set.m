%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
%
function set(self,thing,value)

ctree = strsplit(thing,'.');
V = self;
for i = 1:length(ctree)-1
	V = V.(ctree{i});
end
V.(ctree{end}) = value;
