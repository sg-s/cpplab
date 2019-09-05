function o = repmat(self, varargin)

warning('You are strongly discouraged from making arrays of cpplab objects. You may experience undefined behaviour')
o = builtin('repmat', self, varargin{:});