%{ 
                   _       _     
  ___  _     _    | | __ _| |__  
 / __|| |_ _| |_  | |/ _` | '_ \ 
| (_|_   _|_   _| | | (_| | |_) |
 \___||_|   |_|   |_|\__,_|_.__/ 


### shallowHash

**Syntax**

```
C.shallowHash
```

**Description**

`shallowHash` computes the hash of a cpplab object using
the hashes of its children. Hashes are MD5 hashes computed
using GetMD5

!!! info "See Also"
    ->cpplab.add
    ->cpplab.addNoHash

%}


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


H = cell(length(self.Children)+1);

for i = length(self.Children):-1:1
	if length(self.(self.Children{i})) == 1
		H{i} = self.(self.Children{i}).hash;
	elseif  length(self.(self.Children{i})) == 0
		H{i} = repmat('0',1,32);
	else
		error('Found a vector of cpplab children, which cannot be hashed yet.')
	end
	
end

if isempty(self.cpp_hash)
	H{end} = repmat('0',1,32);
else
	H{end} = self.cpp_hash;
end


self.hash = GetMD5([H{:}]);