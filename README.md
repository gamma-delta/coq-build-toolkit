# **C**oq **B**uild **T**ools

Janet library/script that helps you write Caves of Qud mods.

## To Use

- Install cbt using JPM or what have you.
- Create a `mod.janet` file (or whatever) in a new empty folder.
- `(use cbt)` at the top of that file.
- Run `janet mod.janet` to build, install, etc.

`cbt` defines a `main` function, so you can just use `janet` and run the file you use it in.
All your code will be compiled and run, and then `cbt`s argument parsing and stuff will take over.

After filling in your information to `(declare-mod)`, you can run `janet mod.janet init` to create the skeleton of folders and `.csproj` and all.

## Example:

Put this in your `mod.janet` file:

```janet
#!/usr/bin/env janet

(use cbt)

(declare-mod
  "my-mod-id"
  "My Funky Cool Mod!"
  "your name"
  "0.0.0")

(generate-xml
  "ObjectBlueprints.xml"
  (fn []
    [:objects
     [:object {:name "Foobar"}
      [:part {:name "Physics" :category "Tools" :weight 3}]]]))

```
