%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
% a copy method that actually works,
% unlike MATLAB's built in copy

function N = copy(self)

% make a new cpplab object
N = cpplab(self.cpp_class_path);

props = properties(N);

for i = 1:length(props)
	N.(props{i}) = self.(props{i});
end

C = self.Children;
for i = 1:length(C)
	NN = self.(C{i}).copy;
	N.add(C{i},NN);
end