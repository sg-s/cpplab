% follows a cpplab tree up to
% the source and hashes that

function hashSource(self)

if isempty(self.parent)
	self.md5hash;
else
	hashSource(self.parent);
end
