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
  [:group {:Name name :Load "Merge"}
   ;entries])

(defn alter-items
  [& entries]
  (alter-group "Items" ;entries))

(defn items-pickone
  ```
  Define a group named "Items" with the "pickone" style
  ```
  [& entries]
  (group-raw "Items" "pickone" nil ;entries))

(defn items-pickeach
  ```
  Define a group named "Items" with the "pickeach" style
  ```
  [& entries]
  (group-raw "Items" "pickeach" nil ;entries))


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
  Use this inside `(items-pickeach ...)`
  ```
  [name number &opt chance]
  [:object (table
             :Blueprint name
             :Number number
             ;(if chance [:Chance chance] []))])

(defn table-one
  ```
  Define a `table` in a `group` with the `pickone` style.
  ```
  [name number weight]
  [:table (table
            :Name name
            :Number number
            :Weight weight)])

(defn object-one
  ```
  Define a `object` in a `group` with the `pickone` style.
  Use this inside `(items-pickone ...)`
  ```
  [name number weight]
  # (printf "object-one %M" [name number weight])
  [:object {:Blueprint name
            :Number number
            :Weight weight}])

(defn population
  ```
  Define a population table. Don't forget the properties!
  ```
  [name props & bodies]
  [:population (merge {:Name name} props)
   ;bodies])
