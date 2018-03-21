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

1. Your class must contain explicit an constructor
2. Only one constructor/class
3. Construct arguments can only be numeric (no pointers, etc) 

