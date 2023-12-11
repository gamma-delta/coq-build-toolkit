(use ../cbt/globals)

(import spork/json)
(import spork/path)
(import filesystem :as fs)

(def- build-dir (*cbt* :build-dir))
(def- resources-dir (*cbt* :resources-dir))

(defn- write-resource-file [path contents]
  (def path (path/join build-dir path))
  (fs/write-file path contents))

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

(defn coq-manifest-json []
  (dbg "Writing CoQ manifest")
  (def manifest (*cbt* :manifest))
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

(defn workshop-manifest-json []
  (dbg "Writing workshop.json")
  (def manifest (*cbt* :manifest))
  (if (has-key? manifest :steam-id)
    (do
      (def workshop-id (manifest :steam-id))
      (def to-dump (table "WorkshopId" workshop-id
                          "Visibility" (manifest :steam-visibility)
                          "ImagePath" (manifest :thumpnail)
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

(defn copy-resources []
  (copy-tree resources-dir build-dir))

(defn generate-files []
  (loop [[path thunk] :pairs (*cbt* :file-generators)]
    (def content (thunk))
    (dbg "Generating file %m" path)
    (write-resource-file path content)))

(defn do-hooks []
  (loop [hook :in (*cbt* :hooks)]
    (dbg "Calling hook %m" hook)
    (hook *cbt*)))

(defn build []
  (fs/recreate-directories build-dir)

  (write-resource-file "manifest.json" (coq-manifest-json))
  (if-let [workshop-json (workshop-manifest-json)]
    (write-resource-file "workshop.json" workshop-json))
  (copy-resources)
  (generate-files))

(defn install "Does not build, do that yourself"
  []
  (def manifest (*cbt* :manifest))
  (def mod-target (path/join
                    (*cbt* :qud-mods-folder)
                    (manifest :id)))
  (dbg "installing mod to %s" mod-target)
  (fs/recreate-directories mod-target)
  (copy-tree build-dir mod-target))
