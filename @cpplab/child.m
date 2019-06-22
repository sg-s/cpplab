
%                    _       _     
%   ___  _     _    | | __ _| |__
%  / __|| |_ _| |_  | |/ _` | '_ \
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/
%
%
% ### child
%
% **Syntax**
%
% ```
% C = Parent.child
% C = Parent.child(2)
% ```
%
% **Description**
%
% `C = Parent.child` returns the name of the first child of Parent, a cpplab object
%
% `C = Parent.child(N)` returns the name of the Nth child of Parent, a cpplab object
%
% !!! See Also
%     ->cpplab.Children


function C = child(self, child_number)

if nargin == 1
	child_number = 1;
end

C = self.Children{child_number};