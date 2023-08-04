(declare-project
  :name "coq-build-tools"
  :description "Build tools for Caves of Qud"

  :dependencies [{:repo "https://github.com/janet-lang/spork"
                  :tag "1d31c6884c15c77d27de54109425bc930049f38d"}
                 {:repo "https://github.com/jeannekamikaze/janet-filesystem"
                  :tag "1a3403280a951ddc6004db44af8126e1aa61a39f"}
                 {:repo "https://github.com/andrewchambers/janet-utf8.git"}])

(declare-source
  :source ["src/cbt.janet" "src/cbt"])
