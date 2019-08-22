module Logger
  def log(msg)
    puts "#{Time.now} - #{self.class.name} - #{msg}"
  end
end
