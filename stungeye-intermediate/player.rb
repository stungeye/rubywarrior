class Player
  def play_turn(warrior)
    direction_sought = warrior.direction_of_stairs
    space = warrior.feel direction_sought
    if space.enemy?
      warrior.attack! direction_sought
    else
      warrior.walk! warrior.direction_of_stairs
    end
  end
end
