%{ 
                   _       _     
  ___  _     _    | | __ _| |__  
 / __|| |_ _| |_  | |/ _` | '_ \ 
| (_|_   _|_   _| | | (_| | |_) |
 \___||_|   |_|   |_|\__,_|_.__/ 


### add

The add method allows you to add cpplab objects to other cpplab objects
and build a tree of cpplab objects. 

**Syntax**

```
ParentObject.add(ChildObject)
ParentObject.add(ChildObject,'name')
ParentObject.add('path/to/ChildObject.hpp')
ParentObject.add('path/to/ChildObject.hpp','name')
ParentObject.add('path/to/ChildObject.hpp','name','Property',Value...)
ParentObject.add('path/to/ChildObject.hpp','Property',Value...)
```

**Description**

- **`ParentObject.add(ChildObject)`** adds `ChildObject`, a `cpplab` object to `ParentObject`, another 
`cpplab` object. The ChildObject is automatically named with the 
name of the C++ class it refers to, so you can access it using ParentObject.(ChildObject.cpp_class_name) 
- **`ParentObject.add(ChildObject,'name')`** adds `ChildObject`, a `cpplab` object to `ParentObject`, another 
`cpplab` object. The ChildObject is assigned the name 'name' in the  tree, so you can access it using `ParentObject.name`
- **`ParentObject.add('path/to/ChildObject.hpp')`** adds `ChildObject`, a `cpplab` object to `ParentObject`, another 
`cpplab` object. The ChildObject is created on the fly using the 
path specified, and is  automatically named with the 
name of the C++ class it refers to, so you can access it using ParentObject.(ChildObject.cpp_class_name) 
- **`ParentObject.add('path/to/ChildObject.hpp','name')`** adds `ChildObject`, a `cpplab` object to `ParentObject`, another 
`cpplab` object. The ChildObject is created on the fly using the 
path specified, and is assigned the name 'name' in the tree, so 
you can access it using `ParentObject.name`
- **`ParentObject.add('path/to/ChildObject.hpp','name','Property',Value...)`** adds `ChildObject`, a `cpplab` object to `ParentObject`, another 
`cpplab` object. The ChildObject is created on the fly using the 
path specified, and is assigned the name 'name' in the tree, so 
you can access it using `ParentObject.name`. In addition, the ChildObject is configured on-the-fly with the properties you specify before addition to ParentObject. 
- **`ParentObject.add('path/to/ChildObject.hpp','Property',Value...)`** adds `ChildObject`, a `cpplab` object to `ParentObject`, another 
`cpplab` object. The ChildObject is created on the fly using the 
path specified, and is  automatically named with the 
name of the C++ class it refers to, so you can access it using ParentObject.(ChildObject.cpp_class_name). In addition, the ChildObject is configured on-the-fly with the properties you specify before addition to ParentObject. 


!!! info "See Also"
    ->cpplab.addNoHash
    ->cpplab.destroy

%}


function add(self,varargin)



addNoHash(self,varargin{:});


% and ask the source to hash
self.hashSource();