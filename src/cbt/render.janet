(defn color-string
  ```
  Pass this to `TileColor` or `ColorString` on the `Render` part.
  You *can* also use this for the `DisplayName` but I'd recommend
  using the color markup language.

  See: https://wiki.cavesofqud.com/wiki/Modding:Colors_%26_Object_Rendering
  ```
  [fg &opt bg]
  (string fg "&"
          (if bg ("^" bg))))
