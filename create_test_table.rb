require 'sequel'
require 'dotenv'
Dotenv.load

DB = Sequel.connect(ENV['DATABASE_URL'])

DB.create_table :items do
  primary_key :id
  String :ip
  String :action
  DateTime :created_at
  String :rank
  Float :lat
  Float :long
end
