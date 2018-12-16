%{ 
                   _       _     
  ___  _     _    | | __ _| |__  
 / __|| |_ _| |_  | |/ _` | '_ \ 
| (_|_   _|_   _| | | (_| | |_) |
 \___||_|   |_|   |_|\__,_|_.__/ 


# readChildFunctions

**Syntax**

```
child_functions = C.readChildFunctions
```

**Description**

Do not use this method. 

%}


function child_functions = readChildFunctions(self)

L = lineRead(self.cpp_class_path);


function_declaration_lines = lineFind(L,[self.cpp_class_name '::']);

child_functions = struct('fun_name',[],'fun_handle',[],'fun_return_type',[],'fun_input_type',[],'fun_input_names',[]);



for i = 1:length(function_declaration_lines)
	% determine output type 

	S = struct('fun_name',[],'fun_handle',[],'fun_return_type',[],'fun_input_type',[],'fun_input_names',[]);

	this_line = L{function_declaration_lines(i)};
	% chop off line after // or {
	z = [];
	z1 = strfind(this_line,'{');
	z2 = strfind(this_line,'//');
	z = min([z1 z2]);
	if ~isempty(z)
		this_line = this_line(1:z-1);
	end

	if isempty(this_line)
		continue
	end

	temp = strsplit(this_line, {' ', '(' ,',' ,')' ,';' ,'//'});
	temp(cellfun(@isempty,temp)) = [];
	S.fun_return_type = temp{1};

	S.fun_name = strrep(temp{2}, [self.cpp_class_name '::'],'');
	S.fun_input_type = {temp{3:2:end}};
	S.fun_input_names = {temp{4:2:end}};

	if strcmp(S.fun_return_type,'double')
		try
			% for now, it will only work for one line functions 
			this_line = L{function_declaration_lines(i)};
			a = strfind(this_line,'{');
			z = strfind(this_line,'}');
			f = strrep(this_line(a+1:z-1),'return','');
			ff = '@(';
			for j = 1:length(S.fun_input_names)
				ff = [ff S.fun_input_names{j} ','];
			end
			ff(end) = ')';
			ff = str2func([ff f]);
			S.fun_handle = ff;
		catch
		end
	else
		
	end
	child_functions = [child_functions; S];
end

self.cpp_child_functions = child_functions;