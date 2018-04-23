%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
% generates hash of object from header files

function sha1hash(self)


% figure out if we should use dataHash or openssl
data_hash_ok = false;
open_ssl_ok = false;
try
	if exist([fileparts(which(mfilename)) filesep 'hash_engine.cpplab']) == 0
		salt_path = [fileparts(which(mfilename)) filesep 'salt.cpplab'];
		salt_hash = 'b064f8c6d999dcc78cd196f4717c627f0a3a04b3';


		if strcmp(dataHash_sha1(salt_path),salt_hash)
			data_hash_ok = true;
		end

		if strcmp(openssl_sha1(salt_path),salt_hash)
			open_ssl_ok = true;
		end
		save([fileparts(which(mfilename)) filesep 'hash_engine.cpplab'],'data_hash_ok','open_ssl_ok')

	else
		load([fileparts(which(mfilename)) filesep 'hash_engine.cpplab'],'-mat')
	end
catch
end

if ~data_hash_ok & ~open_ssl_ok
	warning('Hashing not supported on this platform. Use with caution')
	self.hash = repmat('0',1,40);
	return
end

header_files = self.generateHeaders;
header_files(cellfun(@isempty,header_files)) = [];

for i = length(header_files):-1:1
	if data_hash_ok
		h = dataHash_sha1(header_files{i});
	else
		h = openssl_sha1(header_files{i});
	end
	H{i} = h;
end


if data_hash_ok && ismac
	options.Method = 'SHA1';
	options.Input = 'bin';
	H = dataHash([H{:}],options);
elseif ispc
	if length(H) > 1
		options.Method = 'SHA1';
		options.Input = 'char';
		H = dataHash([H{:}],options);
	end
else
	[e,o] = system(['echo ' [H{:}] '| openssl sha1']);
	H = strrep(o,' ','');
	H = strtrim(H);

	if length(H) > 40
		H = H(end-39:end);
	elseif length(H) < 40
		error('Error determining hash!')
	end

end

self.hash = H;


% hash using dataHash
function h = dataHash_sha1(file_path)
	options.Method = 'SHA1';
	options.Input = 'file';
	h = dataHash(file_path,options);
end

% hash using openssl
function h = openssl_sha1(file_path)

	[e,h] = system(['openssl sha1 "' file_path '"']);

	assert(e==0,'Something went wrong using openSSL')

	h = strrep(h,' ','');
	h = strtrim(h);
	if length(h) > 40
		h = h(end-39:end);
	elseif length(h) < 40
		error('Error determining hash!')
	end

end

end



