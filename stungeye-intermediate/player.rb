class Player
  DIRECTIONS = [:forward, :right, :backward, :left]

  def play_turn(warrior)
    d = warrior.direction_of_stairs
    around = surroundings(warrior)
    if around[:enemies].count > 2
      warrior.bind! around[:enemies].first
    elsif around[:spaces][d].enemy?
      warrior.attack! d
    else
      warrior.walk! d
    end
  end

  def surroundings(warrior)
    spaces = {}
    enemies = []
    DIRECTIONS.map do |d|
      spaces[d] = warrior.feel(d)
      enemies << d  if spaces[d].enemy?
    end
    { 
      :spaces => spaces,
      :enemies => enemies 
    }
  end
  
end

