<?php
header('Content-Type: application/json; charset=utf-8');
$db_server = 'db';
$db_name = 'nhl';
$db_user = 'root';
$db_pass = '';

include "config/config.php";

$db_init = "
CREATE DATABASE $db_name;
USE $db_name;
CREATE TABLE players (id INT PRIMARY KEY AUTO_INCREMENT, player_id INT UNIQUE KEY, fullname VARCHAR(300), birthCountry VARCHAR(10));
CREATE TABLE goals (id INT PRIMARY KEY AUTO_INCREMENT, game_id INT, player_id INT, goals INT, venue VARCHAR(200),
	CONSTRAINT game_player_uk  UNIQUE (game_id,player_id)
	);
CREATE TABLE venues (id INT PRIMARY KEY AUTO_INCREMENT, venue_id INT, city VARCHAR(200), name VARCHAR(200), country VARCHAR(50));
";



/*

players : id, player_id, fullname, birthCountry
goals: id, game_id, player_id, goals

select * from goals order by player_id;
SELECT player_id,SUM(goals) as total FROM goals GROUP BY player_id ORDER BY total DESC LIMIT 10;

SELECT fullname,SUM(goals) as goals FROM goals
JOIN players ON players.player_id = goals.player_id
GROUP BY goals.player_id ORDER BY goals DESC LIMIT 10;

CREATE TABLE cities (id INT PRIMARY KEY AUTO_INCREMENT, country VARCHAR(200), city VARCHAR(200));
SELECT COUNT(*) FROM cities;
DROP TABLE cities;

CREATE TABLE venues (id INT PRIMARY KEY AUTO_INCREMENT, venue_id INT, city VARCHAR(200), name VARCHAR(200));

SELECT ven.id, ven.venue_id, ven.city, ven.name, cit.country FROM venues as ven
LEFT JOIN cities as cit ON cit.city = ven.city;
*/


$db_deinit = "
DROP DATABASE $db_name;
DROP TABLE players;
DROP TABLE goals;
DROP TABLE venues;

";

//ini_set("allow_url_fopen", 1);
$api_base_url = "https://statsapi.web.nhl.com/api/v1";

/*
-> person -> id, fullname, birthCountry
-> stats -> goals
*/

function get_players_game_stats($players){
	$result = [];
	foreach($players as $key=>$player){
	  $goals = 0;
	  if(isset($player -> stats -> skaterStats))$goals = $player -> stats -> skaterStats -> goals;
	  if(isset($player -> stats -> goalieStats))$goals = $player -> stats -> goalieStats -> goals;
	  if( $goals != 0 ){
			$result[] = array(
				"id" => $player -> person -> id,
				"fullname" => $player -> person -> fullName,
				"birthCountry" => $player -> person -> birthCountry,
				"goals" => $goals
			);
		}
	}
	return $result;
}

if(isset ($_GET['action']) ) {
	switch ($_GET['action']) {
			case 'load':
					$db = new mysqli($db_server, $db_user, $db_pass, $db_name);
//					echo "Action: load<br>";

					$query = "SELECT venue_id,city,name,country FROM venues";
					$result = $db->query($query);
					$venues = $result->fetch_all(MYSQLI_ASSOC);

/* Load schedule games */
					$json = file_get_contents($api_base_url."/seasons");
					$seasons = json_decode($json);
					$last_season = $seasons->seasons[count($seasons->seasons)-2];

					$json = file_get_contents($api_base_url."/schedule?season=".$last_season->seasonId);
					$season_games = json_decode($json);
					$ngames = $season_games -> totalItems;
					
					if($ngames != $season_games -> totalGames)echo "Warning: games != items  <br>";

					$load_from = 0;
					$load_to = count($season_games -> dates) - 1;
					if(isset($_GET["from"]))$load_from = $_GET["from"];
					if(isset($_GET["to"]))$load_to = $_GET["to"];
					if($load_to > (count($season_games -> dates) - 1))$load_to = count($season_games -> dates) - 1;
					if($load_from > $load_to)$load_from = $load_to;
					for($i = $load_from; $i <= $load_to;++$i){
						$datekey = $i;
						$date = $season_games -> dates[$datekey];

					  if($date -> totalItems != $date -> totalGames)echo "Warning: date games != items  <br>";
						foreach($date -> games as $gamekey=>$game){
						  $gameid = $game -> gamePk;
							if(!isset($game -> venue))echo "Warning: venue is unset at $datekey - $gamekey <br>";
							else {
								if(!isset($game -> venue ->id) or $game -> venue -> id == 0){
//									echo "Warning: venue id is unset or zero $datekey - $gamekey<br>";
//									echo "<pre>".json_encode($game -> venue,JSON_PRETTY_PRINT)."</pre><br>";
								}
								else {
									$found = false;
									foreach($venues as $venue)
										if($venue["venue_id"] == $game -> venue -> id){$found = true; break;}
									if(!$found) {
									echo "Warning: Venue id not found $datekey - $gamekey <br>";
									echo "<pre>".json_encode($game -> venue,JSON_PRETTY_PRINT)."</pre><br>";
									}
								}
								if(!isset($game -> venue ->name)) {
									echo "Warning: venue name is unset $datekey - $gamekey<br>";
									echo "<pre>".json_encode($game -> venue,JSON_PRETTY_PRINT)."</pre><br>";
								}
								else {
									$found = false;
									foreach($venues as $venue)
										if($venue["name"] == $game -> venue -> name){$found = true; break;}
									if(!$found){
										echo "Warning: Venue name not found $datekey - $gamekey <br>";
										echo "<pre>".json_encode($game -> venue,JSON_PRETTY_PRINT)."</pre><br>";
									}
								}
							}
							
						$json = file_get_contents($api_base_url."/game/$gameid/boxscore");
						$gamestat = json_decode($json);
//						echo "<pre>".json_encode(get_players_game_stats($gamestat -> teams -> away -> players),JSON_PRETTY_PRINT)."</pre><br>";
//						echo "<pre>".json_encode(get_players_game_stats($gamestat -> teams -> home -> players),JSON_PRETTY_PRINT)."</pre><br>";
//						$query = "INSERT INTO players (player_id,fullname,birthCountry) VALUES ( ?, ?, ?)";
//						$stmt = mysqli->prepare($query);
						$teamstat = get_players_game_stats($gamestat -> teams -> away -> players);
						foreach($teamstat as $stat){
							$query = "INSERT IGNORE INTO players (player_id,fullname,birthCountry) VALUES ( {$stat["id"]}, \"{$stat["fullname"]}\", \"{$stat["birthCountry"]}\");";
//							echo $query."<br>";
							$db -> query($query);
							$query = "INSERT IGNORE INTO goals (game_id,player_id,goals,venue) VALUES ( {$gameid}, \"{$stat["id"]}\", \"{$stat["goals"]}\",\"{$game -> venue ->name}\");";
							$db -> query($query);
//							echo $query."<br>";
//							$stmt -> bind_param(
						}
						$teamstat = get_players_game_stats($gamestat -> teams -> home -> players);
						foreach($teamstat as $stat){
							$query = "INSERT IGNORE INTO players (player_id,fullname,birthCountry) VALUES ( {$stat["id"]}, \"{$stat["fullname"]}\", \"{$stat["birthCountry"]}\");";
							$db -> query($query);
							$query = "INSERT IGNORE INTO goals (game_id,player_id,goals,venue) VALUES ( {$gameid}, \"{$stat["id"]}\", \"{$stat["goals"]}\",\"{$game -> venue ->name}\");";
							$db -> query($query);
						}
						
//					echo "gamekey = $gamekey<br>";
//							echo "<pre>".json_encode($game,JSON_PRETTY_PRINT)."</pre><br>";
						}
//					echo "datekey = $datekey<br>";

if($datekey >= 2)break;
					}
//					echo "<pre>".print_r($season_games,true)."</pre><br>";

					
					echo '"OK"';
/**/					
					$db->close();
					break;

/*#################################### INIT DATABASE										####################################*/

			case 'initdb':
					echo '{';
					echo '"Action": "initdb",';
					$db = new mysqli($db_server, $db_user, $db_pass);
					$db->multi_query($db_init);
//					echo $db_init;
//					echo json_encode(array("query" => $db_init),JSON_PRETTY_PRINT) . ',';
					//$db->close();

/* Load venues data */
//					$db = new mysqli($db_server, $db_user, $db_pass, $db_name);
sleep(5);
					while($db->next_result());
					if( ($result = $db->query("use $db_name")) == false)echo "Error #" . $db->errno . ": " . $db->error . " at file " . __FILE__ . ":" . __LINE__;
					$json = file_get_contents("venues.json");
					$venues = json_decode($json,true);
//				echo "<pre>".print_r($venues,true)."</pre><br>";
					$query = "INSERT INTO $db_name.venues (venue_id,city,name,country) values ";
					foreach($venues as $venue){
						$query .= "(\"" . $venue["venue_id"] . "\",\"" . $venue["city"] . "\",\"" . $venue["name"] . "\",\"" . $venue["country"] . "\"),";
					}
					$query = rtrim($query,',');
					echo $query;
					$db->query($query);
/**/
					$db->close();
					echo '"Result": "OK"}';
					break;

/*#################################### GET PLAYERS STATS									####################################*/

			case 'get':
						$db = new mysqli($db_server, $db_user, $db_pass, $db_name);
						$query = "SELECT fullname,SUM(goals) as goals FROM goals
JOIN players ON players.player_id = goals.player_id";
						if(isset($_GET["country"]))$query .= " AND players.birthCountry = \"{$_GET["country"]}\"";
						if(isset($_GET["playcountry"]))$query .= " JOIN venues ON venues.name = goals.venue AND venues.country = '{$_GET["playcountry"]}'";
						$query .= " GROUP BY goals.player_id ORDER BY goals DESC LIMIT 10";
//						echo $query;
						$result = $db->query($query);
						echo json_encode($result->fetch_all(MYSQLI_ASSOC));
						$db->close();
					break;
			case 'get_countries':
						$db = new mysqli($db_server, $db_user, $db_pass, $db_name);
						$query = "SELECT birthCountry as country FROM players GROUP BY country ORDER BY country;";
						$result = $db->query($query);
						echo json_encode(array_column($result->fetch_all(MYSQLI_ASSOC),"country"));
						$db->close();
					break;

/*#################################### GET LAST SEASON								####################################*/

			case 'get_lastseason':
/* Get current season /
					$json = file_get_contents($api_base_url."/seasons/current");
					$current_season = json_decode($json);
					echo "<pre>".print_r($json,true)."</pre>";
/**/

/* Get last season */					
					$json = file_get_contents($api_base_url."/seasons");
					$seasons = json_decode($json);
					$last_season = $seasons->seasons[count($seasons->seasons)-2];
					echo json_encode($last_season);
					break;

/*#################################### GET LAST SEASON STATS						####################################*/

			case 'get_lastseasonstat':
					$json = file_get_contents($api_base_url."/seasons");
					$seasons = json_decode($json);
					$last_season = $seasons->seasons[count($seasons->seasons)-2];

					$json = file_get_contents($api_base_url."/schedule?season=".$last_season->seasonId);
					$season_games = json_decode($json);
					$result = array("days" => count($season_games -> dates));
					echo json_encode($result);
					break;
			case 'delete_players':
					$db = new mysqli($db_server, $db_user, $db_pass);
					$db->query("delete from players");
					$db->close();
					break;
			case 'dropdb':
					$db = new mysqli($db_server, $db_user, $db_pass);
					$db->query("drop database $db_name");
					$db->close();
					echo '"OK"';
					break;
	}
}
/*

*/

// Loading countries and cities
/*/
					$json = file_get_contents("cities.json");
					$countries = json_decode($json,true);
					foreach($countries as $country=>$cities){
						$query = "INSERT INTO cities (country,city) values ";
						foreach($cities as $city){
							$query .= "(\"$country\",\"$city\"),";
						}
						$query = rtrim($query,',');
						$db->query($query);
					}
/**/

// Loading teams
// get https://statsapi.web.nhl.com/api/v1/teams
// load teams[*].venue id,city
/*
					$json = file_get_contents($api_base_url."/teams");
					$teams = json_decode($json,true);
					$query = "INSERT INTO venues (venue_id,city,name) values ";
					foreach($teams["teams"] as $team){
						$query .= "(\"" . (isset($team["venue"]["id"])?$team["venue"]["id"]:0) . "\",\"" . $team["venue"]["city"] . "\",\"" . $team["venue"]["name"] . "\"),";
					}
					$query = rtrim($query,',');
//					echo $query;
//					$db->query($query);
//					echo "<pre>".print_r($teams["teams"])."</pre><br>";
/**/

/* Printout final venue-country data /

					$query = "SELECT ven.venue_id, ven.city, ven.name, cit.country FROM venues as ven LEFT JOIN cities as cit ON cit.city = ven.city where cit.country IN (\"Canada\",\"United states\") group by city order by city;";
					$result = $db->query($query);
					echo "<pre>".print_r(json_encode($result->fetch_all(MYSQLI_ASSOC)))."</pre><br>";
/**/



?>
