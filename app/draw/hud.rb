class Hud
  attr_accessor :show

  def initialize(window, actor)
    @window = window
    @actor = actor
    @thirst_hud = image_tiles(:thirst_bar)
    current_image
  end

  def current_image
    case @actor.thirst
    when 0..100
      @current_image = @thirst_hud[0]
    when 101..400
      @current_image = @thirst_hud[1]
    when 401..700
      @current_image = @thirst_hud[2]
    when 701..900
      @current_image = @thirst_hud[3]
    when 901..1000
      @current_image = @thirst_hud[4]
    end
  end

  def image_tiles(img)
    image = "data/img/#{img}.png"
    if File.exists?(image) then
      return Image.load_tiles(@window, image, 10, 42, false)
    else
      raise "File not found: #{image}"
    end
  end

  def draw
    @current_image.draw(15, 15, ZOrder::HUD)
  end

  def update
    current_image
  end

  def visibility
    return 1500
  end


end

