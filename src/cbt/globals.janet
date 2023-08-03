# Janet doesn't like circular deps, so declare the global var here. euhg.

(varglobal '*cbt* @{:manifest nil
                    :file-generators @{}
                    :build-dir "./build"
                    :resources-dir "./resources"
                    :debug-output false})

(defn dbg [fmt & args]
  (if (*cbt* :debug-output)
    (printf fmt ;args)))
