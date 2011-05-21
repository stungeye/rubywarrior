class Player
  DIRECTIONS = [:forward, :right, :backward, :left]
  REVERSE_DIRECTION = { :forward  => :backward,
                        :backward => :forward,
                        :left     => :right,
                        :right    => :left }

  def initialize 
    @previous_steps = []
    @memory = {}
    @health = 20
  end


  def play_turn(warrior)
    @warrior = warrior
    spaces, enemies, captives = close_by(warrior)

    if should_retreat?(enemies)
      walk! retreat_direction
    elsif enemies.count > 1
      bind! enemies.first
    elsif enemies.count > 0
      attack! enemies.first
    elsif should_rest?      
      rest!
    elsif captives.count > 0
      rescue! captives.first
    else 
      walk! direction_of_stairs
      @previous_steps << direction_of_stairs
    end

    remember_health
  end

  def retreat_direction
    REVERSE_DIRECTION[@previous_steps.pop]
  end

  def remember_health
    @health = health
  end

  def should_rest?
    health < 19 && health >= @health
  end

  def should_retreat?(enemies)
    health < 10 && health < @health && enemies.count > 0
  end

  def close_by(warrior)
    spaces = {}
    enemies = []
    captives = []
    DIRECTIONS.map do |d|
      spaces[d] = warrior.feel(d)
      enemies << d  if spaces[d].enemy?
      captives << d  if spaces[d].captive?
    end
    [spaces, enemies, captives]
  end

  def method_missing(m, *args)
    @warrior.send(m, *args)
  end
  
end

