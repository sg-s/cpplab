%{ 
                   _       _     
  ___  _     _    | | __ _| |__  
 / __|| |_ _| |_  | |/ _` | '_ \ 
| (_|_   _|_   _| | | (_| | |_) |
 \___||_|   |_|   |_|\__,_|_.__/ 


# exist

**Syntax**

```
TF = exist(object,thing)
```

**Description**

removes a cpplab object that is contained within another and destroys it. This is the opposite of `cpplab.add()

!!! warning
    Do not use this method. It will be removed in a future release.


!!! info "See Also"
    -> cpplab.get
    -> cpplab.find

%}

function TF = exist(self,thing)

warning('cpplab.exist() will be removed in a future release')

TF = false;

try
	temp = self.get(thing);
	TF = true;
end