require 'sequel'
require 'dotenv'
require 'json'
require 'ruby-progressbar'

Dotenv.load

DB = Sequel.connect(ENV['DATABASE_URL'])

data = DB["select count(*) as count, cast(lat as integer), cast(long as integer)  from items group by lat, long order by count desc"]

pbar = ProgressBar.create(:total => data.count)
results = []

max = 0
data.each do |row|
  if row[:count] < 2000
    if row[:count] > 500
      count = row[:count] / 2
    else
      count = row[:count]
    end
    max = count if count > max
  end
end

max= max * 1.0

data.each do |row|
  if row[:count]< 2000
    if row[:count] > 500
      count = row[:count] / 2
    else
      count = row[:count]
    end
    results << row[:lat]
    results << row[:long]
    results << count / max
    pbar.increment
  end
end

raise results.inspect
