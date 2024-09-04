(setf 
    my-inet-socket (make-instance 'sb-bsd-sockets:inet-socket :type :stream :protocol :tcp)
    my-inet-address (sb-bsd-sockets:make-inet-address "127.0.0.1")
    my-inet-port 8080
    (sb-bsd-sockets:sockopt-reuse-address my-inet-socket) t
    (sb-bsd-sockets:sockopt-keep-alive  my-inet-socket)   t
    (sb-bsd-sockets:sockopt-tcp-nodelay my-inet-socket)   t )

(sb-bsd-sockets:socket-bind     my-inet-socket my-inet-address my-inet-port)
(sb-bsd-sockets:socket-listen   my-inet-socket 8192)

(setf 
    max-single-receive-size 4096
    inet-client (sb-bsd-sockets:socket-accept my-inet-socket)
    message-box (make-array max-single-receive-size :element-type '(unsigned-byte 8) :adjustable nil :fill-pointer nil) )

(setf 
    message-length 
    (nth-value 1 
        (sb-bsd-sockets:socket-receive inet-client message-box 4096 :dontwait t :element-type '(unsigned-byte 8)))
    http-message
    (if (eql message-length max-single-receive-size) 
        message-box
        (subseq message-box 0 message-length)))

http-message

#|
;next time use message-box receive from inet-client
(setf 
    message-length 
    (nth-value 1 
        (sb-bsd-sockets:socket-receive inet-client message-box 4096 :dontwait t :element-type '(unsigned-byte 8)))
    http-message
    (if (eql message-length max-single-receive-size) 
        message-box
        (subseq message-box 0 message-length)))
|#
#|
wget http://127.0.0.1:8080/12345
|#

#|
#(71 69 84 32 47 49 50 51 52 53 32 72 84 84 80 47 49 46 49 13 10 72 111 115 116
  58 32 49 50 55 46 48 46 48 46 49 58 56 48 56 48 13 10 85 115 101 114 45 65
  103 101 110 116 58 32 87 103 101 116 47 49 46 50 49 46 51 13 10 65 99 99 101
  112 116 58 32 42 47 42 13 10 65 99 99 101 112 116 45 69 110 99 111 100 105
  110 103 58 32 105 100 101 110 116 105 116 121 13 10 67 111 110 110 101 99 116
  105 111 110 58 32 75 101 101 112 45 65 108 105 118 101 13 10 13 10 0 0 0 0 0 ...)
|#
