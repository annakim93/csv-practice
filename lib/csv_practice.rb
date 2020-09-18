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



def team_with_most_medals(total_medals)
  most_medals_array = total_medals.sort_by { |team, medal_count| -medal_count }[0]

  most_medals_hash = {'Team' => most_medals_array[0], 'Count' => most_medals_array[1]}

  return most_medals_hash
end


def athlete_height_in_inches(olympic_data)

  converted_height_data = olympic_data.map do |athlete|
    athlete['Height'] = athlete['Height'].to_f * 0.3937
    athlete
  end

  return converted_height_data
end


