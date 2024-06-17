(def version "1.0.0")

(declare-project
  :name (string "coq-build-tools-" version)
  :description "Build tools for Caves of Qud"
  :version version

  :dependencies [{:repo "https://github.com/janet-lang/spork"
                  :tag "1d31c6884c15c77d27de54109425bc930049f38d"}
                 {:repo "https://github.com/andrewchambers/janet-utf8.git"}
                 # I have forked the original repo because it borken
                 {:repo "https://github.com/gamma-delta/janet-filesystem"
                  :tag "main"}])

(declare-source
  :source [(string "src/cbt-" version)])
