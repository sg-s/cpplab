%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
% generates hash of object from header files

function H = hash(self)


header_files = self.generateHeaders;

header_files(cellfun(@isempty,header_files)) = [];

for i = length(header_files):-1:1

	[e,h] = system(['openssl sha1 "' header_files{i} '"']);

	assert(e==0,'Something went wrong using openSSL')
	z = strfind(h,'=');
	H{i} = strtrim(h(z+2:end));

end

[e,o] = system(['echo ' [H{:}] '| openssl sha1']);

H = strrep(o,' ','');
H = strtrim(H);

if length(H) > 40
	H = H(end-39:end);
elseif length(H) < 40
	error('Error determining hash!')
end




