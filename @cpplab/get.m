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
		value = self.get(thing{i});
		if isa(value,'function_handle')
			value = value();
		end
		V(i) = value;
	end
	return
end

ctree = strsplit(thing,'.');
V = self;

for i = 1:length(ctree)
	disp(V)
	V = V.(ctree{i});
end

