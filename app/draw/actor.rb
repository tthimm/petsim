class Actor
  include Actions
  attr_reader :x, :y, :current_image
  attr_accessor :move

  def initialize(window, x, y, img)
    @window, @x, @y = window, x, y
    @dir = :left
    @vy = 0 # Vertical velocity
    @map = @window.map
    @standing, @left, @right, @jump, @drink = image_tiles(img)
    @current_image = @standing
    @move = 0 # x axis
  end

  def image_tiles(img)
    image = "data/img/#{img}.png"
    if File.exists?(image) then
      standing, left, right, jump, drink = *Image.load_tiles(@window, image,
        49, 49, false)
      return standing, left, right, jump, drink
    else
      raise "File not found: #{image}"
    end
  end

  def draw
    @current_image.draw(@x, @y - @current_image.height + 1, ZOrder::ACTOR,
      1.0, 1.0)
  end

  # Could the object (actor) be placed at x + offs_x/y + offs_y without
  #  being stuck?
  def would_fit(x_offset, y_offset)
    # Check for map collisions
    map_not_solid_at?(@x + x_offset, @y + y_offset)
  end

  def map_not_solid_at?(x, y)
    # top/left, top/right, bottom/left, bottom/right
    height = @current_image.height
    width = @current_image.width
    solid = !@map.solid?(x + width, y) &&    # top/left
      !@map.solid?(x, y) &&                  # top/right
      !@map.solid?(x + width, y - height) && # bottom/left
      !@map.solid?(x, y - height)            # bottom/right
    return solid
  end

  def update
    # Select image depending on action
    if (@move == 0) then
      @current_image = @standing
    end
    if (@vy < 0)
      @current_image = @jump
    end
    if thirsty? && @map.waterbowl.level > 0 then
      move_to_waterbowl
      drink_water
    else
      move_to_waterbowl
      meow unless @meowed
      @meowed ||= true
    end

    # Directional walking, horizontal movement
    if @move > 0 then
      @current_image = @right
      @move.times do
        if would_fit(1, 0) then
          @x += 1
        end
      end
    end
    if @move < 0 then
      @current_image = @left
      (-@move).times do
        if would_fit(-1, 0)then
          @x -= 1
        end
      end
    end

    # Acceleration/gravity
    # By adding 1 each frame, and (ideally) adding vy to y, the player's
    # jumping curve will be the parabole we want it to be.
    @vy += 1
    # Vertical movement
    if @vy > 0 then
      @vy.times { if would_fit(0, 1) then @y += 1 else @vy = 0 end }
    end
    if @vy < 0 then
      (-@vy).times { if would_fit(0, -1) then @y -= 1 else @vy = 0 end }
    end
  end

  def try_to_jump
    if standing_on_solid_ground? then
      @vy = -15
    end
  end

  def standing_on_solid_ground?
    # if ground is solid below actor left/center/right, actor is standing
    @map.solid?(@x, @y + 1) ||
      @map.solid?(@x + @current_image.width/2, @y + 1) ||
      @map.solid?(@x + @current_image.width, @y + 1)
  end


end
