class Player
  def play_turn(warrior)
    direction = best_direction(warrior)
    space = warrior.feel(direction)
    spaces = warrior.look(direction)

    if should_pivot?(spaces)
      warrior.pivot!
    elsif should_range_attack?(spaces)
      warrior.shoot!
    elsif space.captive?
      warrior.rescue!(direction)
    elsif space.enemy?
      warrior.attack!(direction)
    elsif should_rest?(warrior, @health)      
      warrior.rest!
    else
      warrior.walk!(direction)
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

  def should_pivot?(spaces)
    spaces[0].wall?
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
