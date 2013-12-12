# encoding: UTF-8
require 'sequel'
require 'dotenv'
require 'geoip'
require 'ruby-progressbar'

Dotenv.load

DB = Sequel.connect(ENV['DATABASE_URL'])

users = DB[:items]#.limit(1)
gp = GeoIP.new('GeoLiteCity.dat')

pbar = ProgressBar.create(:total => users.count)

users.each do |user|
  loc = gp.city(user[:ip])
  users.where('id = ?', user[:id]).update(
    :lat => loc[:latitude],
    :long => loc[:longitude],
    :country_code => loc[:country_code2].encode('UTF-8'),
    :region_name => loc[:region_name].encode('UTF-8'),
    :city_name => loc[:city_name].encode('UTF-8'))
  pbar.increment
end
