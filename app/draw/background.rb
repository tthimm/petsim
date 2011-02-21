class Background
  
  def initialize(window, args)
    @window = window
    @color = color(args[:color]) if args.has_key?(:color)
    @image = image(args[:image]) if args.has_key?(:image)
  end

  def color(col)
    if COLORS::COLOR.has_key?(col)
      color = Color.new(COLORS::COLOR[col])
      return color
    else
      raise "'#{col}' not available in COLORS::COLOR"
    end
  end

  def image(img)
    image = "data/img/#{img}.png"
    if File.exists?(image) then
      image = Image.new(@window, "data/img/#{img}.png", false)
      return image
    else
      raise "File not found: #{image}"
    end
  end

  def draw
    if @color then
      @window.draw_quad(0, 0, @color,
       @window.width, 0, @color,
       0, @window.height, @color,
       @window.width, @window.height, @color, 0)
    end
    if @image then
      @image.draw(0, 0, ZOrder::BG)
    end
  end


end

