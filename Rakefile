require 'sqlite3'

task :db_setup do
  db = SQLite3::Database.new "booking.db"
  drop_script = %{
    DROP TABLE IF EXISTS bookings
  }
  db.execute drop_script
  db_script = %{
    CREATE TABLE IF NOT EXISTS bookings(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      reason TEXT,
      slot_start_time DATETIME,
      slot_end_time DATETIME
    )
  }
  db.execute db_script
end