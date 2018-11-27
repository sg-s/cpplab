% hashes this object
% together with its children
% that's it
% it doesn't go any deeper
% 
function shallowHash(self)

if length(self) == 0
	return
end

if length(self) > 1
	for i = 1:length(self)
		self(i).shallowHash;
	end
	return
end


for i = length(self.Children):-1:1
	if length(self.(self.Children{i})) == 1
		H{i} = self.(self.Children{i}).hash;
	elseif  length(self.(self.Children{i})) == 0
		H{i} = repmat('0',1,32);
	else
		disp('vector of cpplab children')
		keyboard
	end
	
end

if isempty(self.cpp_hash)
	H{end+1} = repmat('0',1,32);
end

self.hash = GetMD5([H{:}]);