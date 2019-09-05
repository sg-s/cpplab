function o = vertcat(self, other_obj)

warning('You are strongly discouraged from making arrays of cpplab objects. You may experience undefined behaviour')
o = builtin('vertcat', self, other_obj);