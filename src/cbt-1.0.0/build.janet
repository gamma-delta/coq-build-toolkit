(use ./globals)

(import spork/json)
(import spork/path)
(import filesystem :as fs)

(defn- copy-tree [src dest]
  (loop [path :in (fs/list-all-files src)]
    (def target-path
      (path/join
        dest
        # Copy things to .../dst/ instead of .../src/dst/
        (string/slice path (+ (length src) 1))))
    (dbg "Copying %m -> %m" path target-path)
    (fs/copy-file
      path
      target-path)))

(defn- write-resource-file [cbt path contents]
  (def path (path/join (cbt :build-dir) path))
  (fs/write-file path contents))

(defn coq-manifest-json [cbt]
  (def manifest (cbt :manifest))
  (dbg "Writing CoQ manifest")
  (def to-dump (table "ID" (manifest :id)
                      "Title" (manifest :name)
                      "Description" (manifest :description)
                      "Version" (manifest :version)
                      "Author" (manifest :author)
                      "Tags" (string/join (manifest :tags) ", ")
                      ;(if-let [thumb (manifest :thumbnail)]
                         ["PreviewImage" thumb] [])))

  (json/encode to-dump
               "  " "\n"))

(defn workshop-manifest-json [cbt]
  (def manifest (cbt :manifest))
  (dbg "Writing workshop.json")
  (if (has-key? manifest :steam-id)
    (do
      (def workshop-id (manifest :steam-id))
      (def to-dump (table "WorkshopId" workshop-id
                          "Visibility" (manifest :steam-visibility)
                          "Title" (manifest :steam-name)
                          "Description" (manifest :description)
                          "Author" (manifest :author)
                          "Tags" (string/join (manifest :tags) ", ")
                          ;(if-let [thumb (manifest :thumbnail)]
                             ["ImagePath" thumb] [])))

      (json/encode to-dump
                   "  " "\n"))
    (do
      (dbg "did not find steam ID, skipping workshop.json")
      nil)))

(defn copy-resources [cbt]
  (copy-tree (cbt :resources-dir) (cbt :build-dir)))

(defn generate-files [cbt]
  (loop [[path thunk] :pairs (cbt :file-generators)]
    (def content (thunk))
    (dbg "Generating file %m" path)
    (write-resource-file cbt path content)))

(defn do-hooks [cbt]
  (loop [hook :in (cbt :hooks)]
    (dbg "Calling hook %m" hook)
    (hook cbt)))

(defn build [cbt]
  (fs/recreate-directories (cbt :build-dir))

  (write-resource-file cbt "manifest.json" (coq-manifest-json cbt))
  (if-let [workshop-json (workshop-manifest-json cbt)]
    (write-resource-file cbt "workshop.json" workshop-json))
  (copy-resources cbt)
  (generate-files cbt))

(defn install "Does not build, do that yourself" [cbt]
  (def manifest (cbt :manifest))
  (def mod-target (path/join
                    (cbt :qud-mods-folder)
                    (manifest :id)))
  (dbg "installing mod to %s" mod-target)
  (fs/recreate-directories mod-target)
  (copy-tree (cbt :build-dir) mod-target))
