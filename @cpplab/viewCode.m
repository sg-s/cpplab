%{ 
                   _       _     
  ___  _     _    | | __ _| |__  
 / __|| |_ _| |_  | |/ _` | '_ \ 
| (_|_   _|_   _| | | (_| | |_) |
 \___||_|   |_|   |_|\__,_|_.__/ 


### viewCode

**Syntax**

```
C.viewCode()
```


**Description**

`viewCode` opens up the C++ file corresponding to this cpplab object in the default MATLAB editor. 

%}


function viewCode(self)

edit(self.cpp_class_path)
