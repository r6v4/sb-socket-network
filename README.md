# sb-socket-network

## Project description
use sbcl socket to make fast network

## Project structure
```text
sb-socket-network/                     #software name.
    sb-socket-network.asd              #define project.
    package.lisp                       #define package and export symbol.
    code/                              #source code.
        c-bind.lisp                    #binding for c function.
        user-function.lisp             #some function for user.
    test/                              #test part.
        example-1.lisp                 #simple example of sbcl socket.
        example-2.lisp                 #example of user function. 
```

## Project loading
```bash
cd 12345 #or other file menu
git clone https://github.com/r6v4/cl-http-message.git #is v2 not v1
git clone https://github.com/r6v4/sb-socket-network.git
sbcl
```
```common-lisp
(require :asdf)

(pushnew
    (probe-file "./cl-http-message")
    asdf:*central-registry* :test #'equal)

(pushnew
    (probe-file "./sb-socket-network")
    asdf:*central-registry* :test #'equal)

(asdf:load-system :cl-http-message)
(asdf:load-system :sb-socket-network)

```

## Project usage
