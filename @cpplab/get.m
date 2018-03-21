%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
%
function V = get(self,thing)

if iscell(thing)
	V = NaN(length(thing),1);
	for i = 1:length(V)
		V(i) = self.get(thing{i});
	end
	return
end

ctree = strsplit(thing,'.');
V = self;
try
	for i = 1:length(ctree)
		V = V.(ctree{i});
	end
catch
	V = NaN;
end