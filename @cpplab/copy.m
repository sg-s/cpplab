%{ 
                   _       _     
  ___  _     _    | | __ _| |__  
 / __|| |_ _| |_  | |/ _` | '_ \ 
| (_|_   _|_   _| | | (_| | |_) |
 \___||_|   |_|   |_|\__,_|_.__/ 


## copy

makes a copy of a cpplab object

**Syntax**

```
C2 = copy(C)
```

**Description**

Since `cpplab` objects inherit from MATLAB's handle class, 
they cannot be copied using simple assignation. That means that

```
% assuming C is a cpplab object
C2 = C;
```

does not make a copy of `C`, and changes in `C` manifest as 
changes in `C2`, and vice versa.


%}

function N = copy(self)

% make a new cpplab object
N = cpplab(self.cpp_class_path);

% copy over every non-cpplab property
props = properties(self);
for i = 1:length(props)
	if isa(self.(props{i}),'cpplab')
		continue
	end
	if ~isprop(N,props{i})
		p = N.addprop(props{i});
		p.NonCopyable = false;
	end
	N.(props{i}) = self.(props{i});
end

% copy cpplab propoerties by recurisvely calling copy
C = self.Children;
for i = 1:length(C)
	NN = self.(C{i}).copy;
	N.addNoHash(C{i},NN);
end

N.Children = C;