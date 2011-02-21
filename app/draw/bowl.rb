class Bowl
  attr_accessor :level, :current_image
  attr_reader :position, :x, :y

  def initialize(window, x, y, img)
    @window, @x, @y = window, x, y
    @empty, @full = image_tiles(img)
    @level = 100
    current_image
  end

   def current_image
     if self.level > 0 then
       self.current_image = @full
     else
       self.current_image = @empty
     end

   end

  def image_tiles(img)
    image = "data/img/#{img}.png"
    if File.exists?(image) then
      empty, full = *Image.load_tiles(@window, image, 30, 12, false)
      return empty, full
    else
      raise "File not found: #{image}"
    end
  end

  def fill
    self.level = 100
  end

  def empty_by(amount)
    self.level -= amount
    self.level = (self.level < 0) ? 0 : self.level
  end

  def draw
    self.current_image.draw(self.x, self.y - self.current_image.height + 1,
      ZOrder::BG, 1.0, 1.0)
  end

  def update
    current_image
  end

end
