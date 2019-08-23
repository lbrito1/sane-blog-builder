require 'kramdown'
require './lib/foo_logger'

class Builder
  include FooLogger

  def call
    Dir["./input/*.md"].each do |path|
      log("Building #{path}...")

      input = File.read(path)
      output = Kramdown::Document.new(input).to_html

      output_path = path.split("/").last.gsub(".md", "")
      File.write("./output/#{output_path}.html", output)
    end

    log("Done!")
  end
end
