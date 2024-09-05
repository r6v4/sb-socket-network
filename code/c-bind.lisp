(in-package :sb-socket-network)

(declaim
    (optimize
        (speed              3)
        (space              1)
        (debug              0)
        (compilation-speed  0)))

(cffi:defcfun (c-setsockopt "setsockopt") :int
    (fd     :int)
    (type   :int)
    (opt    :int)
    (vcpu   :pointer)
    (size   :int) )
#|
(defun get-backlog-number ()
    (let* ( (the-octets 
                (or
                    (ignore-errors (map '(vector (unsigned-byte 8)) #'char-code
                        (with-output-to-string (a) (run-program "/sbin/sysctl" (list "net.core.somaxconn") :wait t :output a)) ))
                    (ignore-errors (map '(vector (unsigned-byte 8)) #'char-code
                        (with-output-to-string (a) (run-program "/usr/sbin/sysctl" (list "net.core.somaxconn") :wait t :output a)) ))))
            (the-start  (if the-octets  (search #(32 61 32) the-octets) nil))
            (the-end    (if the-start   (ignore-errors (search #(10) the-octets :start2 the-start)) nil))
            (the-vector (if the-end     (ignore-errors (subseq the-octets (+ 3 the-start) the-end)) nil))
            (the-number (if the-vector  (parse-integer (map 'string #'code-char the-vector) :junk-allowed t) nil)) )
        (if (numberp the-number)
            (cond
                ((<= the-number 5)
                    5 )
                (t 
                    (1- the-number) )))))
|#
