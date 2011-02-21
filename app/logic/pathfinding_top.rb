module Pathfinding
  def find_path_for(actor, dest)
    requires_jumping = false
    path_clear = false
    start = [actor.x, actor.y - actor.current_image.height]
    destination = [dest.x, dest.y - 50]
    if start[1] == destination[1] then
      blocked_at = []
      (actor.x...dest.x).each do |px|
        if px % 50 == 0 then # only starting point off block needed
          if @map.solid?(px, actor.y) then # horizontal movement blocked
            requires_jumping = true
            if @map.solid?(px, @y - 50) then # block on top
              if @map.solid?(px, @y - 100) then # another block on top
                path_clear = false
              end
            end
            blocked_at << px + 1
          end
        else
          path_clear = true
        end
      end
    end
    return path_clear, blocked_at, requires_jumping
  end
end