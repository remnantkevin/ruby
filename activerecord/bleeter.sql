-- sqlite3 bleeter.db < bleeter.sql

CREATE TABLE IF NOT EXISTS users (
 user_id integer PRIMARY KEY,
 first_name text NOT NULL,
 last_name text NOT NULL,
 email text NOT NULL UNIQUE,
 username text NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS bleets (
 bleet_id integer PRIMARY KEY,
 user_id integer NOT NULL,
 message text NOT NULL,
 bleeted_at text NOT NULL,
 FOREIGN KEY (user_id) REFERENCES users (user_id)
);

-- CREATE TABLE IF NOT EXISTS bleets (
--  bleet_id integer PRIMARY KEY,
--  user_id integer NOT NULL,
--  message text NOT NULL,
--  bleeted_at text DEFAULT (DATETIME('now')),
--  FOREIGN KEY (user_id) REFERENCES users (user_id)
-- );

-- CREATE TABLE IF NOT EXISTS tbl (d1 text, d2 text DEFAULT (DATETIME('now')));
-- insert into tbl (d1) values ("hello");
-- select * from tbl;
