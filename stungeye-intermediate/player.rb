class Player
  DIRECTIONS = [:forward, :right, :backward, :left]
  REVERSE_DIRECTION = { :forward  => :backward,
                        :backward => :forward,
                        :left     => :right,
                        :right    => :left }
  STATES = [ :empathy, :rage, :adventure ]

  STATES.each do |s|
    define_method("#{s}?") { @state == s }
  end

  [:enemies, :captives, :ticking_captives, :empties].each do |s|
    define_method("close_#{s}")  { feel_and_identify[s] }
    define_method("close_#{s}?") { feel_and_identify[s].count > 0 }
    define_method("far_#{s}")    { listen_and_identify[s] }
    define_method("far_#{s}?")   { listen_and_identify[s].count > 0 }
  end

  def initialize 
    @previous_steps = []
    @health = 20
    @state = :empathy
  end

  def play_turn(warrior)
    @warrior = warrior

    if (far_ticking_captives? || far_captives?) 
      @state = :empathy
    else
      @state = :rage
    end

    case
    when empathy?
      if close_ticking_captives?
        rescue! direction_of(close_ticking_captives.first)
      elsif close_captives? 
        rescue! direction_of(close_captives.first)
      else
        if far_ticking_captives?
          d = direction_of(far_ticking_captives.first)
        elsif far_captives?
          d = direction_of(far_captives.first)
        end
        if (feel(d).stairs? || feel(d).enemy?) && (far_ticking_captives? || far_captives?)
          close_empties.each do |s|
            if direction_of(s) != REVERSE_DIRECTION[@previous_steps.last]
              d = direction_of(s)
              break
            end
          end
        end
        walk! d
        @previous_steps << d
      end
    when rage?
      if should_retreat?
        retreat!
      elsif close_enemies.count > 1
        bind! direction_of(close_enemies.first)
      elsif close_enemies?
        attack! direction_of(close_enemies.first)
      elsif should_rest?      
        rest!
      else 
        if far_enemies?
          d = direction_of(far_enemies.first)
        else
          d = direction_of_stairs
        end
        if feel(d).stairs? && far_enemies?
          d = direction_of(close_empties.first)
        end
        walk! d
        @previous_steps << d
      end
    end

    remember_health
  end

  def retreat!
    walk! REVERSE_DIRECTION[@previous_steps.pop]
  end

  def remember_health
    @health = health
  end

  def should_rest?
    health < 19 && health >= @health && far_enemies?
  end

  def should_retreat?
    health < 10 && health < @health && close_enemies?
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
    ticking_captives = []
    empties = []
    spaces.each do |space|
      enemies << space  if space.enemy?
      captives << space if space.captive? && !space.ticking?
      ticking_captives << space if space.captive? && space.ticking?
      empties << space  if space.empty? && !space.stairs?
    end
    { :enemies          => enemies, 
      :captives         => captives, 
      :ticking_captives => ticking_captives,
      :empties          => empties }
  end

  def method_missing(m, *args)
    @warrior.send(m, *args)
  end
  
end

