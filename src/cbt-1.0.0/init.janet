(import ./colors :as colors :export true)
(import ./xml :as xml :export true)
(import ./xml-helpers/objects :as xml-helpers/objects :export true)
(import ./xml-helpers/population-tables :as xml-helpers/population-tables :export true)

(import ./cli :as cli)
(import ./globals :prefix "")

(import spork/path)

(defn set-debug-output
  "Turn on or off higher debugging output"
  [bool]
  (put *CBT-GLOBALS* :debug-output bool))

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
  [id name author version mod-config
   &named
   description thumbnail tags steam-id steam-name steam-visibility load-order]
  (put *CBT-GLOBALS* :manifest
       {:id id :name name :author author :version version
        :description (or description name)
        :tags (or tags [])
        :steam-id (or steam-id nil)
        :steam-visiblity (if steam-visibility
                           (string steam-visibility)
                           2)
        :steam-name (or steam-name name)
        :load-order (or load-order 0)
        :thumbnail (or thumbnail nil)})

  # might as well load the env now, just in case they set it from the script?
  (if-let [qud-dlls
           (os/getenv "CBT_QUD_DLLS_FOLDER" nil)]
    (put *CBT-GLOBALS* :qud-dlls (path/normalize qud-dlls))
    (error "cbt requires the CBT_QUD_DLLS_FOLDER environment variable set to the location of all the Caves of Qud dlls. This replaces `(build-metadata)` from older versions of CBT"))
  (if-let [qud-mods-folder
           (os/getenv "CBT_QUD_MODS_FOLDER" nil)]
    (put *CBT-GLOBALS* :qud-mods-folder (path/normalize qud-mods-folder))
    (error "cbt requires the CBT_QUD_MODS_FOLDER environment variable set to where Caves of Qud loads local mods from. This replaces `(build-metadata)` from older versions of CBT")))

(defn set-build-dir
  ```
  Set the output directory.

  By default this is `./build`
  ```
  [dir]
  (put *CBT-GLOBALS* :build-dir
       (path/normalize dir)))

(defn set-resources-dir
  ```
  Set the directory from which files are copied verbatim into the build dir.
  Use this for textures, .cs files, and any XML you don't want Janet to generate.

  By default this is `./src/resources`
  ```
  [dir]
  (put *CBT-GLOBALS* :resources-dir
       (path/normalize dir)))

(defn generate-file
  ```
  Stage a file to be generated.
  Pass in the target path in the build folder and a thunk returning a string.
  ```
  [path func]
  (if-let [old ((*CBT-GLOBALS* :file-generators) path)]
    (errorf "Already staged a file generator at path %m: %m" path old))

  (put (*CBT-GLOBALS* :file-generators) path func))

(defn generate-xml
  ```
  Stage an XML file to be generated via the specified function.
  This just wraps the function with xml/write and sends it to generate-file.
  ```
  [path func &opt formatting]
  (default formatting (xml/default-formatting))
  (generate-file path (fn [] (xml/write (func) formatting))))

(defn set-debug-output
  "Turn on or off higher debugging output"
  [&opt high]
  (put *CBT-GLOBALS* :debug-output (if (nil? high) true high)))

###

(defn main
  "Main function to be run after everything"
  [& args]
  (cli/process-args (drop 1 args))) # Drop ./mod.janet

