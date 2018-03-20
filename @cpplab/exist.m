%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
% check if something exists in the tree
% 
function TF = exist(self,thing)

ctree = strsplit(thing,'.');
V = self;
for i = 1:length(ctree)-1
	V = V.(ctree{i});
end

TF = any(strcmp(V.Children,ctree{end}));