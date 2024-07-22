(import ../colors :as colors)
(use ../xml)
(use ../utils)

(import utf8)

(defn utf8->cp437
  `Map UTF8 characters to CP437 strings like the Render part wants.`
  [ch]
  (def cps (utf8/to-codepoints ch))

  (def code (if (= 1 (length cps))
              (cps 0)
              (error "Must be an integer or single-character string")))

  (if (and (<= 0x20 ch) (<= ch 0x7e))
    (return (utf8/from-codepoints ch)))
  # thank you to bracket-lib for having these code points laid out
  # https://github.com/amethyst/bracket-lib/blob/master/bracket-terminal/src/consoles/text/codepage437.rs
  # i have put them into Beeg Chunks to avoid having most of the loc in this file being string constants.
  (def out (case ch
             "☺" :001 "☻" :002 "♥" :003 "♦" :004 "♣" :005 "♠" :006 "•" :007 "◘" :008 "○" :009 "◙" :010 "♂" :011 "♀" :012 "♪" :013 "♫" :014 "☼" :015 "►" :016

             "◄" :017 "↕" :018 "‼" :019 "¶" :020 "§" :021 "▬" :022 "↨" :023 "↑" :024 "↓" :025 "→" :026 "←" :027 "∟" :028 "↔" :029 "▲" :030 "▼" :031

             "⌂" :127

             "Ç" :128 "ü" :129 "é" :130 "â" :131 "ä" :132 "à" :133 "å" :134 "ç" :135 "ê" :136 "ë" :137 "è" :138 "ï" :139 "î" :140 "ì" :141 "Ä" :142 "Å" :143

             "É" :144 "æ" :145 "Æ" :146 "ô" :147 "ö" :148 "ò" :149 "û" :150 "ù" :151 "ÿ" :152 "Ö" :153 "Ü" :154 "¢" :155 "£" :156 "¥" :157 "₧" :158 "ƒ" :159

             "á" :160 "í" :161 "ó" :162 "ú" :163 "ñ" :164 "Ñ" :165 "ª" :166 "º" :167 "¿" :168 "⌐" :169 "¬" :170 "½" :171 "¼" :172 "¡" :173 "«" :174 "»" :175

             "░" :176 "▒" :177 "▓" :178 "│" :179 "┤" :180 "╡" :181 "╢" :182 "╖" :183 "╕" :184 "╣" :185 "║" :186 "╗" :187 "╝" :188 "╜" :189 "╛" :190 "┐" :191

             "└" :192 "┴" :193 "┬" :194 "├" :195 "─" :196 "┼" :197 "╞" :198 "╟" :199 "╚" :200 "╔" :201 "╩" :202 "╦" :203 "╠" :204 "═" :205 "╬" :206 "╧" :207

             "╨" :208 "╤" :209 "╥" :210 "╙" :211 "╘" :212 "╒" :213 "╓" :214 "╫" :215 "╪" :216 "┘" :217 "┌" :218 "█" :219 "▄" :220 "▌" :221 "▐" :222 "▀" :223

             "α" :224 "ß" :225 "Γ" :226 "π" :227 "Σ" :228 "σ" :229 "µ" :230 "τ" :231 "Φ" :232 "Θ" :233 "Ω" :234 "δ" :235 "∞" :236 "φ" :237 "ε" :238 "∩" :239

             "≡" :240 "±" :241 "≥" :242 "≤" :243 "⌠" :244 "⌡" :245 "÷" :246 "≈" :247 "°" :248 "∙" :249 "·" :250 "√" :251 "ⁿ" :252 "²" :253 "■" :254
             nil))

  (if (nil? out)
    (errorf "The character %s was not a CP437 character" ch))
  out)

(defn part [name & kvs]
  [:part (table :Name name ;kvs)])

(defn render
  ```
  Create a <Render> part.

  `foreground` and `detail` are the two colors used to palette the texture.

  `background` is used for the background of the tile, or what's transparent in the texture. Generally leave this be.

  `cp437` is either a 1-char string or a 3-char octal number string for the text mode display.

  `render-layer` is how high in the world it displays.
  ```
  [name tile foreground detail &named background cp437 render-layer]
  (part "Render"
        :DisplayName name
        :Tile tile
        :ColorString (colors/color-string foreground background)
        :DetailColor detail
        ;(if cp437 [:RenderString cp437] [])
        ;(if render-layer [:RenderLayer render-layer] [])))

(defn description
  "Create a Description part."
  [& descs]
  (part "Description"
        :Short (string ;descs)))

(defn commerce
  "Create a Commerce part."
  [price]
  (part "Commerce"
        :Value price))

(defn mutation
  "Define a <mutation> tag."
  [name &opt level cap-override]
  [:mutation {:Name name
              ;(if level [:Level level] [])
              ;(if cap-override [:CapOverride cap-override] [])}])

(defn tag
  `Define a <tag Name="foo" Value="bar"> ... XML tag.`
  [name &opt value]
  # Must use struct fn instead of literal here because of bug:
  # it only accepts an even number of K-V pairs in a struct literal, even though
  # it handles splatting a kv pair fine...
  [:tag (struct :Name name
                ;(if value [:Value value] []))])

(defn removepart
  "Define a <removepart> tag."
  [part]
  [:removepart {:Name part}])

(defn stat
  "Define a <stat> tag."
  [name value]
  [:stat {:Name name :sValue value}])

(defn inventoryobject
  "Define an <inventoryobject> tag."
  [blueprint number]
  [:inventoryobject {:Blueprint blueprint :Number number}])

(defn intproperty
  [name val]
  (tag* :intproperty :Name name :Value val))

# ===

(defn object [name opts & bodies]

  [:object
   (merge {:Name name} opts)
   ;bodies])
