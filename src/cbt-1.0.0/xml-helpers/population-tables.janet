(defn group-raw
  ```
  Define a group.

  Pass `nil` for `style` or `load` to not include a `Style` or `Load` property.
  ```
  [name style load & entries]
  [:group (table :Name name
                 ;(if style [:Style style] [])
                 ;(if load [:Load load] []))
   ;entries])

(defn alter-group
  [name & entries]
  [:group (table :Name name)
   ;entries])

(defn items
  ```
  Define a group named "Items".

  Pass `nil` for `style` or `load` to not include a `Style` or `Load` property.
  ```
  [& entries]
  (group-raw "Items" nil nil ;entries))


(defn table-each
  ```
  Define a `table` in a `group` with the `pickeach` style.
  ```
  [name number &opt chance]
  [:table (table
            :Name name
            :Number number
            ;(if chance [:Chance chance] []))])

(defn object-each
  ```
  Define a `object` in a `group` with the `pickeach` style.
  Use this inside `(table-each ...)`
  ```
  [name number &opt chance]
  [:object (table
             :Blueprint name
             :Number number
             ;(if chance [:Chance chance] []))])

(defn- table-one
  ```
  Define a `table` in a `group` with the `pickone` style.
  ```
  [name number weight]
  [:table (table
            :Name name
            :Number number
            :Weight weight)])

(defn- object-one
  ```
  Define a `object` in a `group` with the `pickone` style.
  Use this inside `(table-one ...)`
  ```
  [name number weight]
  # (printf "object-one %M" [name number weight])
  [:object {:Blueprint name
            :Number number
            :Weight weight}])
