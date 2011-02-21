class Text
  attr_reader :x, :y, :z
  attr_accessor :selected, :msg

  def initialize(window, msg, point_size=20, y=nil, x=nil,
     ttf_file='vollkorn-regular')
    @window = window
    @font = font(ttf_file, point_size)
    @msg = msg
    @y = y ? y : 10
    @x = x ? x : @window.width/2
    @z = ZOrder::HUD
  end

  def font(fnt, size)
    font = "data/fonts/#{fnt}.ttf"
    if File.exists?(font) then
      text = Font.new(@window, font, size)
      return text
    else
      raise "File not found: #{font}"
    end
  end

  def draw_selected_unselected
    @font.draw_rel(@msg, x, y, z, 0.5, 1.0, 1.0, 1.0, (selected ?
     COLORS::COLOR[:white] : COLORS::COLOR[:black]))
  end

  def draw(color)
    @font.draw_rel(@msg, x, y, z, 0.5, 1.0, 1.0, 1.0, COLORS::COLOR[color])
  end

end

