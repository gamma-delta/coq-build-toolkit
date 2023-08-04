(declare-project
  :name "coq-build-tools"
  :description "Build tools for Caves of Qud"

  :dependencies [{:repo "https://github.com/janet-lang/spork"
                  :tag "1d31c6884c15c77d27de54109425bc930049f38d"}
                 {:repo "https://github.com/andrewchambers/janet-utf8.git"}
                 # I have forked the original repo because it borken
                 {:repo "https://github.com/gamma-delta/janet-filesystem"
                  :tag "main"}])

(declare-source
  :source ["src/cbt.janet" "src/cbt"])
