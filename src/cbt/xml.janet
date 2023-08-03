# Based on https://github.com/swlkr/janet-html/blob/master/src/janet-html.janet
# and by "based on" i mean "significant code theft"

(defn default-formatting []
  {:indent 2
   :capitalize-attrs true})

(defn escape [str]
  (let [str (string str)]
    (->> (string/replace-all "&" "&amp;" str)
         (string/replace-all "<" "&lt;")
         (string/replace-all ">" "&gt;")
         (string/replace-all "\"" "&quot;")
         (string/replace-all "'" "&#x27;")
         (string/replace-all "/" "&#x2F;")
         (string/replace-all "%" "&#37;"))))

(defn capitalize [s]
  (def s (string s))
  (if (empty? s)
    s
    (string
      (string/ascii-upper (string/slice s 0 1))
      (string/slice s 1))))

(defn- write-indent [formatting depth write!]
  (if-let [indent (get formatting :indent nil)]
    (write! (string/repeat " " (* indent depth)))))

(defn- write-eol [formatting write!]
  (if (get formatting :indent)
    (write! "\n")))

(defn write-string [form formatting depth write!]
  (write-indent formatting depth write!)
  (write! (escape form))
  (write-eol formatting write!))

# hoisting functions like it's 1989. god this is so bad.
# using ^ as a hoisted sigil (up arrow, i guess?)
(var- process-form^ nil)

(defn write-tag
  [name attrs children formatting depth write!]
  (write-indent formatting depth write!)
  (write! "<" (string name))

  (def attr-count (length attrs))
  # Don't print a space after things like <object>
  # not <object >
  (if (> attr-count 0)
    (write! " "))
  (var count 0)
  (loop [[k v] :pairs attrs :after (++ count)]
    # this is confusing. writing: k="v"
    (write! (if (get formatting :capitalize-attrs)
              (capitalize k)
              k))
    (write! "=\"")
    (write! (escape v))
    (write! "\"")
    (if (< count (- attr-count 1))
      (write! " ")))

  (if (empty? children)
    (write! " />")
    (do
      (write! ">")
      (write-eol formatting write!)
      (loop [kid :in children]
        (process-form^ kid formatting (inc depth) write!))
      (write-indent formatting depth write!)
      (write! "</" (string name) ">")))
  (write-eol formatting write!))

(defn process-form
  "Write a Janet form to whatever kind of XML it needs to go to"
  [form formatting depth write!]
  (cond
    (not (indexed? form)) (write-string form formatting depth write!)
    (let [name (get form 0)
          maybe-attrs (get form 1)
          has-attrs (dictionary? maybe-attrs)
          attrs (if has-attrs maybe-attrs {})
          children (drop (if has-attrs 2 1) form)]
      (write-tag name attrs children formatting depth write!))))
(set process-form^ process-form)

(defn write
  "Entrypoint function, write janet forms to XML"
  [form &opt formatting buf]
  (def formatting (if formatting
                    (merge (default-formatting) formatting)
                    (default-formatting)))
  (def buf (or buf @""))
  (def write! (partial buffer/push-string buf))

  # sigh
  (write! `<?xml version="1.0" encoding="UTF-8"?>` "\n")
  (process-form form formatting 0 write!)
  buf)
