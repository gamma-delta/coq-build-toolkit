(use ../cbt/globals)

(import ../cbt/build :as build)

(var- subcommands^ nil)
(var- subcommands-table^ nil)

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

(defn- sub-build [args]
  (build/build)
  (print "All done!"))

(defn- dump [args]
  (printf "%M" *cbt*))

(def- subcommands [{:name "build"
                    :help "Build the mod."
                    :doc ```
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
