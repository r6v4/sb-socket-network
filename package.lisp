(in-package :cl-user)

(defpackage #:sb-socket-network
    (:use :cl :cl-user :cffi)
    (:export 
        :socket-fd
        :socket-buffer-size
        :buffer-can-use-size
        :socket-can-write-check
        :make-server-socket
        :make-client-socket
        :user-recv
        :user-send
        :user-close ))
