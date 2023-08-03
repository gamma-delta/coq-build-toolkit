(import tester :prefix "" :exit true)
(import ../src/cbt :as "cbt")

(defsuite
  (test "aughufg"
        (print
          (cbt/xml/write
            [:objects
             [:object {:name "Foobar"}
              [:part {:name "Physics" :category "Tools" :weight 3}]]]))))
