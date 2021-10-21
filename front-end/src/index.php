<html>
<head>
<link rel="stylesheet" href="main.css">
<script src="https://unpkg.com/vue@3.2.12/dist/vue.global.js"></script> <!-- -->
<!-- <script src="https://unpkg.com/vue@next"></script>  <!-- -->
<script src="https://unpkg.com/axios/dist/axios.min.js"></script> <!-- -->
<script src="chart.min.js"></script>
<title>NHL Players stats</title>
</head>
<body>
<table>
<tr><td>
<img align=center src='nhl.png' height='100px'>
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
	<option>United States</option>
	<option>Canada</option>
	</select><br><br>
	<input type='radio' name='limit' value='3' v-model='limit' @change='get_players()'>3&nbsp&nbsp&nbsp
	<input type='radio' name='limit' value='5' v-model='limit' @change='get_players()'>5&nbsp&nbsp&nbsp
	<input type='radio' name='limit' value='10' checked  v-model='limit' @change='get_players()'>10<br>
	<br>
	Total days: {{ ndays }}<br>
	<input v-model="day_start" size='3'> - <input v-model="day_end" size='3'><br><br>
	Loaded {{loaded_days}} days of {{ ( day_end - day_start ) }}<br><br>
	<div id="myProgress">
		<div id="myBar"></div>
	</div><br>
	<button @click='load_data'>Load data</button>
</div>
</td><td width='60%'>
<div width="70vw" height="70vh" style="width:70vw;height:70vh;background:#F0F0F0">
<canvas id="myChart"></canvas></div>
</td></tr></table>
<a href='/api/?action=delete_players'>Delete stat</a><br>
<a href='/api/?action=initdb'>Initdb database</a><br>
<a href='/api/?action=dropdb'>Drop database</a><br>
<br><div><?php echo "Host: " . gethostname(); ?></div>
</body>
</html>
<script src="main.js"></script>
