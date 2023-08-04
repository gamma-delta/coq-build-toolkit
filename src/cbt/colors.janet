# https://wiki.cavesofqud.com/wiki/Modding:Colors_%26_Object_Rendering

(def dark-red :r)
(def red :R)
(def dark-orange :o)
(def orange :O)
(def brown :y) # dark yellow i guess
(def yellow :Y)
(def dark-green :g)
(def green :G)
(def dark-blue :b)
(def blue :B)
(def dark-cyan :c)
(def cyan :C)
(def purple :m) # "dark magenta"
(def pink :M) # "magenta"
(def background :k)
(def light-background :K)
(def gray :y)
(def white :Y)

(defn color-string
  ```
  Pass this to `TileColor` or `ColorString` on the `Render` part.
  You *can* also use this for the `DisplayName` but I'd recommend
  using the color markup language.

  See: https://wiki.cavesofqud.com/wiki/Modding:Colors_%26_Object_Rendering
  ```
  [fg &opt bg]
  (string "&" fg
          (if bg ;["^" bg])))
