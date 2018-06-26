%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
%
% generic method that adds something as a child to this object
function self = add(self,varargin)

self = addNoHash(self,varargin{:});


v = evalin('caller','whos');
hash_these = false(length(v));
for i = 1:length(v)
	if strcmp(v(i).class,'cpplab')
		hash_these(i) = true;
	end
	S = superclasses(v(i).class);
	if ~isempty(S)
		if any(strcmp(S,'cpplab'))
			hash_these(i) = true;
		end
	end
end


% ok, now ask these objects to hash
for i = 1:length(v)
	if hash_these(i)
		if strcmp(v(i).name,'ans')
			continue
		end
		evalin('caller',[v(i).name '.md5hash;']);
	end
end
