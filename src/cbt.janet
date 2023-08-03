(import ./cbt/xml :as xml :export true)
(import ./cbt/color-table :as color-table :export true)
(import ./cbt/render :as render :export true)
(import ./cbt/cli :as cli)

(use ./cbt/globals)

(defn declare-mod
  ```
  Declare a mod with the given information. Please only call this once.

  Named arguments are optional.

  id: String ID of the mod.
  name: Name of the mod. You can use CoQ formatting codes here.
  author: Your name. You can use CoQ formatting codes here.
  version: Mod version
  ---
  description: Short description of the mod. This is put into the Caves of Qud manifest.json.
  thumbnail: Path (RELATIVE TO THE BUILD FOLDER) of a preview image.
  tags: List of tags for the mod. Used for CoQ metadata.
  steam-id: ID of the mod on the Steam workshop. Leave blank until you have uploaded it.
  load-order: Order for CoQ to load things in. Given that there's no way to coordinate this with *other* mods it's pretty useless but it's in the API for completeness' sake.
  ```
  [id name author version &named description thumbnail tags steam-id load-order]
  (if-not (nil? (get *cbt* :manifest))
    (error "Only call declare-mod once"))

  (default description "")
  (default thumbnail nil)
  (default tags [])
  (default steam-id nil)
  (default load-order 0)

  (put *cbt* :manifest {:id id :name name
                        :author author
                        :version version
                        :description description
                        :tags tags
                        :steam-id steam-id
                        :load-order load-order}))

(defn set-build-dir
  ```
  Set the output directory.
  ```
  [dir]
  (put *cbt* :build-dir
       (if (= (string/slice dir -1) "/")
         (string/slice dir 0 -2)
         dir)))

(defn set-resources-dir
  ```
  Set the directory from which files are copied verbatim into the build dir.
  Use this for textures, .cs files, and any XML you don't want Janet to generate.
  ```
  [dir]
  (put *cbt* :resources-dir
       (if (= (string/slice dir -1) "/")
         (string/slice dir 0 -2)
         dir)))

(defn generate-file
  ```
  Stage a file to be generated.
  Pass in the target path in the build folder and a thunk returning a string.
  ```
  [path func]
  (if-let [old ((*cbt* :file-generators) path)]
    (errorf "Already staged a file generator at path %m: %m" path old))

  (put (*cbt* :file-generators) path func))

(defn generate-xml
  ```
  Stage an XML file to be generated via the specified function.
  This just wraps the function with xml/write and sends it to generate-file
  ```
  [path func]
  (generate-file path (fn [] (xml/write (func)))))

(defn set-debug-output
  "Turn on or off higher debugging output"
  [bool]
  (put *cbt* :debug-output bool))

###

(defn main
  "Main function to be run after everything"
  [& args]
  (cli/process-args (drop 1 args))) # Drop ./mod.janet

