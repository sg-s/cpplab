% follows a cpplab tree up to
% the source and hashes that

function hashSource(self)

if length(self) > 1
	for i = 1:length(self)
		self(i).hashSource;
	end
	return
end


if ~isempty(self.Children)
	self.shallowHash;
end

if isempty(self.parent)
else
	hashSource(self.parent);
end
