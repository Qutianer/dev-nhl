CREATE DATABASE nhl;
USE nhl;
CREATE TABLE players (id INT PRIMARY KEY AUTO_INCREMENT, player_id INT UNIQUE KEY, fullname VARCHAR(300), birthCountry VARCHAR(10));
CREATE TABLE goals (id INT PRIMARY KEY AUTO_INCREMENT, game_id INT, player_id INT, goals INT, venue VARCHAR(200),
	CONSTRAINT game_player_uk  UNIQUE (game_id,player_id)
	);
CREATE TABLE venues (id INT PRIMARY KEY AUTO_INCREMENT, venue_id INT, city VARCHAR(200), name VARCHAR(200), country VARCHAR(50));
