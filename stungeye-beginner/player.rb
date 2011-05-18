class Player
  def play_turn(warrior)
    direction = best_direction(warrior)
    space = warrior.feel(direction)
    if direction == :forward
      spaces = warrior.look(:forward)
      backspaces = warrior.look(:backward)
    else
      spaces = warrior.look(:backward)
      backspaces = warrior.look(:forward)
    end

    
    if should_pivot?(spaces, backspaces)
      warrior.pivot!
      @pivoted = true
      @engaged = false
    else
      @pivoted = false
      @engaged = false
      if should_range_attack?(spaces)
        warrior.shoot!
        @engaged = true
      elsif space.captive?
        warrior.rescue!(direction)
      elsif space.enemy?
        warrior.attack!(direction)
        @engaged = true
      elsif should_rest?(warrior, @health)      
        warrior.rest!
      else
        warrior.walk!(direction)
      end
    end

    remember_health(warrior)

  end

  def remember_health(warrior)
    @health = warrior.health
  end

  def best_direction(warrior)
    if should_retreat?(warrior, @health)
      :backward
    else 
      :forward
    end
  end

  def should_pivot?(spaces, backspaces)
    spaces[0].wall? || (should_range_attack?(backspaces) && !@pivoted && !@engaged)
  end

  def should_range_attack?(spaces)
    spaces.each do |s|
      if s.captive?
        return false
      elsif s.enemy?
        return true
      end
    end
    false
  end

  def should_rest?(warrior, past_health)
    warrior.health < 19 && warrior.health >= past_health
  end

  def should_retreat?(warrior, past_health)
    warrior.health < 8 && warrior.health < past_health
  end
end
