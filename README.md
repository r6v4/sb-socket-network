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
#git clone https://github.com/r6v4/cl-http-message.git #is v2 not v1
git clone https://github.com/r6v4/sb-socket-network.git
sbcl
```
```common-lisp
(require :asdf)

(pushnew
    (probe-file "./sb-socket-network")
    asdf:*central-registry* :test #'equal)

(asdf:load-system :sb-socket-network)

```

## Project usage
```common-lisp
(setf 
    max-single-receive-size 
    4096
    server-socket 
    (sb-socket-network:make-server-socket (sb-bsd-sockets:make-inet-address "127.0.0.1") 8080 0)
    client-socket 
    (sb-socket-network:make-client-socket server-socket)
    message-box
    (make-array max-single-receive-size :element-type '(unsigned-byte 8) :adjustable nil :fill-pointer nil)
    message-length
    (sb-socket-network:user-recv client-socket message-box max-single-receive-size)
    http-message 
    (subseq message-box 0 message-length) )
#|
#(71 69 84 32 47 49 50 51 52 53 63 97 61 49 38 38 98 61 50 38 38 99 61 51 38 38
  100 61 52 38 38 101 61 53 32 72 84 84 80 47 49 46 49 13 10 72 111 115 116 58
  32 49 50 55 46 48 46 48 46 49 58 56 48 56 48 13 10 85 115 101 114 45 65 103
  101 110 116 58 32 77 111 122 105 108 108 97 47 53 46 48 32 40 88 49 49 59 32
  85 98 117 110 116 117 59 32 76 105 110 117 120 32 120 56 54 95 54 52 59 32
  114 118 58 49 50 57 46 48 41 32 71 101 99 107 111 47 50 48 49 48 48 49 48 49
  32 70 105 114 101 102 111 120 47 49 50 57 46 48 13 10 65 99 99 101 112 116 58
  32 116 101 120 116 47 104 116 109 108 44 97 112 112 108 105 99 97 116 105 111
  110 47 120 104 116 109 108 43 120 109 108 44 97 112 112 108 105 99 97 116 105
  111 110 47 120 109 108 59 113 61 48 46 57 44 105 109 97 103 101 47 97 118 105
  102 44 105 109 97 103 101 47 119 101 98 112 44 105 109 97 103 101 47 112 110
  103 44 105 109 97 103 101 47 115 118 103 43 120 109 108 44 42 47 42 59 113 61
  48 46 56 13 10 65 99 99 101 112 116 45 76 97 110 103 117 97 103 101 58 32 122
  104 45 67 78 44 122 104 59 113 61 48 46 56 44 122 104 45 84 87 59 113 61 48
  46 55 44 122 104 45 72 75 59 113 61 48 46 53 44 101 110 45 85 83 59 113 61 48
  46 51 44 101 110 59 113 61 48 46 50 13 10 65 99 99 101 112 116 45 69 110 99
  111 100 105 110 103 58 32 103 122 105 112 44 32 100 101 102 108 97 116 101 44
  32 98 114 44 32 122 115 116 100 13 10 68 78 84 58 32 49 13 10 67 111 110 110
  101 99 116 105 111 110 58 32 107 101 101 112 45 97 108 105 118 101 13 10 85
  112 103 114 97 100 101 45 73 110 115 101 99 117 114 101 45 82 101 113 117 101
  115 116 115 58 32 49 13 10 83 101 99 45 70 101 116 99 104 45 68 101 115 116
  58 32 100 111 99 117 109 101 110 116 13 10 83 101 99 45 70 101 116 99 104 45
  77 111 100 101 58 32 110 97 118 105 103 97 116 101 13 10 83 101 99 45 70 101
  116 99 104 45 83 105 116 101 58 32 110 111 110 101 13 10 83 101 99 45 70 101
  116 99 104 45 85 115 101 114 58 32 63 49 13 10 80 114 105 111 114 105 116 121
  58 32 117 61 48 44 32 105 13 10 13 10)
|#

(sb-socket-network:socket-fd client-socket) ;5

(sb-socket-network:socket-can-write-check client-socket) ;T

```

## API
```text
int socket-fd (socket client-socket);
int socket-buffer-size (socket client-socket);
int buffer-can-use-size (socket client-socket);
bool socket-can-write-check (socket client-socket);
socket make-server-socket (array address-vector, number port-number, number vcpu-number);
socket make-client-socket (socket server-socket);
number user-recv (socket client-socket, array message-buffer, number buffer-length);
int user-send (socket client-socket, array message-buffer);
bool user-close (socket client-socket);
```
