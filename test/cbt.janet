(import tester :prefix "" :exit true)

(import /src/cbt-1.0.0 :as "cbt")
(use xml/objects)

(deftest
  (test "cp437"
        (is (= :228 (cbt/xml/utf8->cp437 "Σ")))))

(deftest
  (test "objects"
        (is (deep=
              [:object @{:Name :TestObject}
               [:part @{:Name :YourMom}]]
              (object :TestObject {} (part :YourMom))))))
