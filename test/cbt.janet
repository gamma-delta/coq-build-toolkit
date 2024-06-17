(import tester :prefix "" :exit true)

(import ../src/cbt-1.0.0 :as "cbt")
# (use cbt/xml-helpers/objects)

# (deftest
#   (test "cp437"
#         (is (= :228 (utf8->cp437 "Σ")))))

# (deftest
#   (test "with-inner-bindings"
#         (def my-binds ['three 3 'succ (fn [x] (+ x 1))])
#         (with-inner-bindings
#           my-binds
#           (is (= (+ three (succ 9))
#                  13))))
#   (test "objects"
#         (is (deep=
#               (object :TestObject {} (part :YourMom))
#               [:object @{:Name :TestObject}
#                [:part @{:Name :YourMom}]]))))

