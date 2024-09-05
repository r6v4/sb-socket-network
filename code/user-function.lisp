(in-package :sb-socket-network)

(defun socket-fd (client-socket)
    (sb-bsd-sockets::socket-file-descriptor client-socket) )

(defun socket-buffer-size (client-socket)
    (sb-bsd-sockets:sockopt-send-buffer client-socket))

(defun buffer-can-use-size (client-socket)
    (sb-alien:with-alien ((result sb-alien:int))
        (sb-unix:unix-ioctl (socket-fd client-socket) 21521 (sb-alien:alien-sap (sb-alien:addr result)))
        (- (socket-buffer-size client-socket) result) ))

(defun socket-can-write-check (client-socket)
    (if (> (buffer-can-use-size client-socket) 2048)
        t
        nil ))

(defun make-server-socket (address-vector port-number vcpu-number)
    (let ((the-socket (make-instance 'sb-bsd-sockets:inet-socket :type :stream :protocol :tcp)))
        (setf (sb-bsd-sockets:sockopt-reuse-address the-socket) t)
        (setf (sb-bsd-sockets:sockopt-keep-alive    the-socket) t)
        (setf (sb-bsd-sockets:sockopt-tcp-nodelay   the-socket) t)
        (setf (sb-bsd-sockets::sockopt-receive-low-water the-socket) 5)
        (c-setsockopt
            (socket-fd the-socket)
            1
            49
            (sb-alien:alien-sap (sb-alien:make-alien sb-alien:int vcpu-number))
            4)
        (sb-bsd-sockets:socket-bind     the-socket address-vector port-number)
        (sb-bsd-sockets:socket-listen   the-socket 2048)
        the-socket ))

(defun make-client-socket (server-socket)
    (sb-bsd-sockets:socket-accept server-socket) )

(defun user-recv (socket buffer length)
    (sb-bsd-sockets::with-socket-fd-and-addr (fd sockaddr size) socket
        ;(if length
        ;    nil
        ;    (setq length (length buffer)))
        ;(if buffer
        ;    nil
        ;    (setq buffer (make-array length :element-type '(unsigned-byte 8) :INITIAL-ELEMENT 0 :ADJUSTABLE nil :FILL-POINTER nil)))
        (let ((copy-buffer (sb-alien:make-alien (array (sb-alien:unsigned 8) 1) length)))
            (unwind-protect
                (sb-alien:with-alien ((sa-len sockint::socklen-t size))
                    (sb-bsd-sockets::socket-error-case 
                        ("recvfrom"
                            (sockint::recvfrom fd copy-buffer length 64 sockaddr (sb-alien:addr sa-len))
                            len )
                        (progn
                            (loop for i from 0 below (min len length) do 
                                (setf (elt buffer i) (sb-alien:deref (sb-alien:deref copy-buffer) i)))
                            len )
                        (:interrupted nil) ))
                (sb-alien:free-alien copy-buffer) ))))

(defun user-send (socket buffer) 
    (declare (sb-ext:freeze-type (simple-array (unsigned-byte 8)) buffer))
    (let* ( (fd (socket-fd socket))
            (length (length buffer))
            (len
                (sb-bsd-sockets::with-vector-sap (buffer-sap buffer)
                    (sockint::send fd buffer-sap length 0) )))
        (sb-bsd-sockets::socket-error-case ("sendto" len) len (:interrupted nil)) ))

(defun user-close (client-socket)
    (if (ignore-errors (sb-bsd-sockets:socket-open-p client-socket))
        (ignore-errors (sb-bsd-sockets:socket-close client-socket))
        nil ))
