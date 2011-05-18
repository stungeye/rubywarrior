class Player
  def play_turn(warrior)
    if warrior.feel.enemy?
      warrior.attack!
    elsif warrior.health < 19 && warrior.health >= @health
      warrior.rest!
    else
      warrior.walk!
    end
    @health = warrior.health
  end
end
