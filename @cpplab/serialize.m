
%                    _       _     
%   ___  _     _    | | __ _| |__
%  / __|| |_ _| |_  | |/ _` | '_ \
% | (_|_   _|_   _| | | (_| | |_) |
%  \___||_|   |_|   |_|\__,_|_.__/
%
%
% ### serialize
%
% **Syntax**
%
% ```
% values = C.serialize;
% [values, names] = C.serialize;
% [values, names, is_relational] = C.serialize;
% [values, names, is_relational, real_names] = C.serialize;
% ```
%
% **Description**
%
% `serialize` is a method that traverses the cpplab object tree, collects the value of every parameter in every object and packs them into a vector.
%
% - **`values = C.serialize`** returns a vector of all parameters in the nested cpplab object C.
% - **`[values, names] = C.serialize`** also returns the names of all parameters. The order of names matches the order of values
% - **`[values, names, is_relational] = C.serialize`** also returns a logical vector that is the same length as the other two outputs. Each element in this vector is either true or false based on whether the parameter is a scalar value or a relational function handle.
% - **`[values, names, is_relational, real_names] = C.serialize`** also returns a fourth cell vector which contains the real names of all parameters, that allows you to directly use it to reference those parameters.
%
% !!! info "See Also"
%     ->cpplab.find
%     ->cpplab.deserialize
%     ->cpplab.get




function [values, names, is_relational, real_names] = serialize(self)

values = self.get(self.cpp_lab_real_names);
real_names = self.cpp_lab_real_names;
names = cellfun(@(x) strrep(x,'.','_'),self.cpp_lab_real_names,'UniformOutput',false);
is_relational = false(length(real_names),1);

