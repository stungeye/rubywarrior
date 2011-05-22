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

    all_enemies, all_captives = listen_and_identify
    enemies, captives, empties = feel_and_identify

puts "Empties:"
puts empties

    if should_retreat?(enemies)
      walk! retreat_direction
    elsif enemies.count > 1
      bind! direction_of(enemies.first)
    elsif enemies.count > 0
      attack! direction_of(enemies.first)
    elsif should_rest?      
      rest!
    elsif captives.count > 0
      rescue! direction_of(captives.first)
    else 
      if all_captives.count > 0
        d = direction_of(all_captives.first)
      elsif all_enemies.count > 0
        d = direction_of(all_enemies.first)
      else
        d = direction_of_stairs
      end
      if feel(d).stairs? && (all_captives.count > 0 || all_enemies.count > 0)
        d = direction_of(empties.first)
      end
      walk! d
      @previous_steps << d
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

  def listen_and_identify
    identify(listen)
  end

  def feel_and_identify
    identify(
      DIRECTIONS.map do |d|
        feel(d)
      end
    )
  end

  def identify(spaces)
    enemies = []
    captives = []
    empties = []
    spaces.each do |space|
      enemies << space  if space.enemy?
      captives << space if space.captive?
      empties << space  if space.empty? && !space.stairs?
    end
    [enemies, captives, empties]
  end

  def method_missing(m, *args)
    @warrior.send(m, *args)
  end
  
end

