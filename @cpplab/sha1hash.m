%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
% generates hash of object and all its children

function sha1hash(self)

try
	GetMD5(0,'Array');
catch
	disp('Compiling GetMD5...this will happen only once.')
	GetMD5;
end


% if this is somehow a vector of cpplab objects,
% run it on a loop
if length(self) > 1
	for i = 1:length(self)
		self(i).sha1hash;
	end
	return
end

% if it has no children, just hash it if need be

if isempty(self.Children) & isempty(self.hash)

	if isempty(self.cpp_class_path)
		return
	end
	self.hash = GetMD5(self.cpp_class_path,'File');
	return
elseif isempty(self.Children) & ~isempty(self.hash)
	% already has hash, no children, so don't do anything
	return
elseif ~isempty(self.Children) 
	% it has children. so whether it has a hash or not,
	% rehash all children, then rehash this object
	for i = 1:length(self.Children)
		self.(self.Children{i}).sha1hash;
	end

	% now we need to collect hashes from all children
	H = self.getAllHashes;
end


H = GetMD5([H{:}]);
self.hash = H;


end



