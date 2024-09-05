(asdf:defsystem sb-socket-network
    :name "sb-socket-network"
    :description "use sbcl socket to make fast network"
    :author "r6v4@pm.me"
    :version 1.0
    :depends-on ("cffi" "sb-bsd-sockets") 
    :serial t
    :components (
        (:static-file "LICENSE")
        (:file "package")
        (:module "code"
            :serial t
            :components
                (   (:file "c-bind")
                    (:file "user-function") ))
        ;(:module "test"
        ;    :serial t
        ;    :components
        ;        (  (:file "example-1")
        ;           (:file "example-2")))
        ))
