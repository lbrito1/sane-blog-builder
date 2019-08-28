desc "Create a new post"
task :new_post, :title do |t, args|
  mkdir_p './content/posts'
  args.with_defaults(:title => 'New Post')
  title = args.title
  filename = "./content/posts/#{Time.now.strftime('%Y-%m-%d')}-#{title.downcase.gsub(/\s/, "_")}.md"

  if File.exist?(filename)
    puts "File already exists."
    abort('rake aborted!')
  end

  puts "Creating new post: #{filename}"

  content = <<~EOF
    ---
    title: #{title}
    created_at: #{Time.now}
    kind: article
    published: false
    ---\n\n
  EOF

  File.write(filename, content)
end
