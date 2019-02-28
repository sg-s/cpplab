%{
%                    _       _     
%   ___  _     _    | | __ _| |__
%  / __|| |_ _| |_  | |/ _` | '_ \
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/
%
%
% ### getAllHashes
%
% **Syntax**
%
% ```
% H = C.getAllHashes
% ```
%
% **Description**
%
% Do not use this method.

%}


function H = getAllHashes(self)

H = {};

% if we're running on a vector of cpplab objects
% run this on a loop
if length(self) > 1
	for i = 1:length(self)
		these_hashes = self(i).getAllHashes;
		H = [H; these_hashes];
	end
	return
end

if isempty(self.hash)
	H{1} = repmat('0',1,32);
else
	H{1} = self.hash;
end

for i = 1:length(self.Children)
	these_hashes = self.(self.Children{i}).getAllHashes;
	H = [H; these_hashes];
end
