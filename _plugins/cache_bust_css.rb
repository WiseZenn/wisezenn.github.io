# frozen_string_literal: true

# jekyll-cache-bust 0.0.1 implements `bust_css_cache` by hashing everything under
# `assets/_sass`. This repository keeps its styles in `_sass/`, so the glob
# matched nothing and every page shipped
#   /assets/css/main.css?v=d41d8cd98f00b204e9800998ecf8427e
# which is the MD5 of an empty string. The version never changed, so returning
# visitors kept the stale stylesheet after a style edit.
#
# Plugin files in _plugins/ are loaded after gem plugins, so registering the
# filter again here replaces the broken one. The digest now covers the real SCSS
# sources, which is what the version string is supposed to track.

require "digest"

module Jekyll
  module CacheBustCssFixed
    def bust_css_cache(file_name)
      files = Dir[File.join("_sass", "**", "*")].select { |path| File.file?(path) }.sort
      digest = Digest::MD5.hexdigest(files.map { |path| File.read(path) }.join)
      "#{file_name}?v=#{digest}"
    end
  end
end

Liquid::Template.register_filter(Jekyll::CacheBustCssFixed)
