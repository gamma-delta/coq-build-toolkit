(use ../cbt/globals)

(import ../cbt/build :as build)

(import filesystem :as fs)

(var- subcommands^ nil)
(var- subcommands-table^ nil)

(defn- sub-init [args]
  (def manifest (*cbt* :manifest))
  (def id (manifest :id))
  (def formatted-csproj
    (string/format csproj-template
                   id id # Assembly name and pkg id
                   (manifest :author) # Authors
                   (*cbt* :qud-dlls)
                   # Ignore build directory so the langserver doesn't try to read both files  
                   (*cbt* :build-dir)))
  (fs/write-file (string id ".csproj") formatted-csproj)

  (def gitignore (string/join
                   [(string "/" (*cbt* :build-dir))
                    "/bin" "/obj"] # C# lang server folders
                   "\n"))
  (fs/write-file ".gitignore" gitignore)

  (fs/create-directories (*cbt* :resources-dir))
  (printf "Created new mod named %s" id))


(defn- sub-build [args]
  (build/build)
  (print "Built " (get-in *cbt* [:manifest :id])))

(defn- sub-install [args]
  (build/build)
  (build/install)
  (print "Built and installed " (get-in *cbt* [:manifest :id])))


(defn- sub-help [args]
  (printf ```
  C.B.T.: Coq Build Toolkit by petrak@, v%s
  https://github.com/gamma-delta/coq-build-toolkit
  ``` version)
  (match args
    [] (do
         (print "List of subcommands:")
         (loop [{:name name :help help} :in subcommands^]
           (printf "  %s: %s" name help)))
    [cmd-name] (let [cmd (subcommands-table^ cmd-name)]
                 (printf "%s : %s" cmd-name (cmd :help))
                 (print (cmd :doc)))))


(defn- dump [args]
  (printf "%M" *cbt*))

(def- subcommands
  [{:name "init"
    :help "Initialize a mod skeleton based on the information declared"
    :doc ```
         Usage: init
         Create a .csproj file and folders to help start the mod.
         ```
    :func sub-init}
   {:name "build"
    :help "Build the mod."
    :doc ```
         Usage: build
         Build the mod by generating XML files and manifests and copying everything to the build folder.
         ```
    :func sub-build}
   {:name "help"
    :help "Get help for subcommands."
    :doc ```
         Usage: help [subcommand]
         Print all the subcommands, or give help for a specific one.
         ```
    :func sub-help}
   {:name "install"
    :help "Build and install your mod"
    :doc ```
         Usage: install
         Install your mod to the location given in the build metadata.
         ```
    :func sub-install}
   {:name "dump"
    :help "Dump the CBT state to the terminal, for debugging purposes."
    :doc ```
         Usage: dump
         Pretty-print the *cbt* variable using `%M`.
         ```
    :func dump}])
(def- subcommands-table (tabseq [x :in subcommands]
                                (string (x :name)) x))

(set subcommands^ subcommands)
(set subcommands-table^ subcommands-table)

(defn process-args [args]
  (if-let [sub-name (get args 0)]
    (let [trail (drop 1 args)]
      (if-let [subcmd (get subcommands-table sub-name)]
        ((subcmd :func) trail)
        (printf "Unknown subcommand %s. Try `help` for a list of commands." sub-name)))
    (sub-help [])))
