# Quick Run
Execute this command (you might need to add executable permissions (`chmod +x run.sh build.sh`))
```
./run.sh
```
This will compile the code and execute the program
# Compile
Execute this command (you might need to add executable permissions (`chmod +x build.sh`))
```
./build.sh
```
This will compile the code with the resulting executable in `main`

Execute this command to execute the program
```
./main
```
# Manual
Execute these commands to compile the code
```
as --64 -o main.o main.s
ld -o main main.o
```
And then to execute the program
```
./main
```
# Known Quirks
Any non-numeric character except LF will be treated as if its numeric value is the ascii offset from ascii '0'.

For example 'A' has a value of 17 and 'a' has a value of 49.
