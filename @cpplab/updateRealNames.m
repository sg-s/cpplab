
function updateRealNames(self,child_name,real_names)


real_names = cellfun(@(x) [child_name '.' x], real_names, 'UniformOutput', false);

if isempty(self.cpp_lab_real_names)
	self.cpp_lab_real_names = sort(real_names);
else
	self.cpp_lab_real_names = unique([self.cpp_lab_real_names; real_names]);
end

if ~isempty(self.dynamic_prop_handle) && ~isempty(self.dynamic_prop_handle.Name) && ~isempty(self.parent)
	updateRealNames(self.parent, self.dynamic_prop_handle.Name, real_names)
end