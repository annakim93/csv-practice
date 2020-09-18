require 'csv'
require 'awesome_print'

REQUIRED_OLYMPIAN_FIELDS = %w[ID Name Height Team Year City Sport Event Medal]

def get_all_olympic_athletes(filename)

  # # Option 1:
  # olympic_athletes = CSV.read(filename, headers: true).map { |row| row.to_h }
  # olympic_athletes.each do |athlete|
  #   athlete.each do |field, value|
  #     unless REQUIRED_OLYMPIAN_FIELDS.include?(field)
  #       athlete.delete(field)
  #     end
  #   end
  # end

  # Option 2
  olympic_athletes = CSV.read(filename, headers: true)

  olympic_athletes.by_col!.delete_if do |col_name, col_values|
    !REQUIRED_OLYMPIAN_FIELDS.include?(col_name)
  end.by_row!

  olympic_athletes = olympic_athletes.map { |row| row.to_h }

  return olympic_athletes
end



def total_medals_per_team(olympic_data)
  teams_with_medals = olympic_data.map { |athlete| athlete['Team'] if athlete['Medal'] != 'NA' }.compact

  medal_counts = {}

  teams_with_medals.uniq do |team|
    medal_counts[team] = teams_with_medals.count(team)
  end

  return medal_counts
end



def get_all_gold_medalists(olympic_data)
  gold_medalists = olympic_data.select { |athlete| athlete['Medal'] == 'Gold' }
  return gold_medalists
end

# data = get_all_olympic_athletes('data/athlete_events.csv')
# p total_medals_per_team(data)