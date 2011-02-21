class Dependency
  attr_reader :directories
  def initialize
    @directories = [] # the directories we are loading
    @ignore_list = [] # files that should not be loaded
    @patterns    = [] # which files to load first (regexp)
  end

  def ignore(filename)
    @ignore_list << filename
  end

  def add_dir(dir)
    @directories << dir
  end

  def add_rule(rule)
    @patterns << rule
  end

  def get_files(dir)
    files = Dir.glob( dir + "/" + File.join("**","*.rb")).sort
    return files
  end

  def move_to_front(files, index)
    filename = files[index] # save filename
    files.delete_at(index)  # remove filename
    files.unshift(filename) # add filename to front
  end

  def process_rules(files)
    go_down = @patterns.length
    step = @patterns.length - 1
    go_down.times do |rule|
      files.each_with_index do |file, index|
        if file.match(@patterns[step]) then
           files = move_to_front(files, index)
        end
      end
      step -= 1
    end
    return files
  end

  def require_all(files)
    files.each do |file|
      action = true
      @ignore_list.each do |ignore|
        if file == ignore then
          action = false
        end
      end
      if action == true then
        require "#{File.dirname(__FILE__)}/../../#{file}"
        #puts "Loaded file: #{file}" if DEBUG
      end
    end
  end

  def load_directory(dir)
    files = get_files(dir)
    files = process_rules(files)
    require_all(files)
  end

  def process_directories
    @directories.each do |dir|
      load_directory(dir)
    end
  end


end

