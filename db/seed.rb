require 'CSV'
require 'sqlite3'
require 'pry'
# require 'bundler/setup'
# Bundler.require

system 'rm daily_show_guests.db'
db = SQLite3::Database.new('daily_show_guests.db')

db.execute_batch("
CREATE TABLE guests
(
  id INTEGER PRIMARY KEY,
  year INTEGER,
  occupation TEXT,
  show TEXT,
  category TEXT,
  guest TEXT
);
")


# The method below successfully parses and injects code into the database.
CSV.foreach("../daily_show_guests.csv") do |row|
  year = row[0]
  occupation = row[1]
  show = row[2]
  category = row[3]
  guest = row[4]
  sql = "INSERT INTO guests (year, occupation, show, category, guest) VALUES (?, ?, ?, ?, ?)"
  db.execute_batch(sql, [year, occupation, show, category, guest])
end

def most_common_guest
  "
  SELECT guest, COUNT(*) AS appearances
  FROM guests
  GROUP BY guest
  ORDER BY appearances DESC
  LIMIT 1;
  "
end

def most_common_profession_by_year
  "
  SELECT year, occupation, COUNT(*) AS guests
  FROM guests
  GROUP BY year
  HAVING guests > 1
  ORDER BY year ASC;
  "
end

def most_common_profession
  "
  SELECT occupation, COUNT(*) AS guests
  FROM guests
  GROUP BY occupation
  ORDER BY occupation DESC
  LIMIT 1;
  "
end

def patrick_stewart_appearances
  "
  SELECT show, guest
  FROM guests
  WHERE guest = "Patrick Stewart";
  "
end

def busiest_year
  "
  SELECT year, COUNT(*) AS appearances
  FROM guests
  GROUP BY year
  HAVING appearances > 1;
  "
end

def most_popular_category_by_year
  "
  SELECT year, category, COUNT(*) AS occurrences
  FROM guests
  GROUP BY year
  HAVING occurrences > 1;
  "
end