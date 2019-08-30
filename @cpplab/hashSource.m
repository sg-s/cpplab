
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


self.shallowHash;


if ~isempty(self.parent)
	hashSource(self.parent);
end
