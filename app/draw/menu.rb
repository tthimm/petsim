class Menu
  attr_accessor :start_selected, :exit_selected

  def initialize(window)
    @window = window
    @menu = menu_items
    @start_selected = true
    @exit_selected = false
    @select = Sample.new(@window, "data/sounds/select.ogg")
  end

  def draw
    @menu.each do |item|
      item.draw_selected_unselected
    end
  end

  def highlight_start
    @menu.first.selected = true
    @menu.last.selected = false
  end

  def highlight_exit
    @menu.first.selected = false
    @menu.last.selected = true
  end

  def menu_items
    items = []
    y = @window.height / 3
    ["Start", "Exit"].each do |text|
      obj = Text.new(@window, text, 50, y)
      items << obj
      y += 50 
    end
    return items
  end

  def button_down(id)
    case id
    when KbUp
      @select.play
      @start_selected, @exit_selected = true, false
      highlight_start
    when KbDown
      @select.play
      @start_selected, @exit_selected = false, true
      highlight_exit
    when KbEnter, KbReturn
      if @exit_selected then
          @window.close
      elsif @start_selected then
        close
      end
    when KbEscape
      close
    end
  end

  def close
    @window.menu_selected = false
  end

end

