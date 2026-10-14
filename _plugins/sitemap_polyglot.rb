# frozen_string_literal: true

# jekyll-sitemap keys its entries off page.url, and jekyll-polyglot does not
# rewrite page.url for the /zh/ tree. Both trees therefore produced identical
# URLs, everything in the Chinese tree was deduplicated away, and the sitemap
# only ever listed the English pages - 82 of 164.
#
# _includes/head.liquid now emits a language-correct canonical on every page, so
# the built HTML is the authoritative list of canonical URLs. This hook adds
# whichever of them the sitemap is missing.
#
# It only ever adds: entries jekyll-sitemap produced are left untouched, and only
# */index.html files are read, so 404.html, feed.xml and assets cannot leak in.
Jekyll::Hooks.register :site, :post_write do |site|
  # polyglot points site.dest at <root>/<lang> while writing a non-default
  # language tree, but the sitemap robots.txt advertises lives at the root. Fire
  # both passes against the root so the result is complete and idempotent.
  root = site.dest
  languages = site.config["languages"] || []
  root = File.dirname(root) if languages.include?(File.basename(root))

  sitemap_path = File.join(root, "sitemap.xml")
  next unless File.exist?(sitemap_path)

  sitemap = File.read(sitemap_path)
  listed = {}
  sitemap.scan(%r{<loc>\s*([^<\s]+)\s*</loc>}) { |match| listed[match.first] = true }

  canonical = {}
  Dir[File.join(root, "**", "index.html")].each do |path|
    match = File.read(path).match(%r{<link rel="canonical" href="([^"]+)"})
    canonical[match[1].strip] = true if match
  end

  missing = canonical.keys.reject { |url| listed[url] }.sort
  next if missing.empty?

  entries = missing.map { |url| "<url>\n<loc>#{url}</loc>\n</url>\n" }.join
  sitemap.sub!("</urlset>", "#{entries}</urlset>")
  File.write(sitemap_path, sitemap)
  Jekyll.logger.info "Sitemap:", "added #{missing.size} canonical URL(s) missing from the sitemap"
end
