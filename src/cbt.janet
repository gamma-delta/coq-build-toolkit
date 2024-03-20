(import ./cbt/xml :as xml :export true)
(import ./cbt/colors :as colors :export true)
(import ./cbt/xml-helpers/objects :as xml-helpers/objects)
(import ./cbt/xml-helpers/population-tables :as xml-helpers/population-tables :export true)

(import ./cbt/cli :as cli)
(use ./cbt/globals)

(import spork/path)
(import jpm)

(def object :macro xml-helpers/objects/object)

(defn build-metadata
  ```
  Write down build metadata specific to your computer here.

  If you are worried about your ability to make PRs to another person's mod without changing this value all the time, don't worry!
  Use `git add -p .` and you can selectively add parts of your files,
  so that the new build metadata stays on your local copy but isn't put into the PR.

  If you're worried about your user name leaking, create a `secrets.janet` file,
  define the metadata in there, `gitignore` it, and import it here.
  ```
  [&named qud-dlls qud-mods-folder build-dir]
  (put *cbt* :qud-dlls qud-dlls)
  (put *cbt* :qud-mods-folder qud-mods-folder))

(defn- generate-file
  ```
  Stage a file to be generated.
  Pass in the target path in the build folder and a thunk returning a string.
  ```
  [cbt path func]
  (if-let [old ((cbt :file-generators) path)]
    (errorf "Already staged a file generator at path %m: %m" path old))

  (put (cbt :file-generators) path func))

(defn- generate-xml
  ```
  Stage an XML file to be generated via the specified function.
  This just wraps the function with xml/write and sends it to generate-file.
  ```
  [cbt path func &opt formatting]
  (default formatting (xml/default-formatting))
  (generate-file cbt path (fn [] (xml/write (func) formatting))))

(defn- generate-object-blueprints
  ```
  Even-more-helper function that wraps the output of a function
  in an `[:objects ...]` tag and generates it as "ObjectBlueprints.xml".

  Note that CoQ doesn't actually need any particular file name; it just
  looks for an `<objects>` root tag. But "ObjectBlueprints.xml" is
  traditional.
  ```
  [cbt func &opt formatting]
  (generate-xml cbt "ObjectBlueprints.xml"
                (fn []
                  [:objects ;(func)])))

(defn set-debug-output
  "Turn on or off higher debugging output"
  [cbt bool]
  (put cbt :debug-output bool))

(defmacro declare-mod
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

  resources-dir: Directory of files that are copied as-is into the build dir. Use this for textures, .cs files, and any XML you don't want Janet to generate. By default this is `./src/resources`
  ```
  [id name author version mod-config & bodies]
  (default task-name "cbt")

  (with-syms [$id $name $author $version $mod-config]
    ~(let
       [,$id ,id ,$name ,name ,$author ,author ,$version ,version
        ,$mod-config ,mod-config
        cbt {:id ,$id :name ,$name :author ,$author :version ,$version
             :description (get ,$mod-config :description ,$name)
             :tags (get ,$mod-config :tags [])
             :steam-id (get ,$mod-config :steam-id nil)
             :steam-visiblity (if-let [sv (get ,$mod-config :steam-visibility)]
                                (string steam-visibility)
                                2)
             :steam-name (get ,$mod-config :steam-name ,$name)
             :load-order (get ,$mod-config :load-order 0)
             :thumbnail (get ,$mod-config :thumbnail nil)

             :build-dir (if-let [bd (get ,$mod-config :build-dir)]
                          (path/normalize bd)
                          "./build")
             :resources-dir (if-let [rd (get ,$mod-config :resources-dir)]
                              (path/normalize rd)
                              "./resources")

             :file-generators @{}
             :debug-output false}
        generate-file ,(partial generate-file cbt)
        generate-xml ,(partial generate-xml cbt)
        generate-object-blueprints ,(partial generate-object-blueprints cbt)]
       ;bodies)))

###

(defn main
  "Main function to be run after everything"
  [& args]
  (cli/process-args (drop 1 args))) # Drop ./mod.janet

