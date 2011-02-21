module Actions
  include Pathfinding

  def drink_water
    if distance(@x, @y + @current_image.height, @map.waterbowl.x,
      @map.waterbowl.y + 50) < 10 then
      drink
    end
  end

  def move_to_waterbowl
    if @map.waterbowl.x > @x then
      @move = 2
      @path_clear, @blocked_at, @jumping_required = find_path_for(self, @map.waterbowl)
      if @path_clear && (@blocked_at.empty? || @jumping_required) then
        #TODO: pathfinding should find a path!
        if !would_fit(10, 0) then
          try_to_jump
        end
      #else
      #  @move = 0
      end
      #if !would_fit(1, 0) then
      #  dist = distance(@x, @y + @current_image.height, @map.waterbowl.x, @map.waterbowl.y + 50)
      #  1.times { try_to_jump }
        #if distance(@x, @y + @current_image.height, @map.waterbowl.x, @map.waterbowl.y + 50) == dist then
        #  @move = -2
        #end
      #end
    #elsif @map.waterbowl.x < @x then
    #  @move = -2
    #  if !would_fit(-1, 0) then
    #    try_to_jump
    #  end
    else
     # @move = 0
    end
  end

  def meow
    @meow.play
  end

end
