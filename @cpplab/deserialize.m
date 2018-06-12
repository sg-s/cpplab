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

props = sort(properties(self));

persistent pstate;
if nargin == 2
	pstate = state;
end

for i = 1:length(props)

	% check if it's hidden or should be otherwise ignored
	if strcmp(props{i},'hidden_props')
		continue
	end
	if any(strfind(props{i},'cpp_'))
		continue
	end

	if any(strcmp(props{i},self.hidden_props))
		continue
	end

	if length(self.(props{i})) > 1 && isa(self.(props{i}),'cpplab')
		% vector of cpplab objects 
		for j = 1:length(self.(props{i}))
			self.(props{i})(j).deserialize();
		end
	elseif isa(self.(props{i}),'double') && ~isempty(self.(props{i}))
		if ~isscalar(self.(props{i}))
			continue
		end
		self.(props{i}) = pstate(1);
		pstate(1) = [];
	elseif isa(self.(props{i}),'function_handle') 
		% skip
		pstate(1) = [];
	elseif  isa(self.(props{i}),'cpplab')
		self.(props{i}).deserialize();
	end

end	