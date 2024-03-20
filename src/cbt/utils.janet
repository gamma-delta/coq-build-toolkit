(defmacro with-inner-bindings
  [binds & bodies]
  ['let binds ;bodies])

(defn kv-args-with-tail
  ```
  From a list of arguments like:
    (myfn :key 123 :key2 456 bodies...)
  return a two-tuple containing:
  - a dict of the keyword args
  - the bodies
  ```
  [args]
  (def kvs @{})
  # i do not know of a functional way to do this
  (prompt :ret (for iraw 0 999999999
                 (def i (* iraw 2))
                 (if (> i (length args))
                   (return :ret [kvs @[]]))
                 (def k (get args i))
                 (if (keyword? k)
                   (put kvs k (get args (+ i 1)))
                   (return :ret [kvs (array/slice args i)])))))
