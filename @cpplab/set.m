%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
%
function set(self,thing,value)

if iscell(thing)
	if length(value) == 1
		value = repmat(value,length(thing),1);
	end
	for i = 1:length(thing)
		self.set(thing{i},value(i))
	end
	return
end

ctree = strsplit(thing,'.');
V = self;

for i = 1:length(ctree)
	if any(strfind(ctree{i},'('))
		fn = ctree{i}(1:strfind(ctree{i},'(')-1);
		a = strfind(ctree{i},'(') + 1;
		z = strfind(ctree{i},')') - 1;
		fidx = str2double(ctree{i}(a:z));
		if i < length(ctree)
			V = V.(fn)(fidx);
		else
			V.(fn)(fidx) = value;
		end
	else
		if i < length(ctree)
			V = V.(ctree{i});
		else
			V.(ctree{end}) = value;
		end
	end
end



