#!/usr/bin/env ruby

require "#{File.dirname(__FILE__)}/config/environment.rb"

class GameWindow < Window
  attr_reader :map
  attr_accessor :menu_selected

  def initialize(width, height, caption, fullscreen)
    super(width, height, fullscreen)
    self.caption = caption
    @last_frame = milliseconds
    @menu = Menu.new(self)
    @menu_background = Background.new(self, :color => :sky_blue)
    @game_title = Text.new(self, '', 80, 100)
    @sky = Background.new(self, :color => :sky_blue)

    @map = Map.new(self, "001.map")
    @pet = Pet.new(self, @map.pet.first, @map.pet.last, :pet)
    # The scrolling position is stored as top left corner of the screen.
    @camera_x = @camera_y = 0
    @menu_selected = true
    @menu.highlight_start
    @hud = Hud.new(self, @pet)
    self.set_mouse_position(self.width, self.height)
    sometimes_generate_waypoints
  end

  # TODO: doesn't belong to GameWindow. create module
  def sometimes_generate_waypoints
    if map_changed_or_new_map? then
      generate_waypoints
    end
  end

  def generate_waypoints
    puts "TODO: generate waypoints"
  end

  def map_changed_or_new_map?
    path = "data/maps/"
    md5_file = path + "map.md5"
    map_file = path + @map.file_name
    
    case File.read(md5_file) == file_hash(path, map_file)
    when true
      return false
    when false
      write_md5_file(path, md5_file, map_file)
      return true
    end
  end

  def file_hash(path, file)
    %x(md5sum #{file}).sub(/#{path}/, '')
  end

  def write_md5_file(path, md5_file, map_file)
    File.open(md5_file, "w") do |file|
        file.puts file_hash(path, map_file)
    end
  end

  def update
    calculate_delta
    @pet.move = 0
    @pet.move -= 5 if button_down?(KbLeft)
    @pet.move += 5 if button_down?(KbRight)
    @pet.update
    # Scrolling follows pet
    @camera_x = [[@pet.x - 320, 0].max, @map.width * 50 - screen_width].min
    @camera_y = [[@pet.y - 240, 0].max, @map.height * 50 - screen_height].min
    @hud.update
    @map.waterbowl.update
  end

  def calculate_delta
    @this_frame = milliseconds
    @delta = (@this_frame - @last_frame) / 1000.0
    @last_frame = @this_frame
  end

  def draw
    if @menu_selected then
      @menu_background.draw
      @game_title.draw(:black)
      @menu.draw
    else
      @sky.draw# 0, 0, 0
      translate(-@camera_x, -@camera_y) do
        @map.draw
        @pet.draw
      end
      #if @hud.show && @hud_time > milliseconds.in_seconds then
        @hud.draw
      #end
    end
  end

  def button_down(id)
    if @menu_selected then
      @menu.button_down(id)
    else
      case id
      when KbSpace
        @pet.try_to_jump
      when KbEscape
        @menu_selected = true
      when KbTab
        @hud_time = @this_frame.in_seconds + @hud.visibility.in_seconds
        @hud.show = true
      end
    end
  end


end

window = GameWindow.new(screen_width, screen_height, 'cat simulation', true)
window.show

