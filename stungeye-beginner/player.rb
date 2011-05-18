class Player
  def play_turn(warrior)
    if should_retreat?(warrior, @health)
      @direction = :backward 
    end
    space = warrior.feel(direction)
    if space.wall?
      toggle_direction!
      space = warrior.feel(direction)
    end
    if space.captive?
      warrior.rescue!(direction)
    elsif space.enemy?
      warrior.attack!(direction)
    elsif should_rest?(warrior, @health)      
      warrior.rest!
    else
      warrior.walk!(direction)
    end
    @health = warrior.health
  end

  def direction
    @direction ||= :backward
  end

  def toggle_direction!
    if @direction == :forward
      @direction = :backward
    else
      @direction = :forward
    end
  end

  def should_rest?(warrior, past_health)
    warrior.health < 19 && warrior.health >= past_health
  end

  def should_retreat?(warrior, past_health)
    warrior.health < 9 && warrior.health < past_health
  end
end
