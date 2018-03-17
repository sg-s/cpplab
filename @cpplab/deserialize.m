%                    _       _     
%   ___  _     _    | | __ _| |__  
%  / __|| |_ _| |_  | |/ _` | '_ \ 
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/ 
%
% accepts a vector and updates all 
% fields in the cpplab object
% this is the opposite of serialize 
% usage:
% 
% [obj].deserialize(state)
% where state is a vector
% prefix is not meant to be used by external functions 

function deserialize(self,state)

props = properties(self);

persistent pstate;
if nargin == 2
	pstate = state;
end

for i = 1:length(props)

	if isa(self.(props{i}),'double') && ~isempty(self.(props{i}))
		self.(props{i}) = pstate(1);
		pstate(1) = [];
	elseif isa(self.(props{i}),'function_handle') 
		% skip
		pstate(1) = [];
	elseif  isa(self.(props{i}),'cpplab')
		self.(props{i}).deserialize();
	end

end	