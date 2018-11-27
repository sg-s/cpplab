%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
%
% generic method that adds something as a child to this object
function add(self,varargin)



addNoHash(self,varargin{:});


% and ask the source to hash
self.hashSource();