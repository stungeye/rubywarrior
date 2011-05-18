class Player
  def play_turn(warrior)
    felt = warrior.feel
    if felt.captive?
      warrior.rescue!
    elsif felt.enemy?
      warrior.attack!
    elsif should_rest?(warrior, @health)      
      warrior.rest!
    else
      warrior.walk!
    end
    @health = warrior.health
  end


  def should_rest?(warrior, past_health)
    warrior.health < 19 && warrior.health >= past_health
  end
end
