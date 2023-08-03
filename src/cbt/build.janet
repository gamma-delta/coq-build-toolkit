(use ../cbt/globals)

(import spork/json)
(import filesystem :as fs)

(def- build-dir (*cbt* :build-dir))
(def- resources-dir (*cbt* :resources-dir))

(defn- write-file [path contents]
  (def path (string build-dir "/" path))
  (fs/write-file path contents))

(defn coq-manifest-json []
  (dbg "Writing CoQ manifest")
  (def manifest (*cbt* :manifest))
  (def to-dump @{"ID" (manifest :id)
                 "Title" (manifest :name)
                 "Description" (manifest :description)
                 "Version" (manifest :version)
                 "Author" (manifest :author)
                 "Tags" (string/join (manifest :tags) ",")})
  (if-let [thumb (manifest :thumbnail)]
    (put to-dump "PreviewImage" thumb))

  (json/encode to-dump
               "  " "\n"))

(defn copy-resources []
  (loop [path :in (fs/list-all-files resources-dir)]
    # Cut off the resources/ part
    (def target-path
      (string
        build-dir
        "/"
        (string/slice path (- (length resources-dir) 1))))
    (dbg "Copying %m -> %m" path target-path)
    (fs/copy-file
      path
      target-path)))

(defn generate-files []
  (loop [[path thunk] :pairs (*cbt* :file-generators)]
    (def content (thunk))
    (dbg "Generating file %m" path)
    (write-file path content)))

(defn build []
  (fs/recreate-directories build-dir)

  (write-file "manifest.json" (coq-manifest-json))
  (copy-resources)
  (generate-files))
