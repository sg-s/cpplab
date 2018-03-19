%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
%
function V = get(self,thing)

ctree = strsplit(thing,'.');
V = self;
for i = 1:length(ctree)
	V = V.(ctree{i});
end