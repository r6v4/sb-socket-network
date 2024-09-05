# sb-socket-network

## Project description
use sbcl socket to make fast network

## Project structure
sb-socket-network/                     #software name.
    sb-socket-network.asd              #define project.
    package.lisp                       #define package and export symbol.
    code/                              #source code.
        c-bind.lisp                    #binding for c function.
        user-function.lisp             #some function for user.
    test/                              #test part.
        example-1.lisp                 #simple example of sbcl socket.
        example-2.lisp                 #example of user function. 
