class Toy
  attr_reader :x, :y

  def initialize(image, x, y)
    @image = image
    @x, @y = x, y
  end

  def draw
    # Draw, slowly rotating
    @image.draw_rot(@x, @y, 0, 5 * Math.sin(milliseconds / 133.7))
  end

end
