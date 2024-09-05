(in-package :cl-user)

(defpackage #:sb-socket-network
    (:use :cl :cl-user :cffi)
    (:export 
        :c-setsockopt
        :get-backlog-number
        :socket-fd
        :socket-buffer-size
        :buffer-can-use-size
        :socket-can-write-check
        :make-server-socket
        :make-client-socket
        :user-recv
        :user-send
        :user-close ))
