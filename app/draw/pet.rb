class Pet < Actor
  attr_accessor :thirst
  attr_reader :beep

  def initialize(window, x, y, img)
    super
    @thirst = 1000
    @meow = Sample.new(window, "data/sounds/meow.wav")
  end

  def thirsty?
    @thirst > 0
  end

  def drink
    if @map.waterbowl.level > 0 then
      @current_image = @drink
      @map.waterbowl.empty_by(1)
      @thirst -= 1
    end
  end


end

