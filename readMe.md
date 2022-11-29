README
This compiler was built from this tutorial: https://www.destroyallsoftware.com/screencasts/catalog/a-compiler-from-scratch
 
Compiler Version: 1.0
 
Ruby version 3.1.2

You will need to type code into the test.src file and the compiler will go over the lines one by one deciphering it. 
Their is JavaScript already in the test.rc file feel free to use which ever language you desire.

To run this program in the terminal do ./"file_name" | "programming language" ### This runs an error for me when I use node as my language I have to figure out what is going on there. 
./compile.rb: line 1: class: command not found
./compile.rb: line 2: TOKEN_TYPES: command not found
./compile.rb: line 3: [:def,: command not found
./compile.rb: line 4: [:end,: command not found
./compile.rb: line 5: [:identifier,: command not found
./compile.rb: line 6: [:integer,: command not found
./compile.rb: line 7: [:oparen,: command not found
./compile.rb: line 8: [:cparen,: command not found
./compile.rb: line 9: [:coma,: command not found
./compile.rb: line 10: ]: command not found
./compile.rb: line 12: syntax error near unexpected token `('
./compile.rb: line 12: `  def initialize(code)'

works when ran as ruby compile.rb I get outputs I"m looking for 
