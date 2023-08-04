(import tester :prefix "" :exit true)

(import ../src/cbt :as "cbt")
(use ../src/cbt/xml-helpers/objects)

(deftest
  (test "cp437"
        (is (= :228 (utf8->cp437 "Σ")))))
