<html>
<head>
<link rel="stylesheet" href="main.css">
<script src="https://unpkg.com/vue@3.2.12/dist/vue.global.js"></script> <!-- -->
<!-- <script src="https://unpkg.com/vue@next"></script> <!-- -->
<script src="https://unpkg.com/axios/dist/axios.min.js"></script> <!-- -->
<title>NHL Players stats</title>
</head>
<body>
<table>
</table>
<div id="stats">
	<table border="1" cellspacing='0'>
	<thead>
	<tr><td>Player</td><td>Goals</td></tr>
	</thead>
	<tr v-for="player in players"><td>{{player.fullname}}</td><td>{{player.goals}}</td></tr>
	</table><br>
	<select v-model='country' @change='get_players()'>
	<option>all</option>
	<option v-for="country in countries">{{country}}</option>
	</select>&nbsp&nbsp&nbsp
	<select v-model='playcountry' @change='get_players()'>
	<option>all</option>
	<option>United states</option>
	<option>Canada</option>
	</select>&nbsp&nbsp&nbsp
	<input type='radio' name='limit' value='3'>3&nbsp&nbsp&nbsp
	<input type='radio' name='limit' value='5' checked>5&nbsp&nbsp&nbsp
	<input type='radio' name='limit' value='10'>10<br>
	<br>
	<input v-model="day_start"> - <input v-model="day_end"><br><br>
	Loaded {{loaded_days}} of {{ndays}}<br><br>
	<div id="myProgress">
		<div id="myBar"></div>
	</div><br>
	<button @click='load_data'>Load data</button>
</div>
<br>
<a href='/api/?action=delete_players'>Delete stat</a><br>
<a href='/api/?action=initdb'>Initdb database</a><br>
<a href='/api/?action=dropdb'>Drop database</a><br>
<div><?php echo gethostname() ?></div>
</body>
</html>
<script src="main.js"></script>
