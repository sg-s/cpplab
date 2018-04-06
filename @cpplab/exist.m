%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
% check if something exists in the tree
% 
function TF = exist(self,thing)

TF = false;

try
	temp = self.get(thing);
	TF = true;
end