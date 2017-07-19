module BB_knowledge
  OUT = -1
end

class Player
  include BB_knowledge
  def initialize(playerInfo)
    @attack = playerInfo[:attack]
    @defense = playerInfo[:defense]
    @hit_meter = 0
  end
  # return OUT or 0~3 (hit)
  def swing(defense)
    @hit_meter += @attack
    if @hit_meter >= defense then
      over = @hit_meter - defense
      @hit_meter = over
      return over % 4
    else
      return OUT
    end
  end
  attr_accessor :attack, :defense, :hit_meter
end

class Team
  def initialize(teamInfo)
    @players = [nil]
    @teamDef = 0
    @batter = 1
    for i in 1..9 do
      @players[i] = Player.new(teamInfo[i])
      @teamDef += @players[i].defense
    end
  end

  def nextBatter
    @batter += 1
    @batter = 1 if @batter > 9
  end

  def getCurrentBatter
    return @players[@batter]
  end
  attr_reader :teamDef
end


def goRunner(hit_num, base_state)
  add_score = 0
  base_result = [false,false,false]
  for i in -1..2 do
    if i==-1 || base_state[i] then
      next_base = i + (hit_num + 1)
      if next_base > 2 then
        add_score += 1
      else
        base_result[next_base] = true
      end
    end
  end
  return [add_score, base_result]
end

def doIning(atkTeam,defTeam)
  base = [false,false,false]
  score = 0
  out = 0
    while out<3 do
      result = atkTeam.getCurrentBatter.swing(defTeam.teamDef)
      if result == BB_knowledge::OUT then
        out += 1
      else
        add_score, base = goRunner(result,base)
        score += add_score
      end
      atkTeam.nextBatter
    end
  return score
end

############################# main

require "./player.rb"

teamA = Team.new(PlayerInfoA)
teamB = Team.new(PlayerInfoB)
scoreA = 0
scoreB = 0

puts "****************************************"
puts "プレイボール!"
puts "****************************************"

for ining in 1..5 do
  puts "------"
  puts "#{ining}回 表"
  puts "------"
  scoreA += doIning(teamA,teamB)
  puts "#{scoreA} - #{scoreB}"
  puts ""
  sleep(1)

  puts "------"
  puts "#{ining}回 裏"
  puts "------"
  scoreB += doIning(teamB,teamA)
  puts "#{scoreA} - #{scoreB}"
  puts ""
  sleep(1)
end

puts "****************************************"
puts "ゲームセット!"
puts "****************************************"
puts (scoreA>scoreB)? "チームA勝利！！" :
     (scoreB>scoreA)? "チームB勝利！！" :
                      "同点でした"
