# Map class holds and draws tiles and gems.
class Map
  attr_reader :width, :height, :toys, :pet, :waterbowl, :file_name

  def initialize(window, map_file_name)
    @file_name = map_file_name
    @tileset = Image.load_tiles(window, "data/img/tileset.png", 50, 50, true)
    @toys = []
    @pet = []
    image = Image.new(window, "data/img/ball.png", false)
    lines = File.readlines("data/maps/" + @file_name).map { |line| line.chomp }
    @height = lines.size
    @width = lines[0].size
    @tiles = Array.new(@width) do |x|
      Array.new(@height) do |y|
        case lines[y][x, 1]
        when '='
          Tiles::Grass
        when '#'
          Tiles::Earth
        when 'T'
          Tiles::Grass_top
        when 'L'
          Tiles::Grass_top_left
        when 'l'
          Tiles::Grass_bottom_left
        when 'R'
          Tiles::Grass_top_right
        when 'r'
          Tiles::Grass_bottom_right
        when 'Q'
          Tiles::Grass_and_earth_left
        when 'W'
          Tiles::Grass_and_earth_right
        when 'B'
          Tiles::Block
        when 'x'
          @toys.push(Toy.new(image, x * 50 + 25, y * 50 + 25))
          nil
        when 'p'
          @pet.push(x * 50, y * 50)
          nil
        when 'Y'
          # y + 50 for placing on ground
          @waterbowl = Bowl.new(window, x * 50, y * 50 + 50, :bowl)
          nil
        else
          nil
        end
      end
    end
    raise "Error: no pet placed in map!" if @pet.empty?
  end

  def draw
    # Very primitive drawing function:
    # Draws all the tiles, some off-screen, some on-screen.
    @height.times do |y|
      @width.times do |x|
        tile = @tiles[x][y]
        if tile then
          # Draw the tile
          # Scrolling is implemented here just as in the game objects.
          @tileset[tile].draw(x * 50, y * 50, 0)
        end
      end
    end
    @toys.each { |toy| toy.draw }
    @waterbowl.draw
  end

  # Solid at a given pixel position?
  def solid?(x, y)
    y < 0 || x < 0 || y >= @height * 50 || x >= @width * 50 ||
      @tiles[x / 50][y / 50]
  end


end

