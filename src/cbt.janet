(import ./cbt/xml :as xml :export true)
(import ./cbt/colors :as colors :export true)
(import ./cbt/xml-helpers/objects :as xml-helpers/objects :export true)

(import ./cbt/cli :as cli)
(use ./cbt/globals)

(import spork/path)

(defn build-metadata
  ```
  Write down build metadata specific to your computer here.

  If you are worried about your ability to make PRs to another person's mod without changing this value all the time, don't worry!
  Use `git add -p .` and you can selectively add parts of your files,
  so that the new build metadata stays on your local copy but isn't put into the PR.

  If you're worried about your user name leaking, create a `secrets.janet` file,
  define the metadata in there, `gitignore` it, and import it here.
  ```
  [&named qud-dlls qud-mods-folder]
  (put *cbt* :qud-dlls qud-dlls)
  (put *cbt* :qud-mods-folder qud-mods-folder))

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

  steam-visibility: I don't remember what this does

  load-order: Order for CoQ to load things in. Given that there's no way to coordinate this with *other* mods it's pretty useless but it's in the API for completeness' sake.

  steam-name: Name that gets put into the Steam workshop, where formatting codes don't work
  ```
  [id name author version
   &named
   description thumbnail tags steam-id steam-name steam-visibility load-order]
  (if-not (nil? (get *cbt* :manifest))
    (error "Only call declare-mod once"))

  (default description "")
  (default thumbnail nil)
  (default tags [])
  (default steam-id nil)
  (default steam-visibility 2)
  (default load-order 0)
  (default steam-name name)

  (put *cbt* :manifest {:id id :name name
                        :author author
                        :version version
                        :description description
                        :tags tags
                        :steam-id steam-id
                        :steam-visiblity (string steam-visibility)
                        :steam-name steam-name
                        :load-order load-order
                        :thumbnail thumbnail}))

(defn set-build-dir
  ```
  Set the output directory.

  By default this is `./build`
  ```
  [dir]
  (put *cbt* :build-dir
       (path/normalize dir)))

(defn set-resources-dir
  ```
  Set the directory from which files are copied verbatim into the build dir.
  Use this for textures, .cs files, and any XML you don't want Janet to generate.

  By default this is `./src/resources`
  ```
  [dir]
  (put *cbt* :resources-dir
       (path/normalize dir)))

(defn add-hook
  ```
  Set an arbitrary function to be run when the mod is built.

  The function receives the CBT info table as its first and only argument.
  ```
  [hook]
  (array/push (*cbt* :hooks) hook))

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
  This just wraps the function with xml/write and sends it to generate-file.
  ```
  [path func &opt formatting]
  (default formatting (xml/default-formatting))
  (generate-file path (fn [] (xml/write (func) formatting))))

(defn generate-object-blueprints
  ```
  Even-more-helper function that wraps the output of a function
  in an `[:objects ...]` tag and generates it as "ObjectBlueprints.xml".

  Note that CoQ doesn't actually need any particular file name; it just
  looks for an `<objects>` root tag. But "ObjectBlueprints.xml" is
  traditional.
  ```
  [func &opt formatting]
  (generate-xml "ObjectBlueprints.xml"
                (fn []
                  [:objects ;(func)])))

(defn set-debug-output
  "Turn on or off higher debugging output"
  [bool]
  (put *cbt* :debug-output bool))

###

(defn main
  "Main function to be run after everything"
  [& args]
  (cli/process-args (drop 1 args))) # Drop ./mod.janet

