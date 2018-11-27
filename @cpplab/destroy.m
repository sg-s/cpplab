% destroys a cpplab object within a tree

function destroy(self)
delete(self.dynamic_prop_handle)

self.hashSource;

