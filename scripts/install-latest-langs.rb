#!/usr/bin/env ruby

# Installs a collection of languages using asdf

langs = %w[
  clojure
  crystal
  elixir
  elm
  erlang
  golang
  gradle
  haskell
  java
  lua
  nim
  nodejs
  ocaml
  php
  python
  R
  ruby
  rust
  scala
  solidity
  swift
]

langs.each do |lang|
  output = `asdf plugin-add #{lang}`
  puts output

  versions = `asdf list-all #{lang}`.split(' ')
  most_recent_core_version = versions.select { |v| v.match? /\A[0-9._-]+\z/ }.last
  output = `asdf install #{lang} #{most_recent_core_version}`
  puts output

  output = `asdf global #{lang} #{most_recent_core_version}`
  puts output
end
