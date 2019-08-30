
function updateRealNames(self,child_name,real_names)

real_names = cellfun(@(x) [child_name '.' x], real_names, 'UniformOutput', false);

if isempty(self.cpp_lab_real_names)
	self.cpp_lab_real_names = sort(real_names);
else
	self.cpp_lab_real_names = unique([self.cpp_lab_real_names; real_names]);
end

if ~isempty(self.cpp_lab_name) && ~isempty(self.parent)
	updateRealNames(self.parent, self.cpp_lab_name, real_names)
end