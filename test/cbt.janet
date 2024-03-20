(import tester :prefix "" :exit true)

(import ../src/cbt :as "cbt")
(use ../src/cbt/xml-helpers/objects)
(use ../src/cbt/utils)

(deftest
  (test "cp437"
        (is (= :228 (utf8->cp437 "Σ")))))

(deftest
  (test "kv-args-with-tail"
        (is (deep=
              (kv-args-with-tail
                [:k1 "key1" :k2 'key2 :k3 1 'body1 :body2 ["body" 3]])
              [@{:k1 "key1" :k2 'key2 :k3 1}
               @['body1 :body2 ["body" 3]]]))))


(deftest
  (test "with-inner-bindings"
        (def my-binds ['three 3 'succ (fn [x] (+ x 1))])
        (with-inner-bindings
          my-binds
          (is (= (+ three (succ 9))
                 13))))
  (test "objects"
        (is (deep=
              (object :TestObject {} (part :YourMom))
              [:object @{:Name :TestObject}
               [:part @{:Name :YourMom}]]))))
