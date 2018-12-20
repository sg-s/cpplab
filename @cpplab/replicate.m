%{ 
                   _       _     
  ___  _     _    | | __ _| |__  
 / __|| |_ _| |_  | |/ _` | '_ \ 
| (_|_   _|_   _| | | (_| | |_) |
 \___||_|   |_|   |_|\__,_|_.__/ 


## replicate


**Description**

Do not use this method. 

%}


function replicate(self,thing,N)


assert(isint(N),'N must be an integer >= 1')
assert(isscalar(N),'N must be an integer >= 1')
assert(N >= 1,'N must be an integer >= 1')

if N == 1
	return
end

skip_hash_state = self.skip_hash;
self.skip_hash = true;

new_len = self.(thing).len/N;

self.(thing).len = new_len;

all_comps = {thing};

n_digits = length(mat2str(N));

thing_root_name = strrep(thing,strjoin(regexp(thing,'[0-9]','match'),''),'');

for i = 2:N
	root_thing = copy(self.(thing));

	padding_length = n_digits - length(mat2str(i));
	new_thing_name = [thing_root_name repmat('0',1,padding_length) mat2str(i)];

	p = self.addprop(new_thing_name);
	p.NonCopyable = false;
	self.(new_thing_name) = root_thing;
end

% we're going to cheat and not rehash the entire tree
self.hash = GetMD5([self.hash GetMD5(N)]);


self.skip_hash = skip_hash_state;
