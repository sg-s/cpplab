
%                    _       _     
%   ___  _     _    | | __ _| |__
%  / __|| |_ _| |_  | |/ _` | '_ \
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/
%
%
% ### hashSource
%
% **Syntax**
%
% ```
% C.hashSource
% ```
%
% **Description**
%
% `hashSource` asks the parent of a cpplab object in a nested cpplab object tree to compute its hash.
%
% !!! info "See Also"
%     ->cpplab.shallowHash
%     ->cpplab.addNoHash


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
