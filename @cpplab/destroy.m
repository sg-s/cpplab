% destroys a cpplab object within a tree

function destroy(self)

self.parent.Children = setdiff(self.parent.Children,self.dynamic_prop_handle.Name);

delete(self.dynamic_prop_handle)

self.hashSource;

