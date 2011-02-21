class Block

  def initialize(window, x=nil, y=nil)
    @window, @x, @y = window, x, y
  end

  def draw(w1, w2, h1, h2) # 100, 150, 50, 35
    @block = @window.draw_quad(
     @x + w1, @y - h1, COLORS::COLOR[:black],
     @x + w1, @y - h2, COLORS::COLOR[:black],
     @x + w2, @y - h1, COLORS::COLOR[:black],
     @x + w2, @y - h2, COLORS::COLOR[:black], ZOrder::BG)
  end

end

