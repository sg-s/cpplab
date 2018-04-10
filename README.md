# cpplab

Automatic type system that binds MATLAB code to C++ code

# What? 

A tool that automatically creates objects and classes on the fly based on object-oriented C++ code **in MATLAB**

# Why? 

* MATLAB code is slow
* C++ code is ~100x faster
* MATLAB's `codegen` doesn't work with OOP

# How? 

`cpplab` reads C++ header files, and creates `cpplab` objects on the fly that mimic the objects in your C++ code. There are the following limitations: 

1. Your class must explicitly contain a constructor
2. Only one constructor/class
3. Construct arguments can only be numeric (no pointers, etc) 

# What is the sorcery? 

Imagine you have some C++ classes defined in some `.hpp` files. `cpplab` can automatically bind to them, and build objects on the fly in MATLAB that mimic the structure of objects defined by those classes. For example:

```matlab
NaV = cpplab('/path/to/NaV.hpp');
```

defines a `NaV` object 

```matlab

ans = 

 NaV object with:

     E : 30
     h : 1
  gbar : function_handle
     m : 0

```

that is a real, bona-fide MATLAB object that has the same properties as defined in your C++ class -- all without writing a single line of MATLAB code! 

It gets crazier: you can endlessly nest objects, putting one inside the other: 

```matlab
AB = cpplab('/path/to/compartment.hpp');
AB.add(NaV);
AB

 compartment object with:

  Ca_average : 3.67713978387728
           A : 0.0628
      tau_Ca : 200
          Cm : 10
          Ca : 2.79665927035738
         vol : 0.0628
         phi : 90.64649968
           V : -45.6711026536245
      Ca_out : 3000
       Ca_in : 0.05
   Ca_target : 0
         NaV : NaV object

```

`cpplab` comes with some powerful features that makes working with these objects a breeze. For example, you can 


```matlab
S = AB.serialize; % converts the entire tree of objects into a vector

AB.deserialize(S); % update all parameters in the entire tree

% create links to all header files in the tree
AB.generateHeaders;

    {'/code/xolotl/c++/compartment.hpp'                     }
    {'/code/xolotl/c++/conductances/liu-approx/NaV.hpp'     }


% hash the entire tree, based on the contents of the C++ files:

x.hash

ans =

    'dfac882c1797c0a1a17407fc15e25dd911de3fb4'



```

