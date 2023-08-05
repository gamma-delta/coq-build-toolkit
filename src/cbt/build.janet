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
        (string/slice path (- (length src) 1))))
    (dbg "Copying %m -> %m" path target-path)
    (fs/copy-file
      path
      target-path)))

(defn coq-manifest-json []
  (dbg "Writing CoQ manifest")
  (def manifest (*cbt* :manifest))
  (def to-dump @{"ID" (manifest :id)
                 "Title" (manifest :name)
                 "Description" (manifest :description)
                 "Version" (manifest :version)
                 "Author" (manifest :author)
                 "Tags" (string/join (manifest :tags) ", ")})
  (if-let [thumb (manifest :thumbnail)]
    (put to-dump "PreviewImage" thumb))

  (json/encode to-dump
               "  " "\n"))

(defn workshop-manifest-json []
  (dbg "Writing workshop.json")
  (def manifest (*cbt* :manifest))
  (def workshop-id (and (*cbt* :steam-id)
                        (do
                          (dbg "No steam ID present, not writing manifest json")
                          (return nil))))
  (def to-dump @{"WorkshopId" workshop-id
                 "Visibility" (manifest :steam-visibility)
                 "Title" (manifest :name)
                 "Description" (manifest :description)
                 "Author" (manifest :author)
                 "Tags" (string/join (manifest :tags) ", ")})
  (if-let [thumb (manifest :thumbnail)]
    (put to-dump "PreviewImage" thumb))

  (json/encode to-dump
               "  " "\n"))

(defn copy-resources []
  (copy-tree resources-dir build-dir))

(defn generate-files []
  (loop [[path thunk] :pairs (*cbt* :file-generators)]
    (def content (thunk))
    (dbg "Generating file %m" path)
    (write-resource-file path content)))

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
