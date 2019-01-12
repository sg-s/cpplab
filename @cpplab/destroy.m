%{ 
                   _       _     
  ___  _     _    | | __ _| |__  
 / __|| |_ _| |_  | |/ _` | '_ \ 
| (_|_   _|_   _| | | (_| | |_) |
 \___||_|   |_|   |_|\__,_|_.__/ 


### destroy

**Syntax**

```
ParentObject.ChildObject.destroy()
```

**Description**

removes a cpplab object that is contained within another and destroys it. This is the opposite of `cpplab.add()`

!!! See Also
    ->cpplab.add

%}

function destroy(self)

self.parent.Children = setdiff(self.parent.Children,self.dynamic_prop_handle.Name);

delete(self.dynamic_prop_handle)

self.hashSource;

