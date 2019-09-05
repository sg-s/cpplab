function o = horzcat(self, other_obj)

warning('You are strongly discouraged from making arrays of cpplab objects. You may experience undefined behaviour')
o = builtin('horzcat', self, other_obj);