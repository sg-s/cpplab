function removeRealNames(self, remove_string)

rm_this = false(length(self.cpp_lab_real_names),1);

for i = 1:length(rm_this)
	if any(strfind(self.cpp_lab_real_names{i},remove_string))
		rm_this(i) = true;
	end
end

self.cpp_lab_real_names(rm_this) = [];

if isempty(self.parent)
	return
end

self.parent.removeRealNames([self.dynamic_prop_handle.Name '.' remove_string])