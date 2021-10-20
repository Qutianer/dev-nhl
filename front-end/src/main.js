/* *
data = [
{'fullname':'abcccc aaaaa0', 'goals': 45},
{'fullname':'abcccc aaaaa1', 'goals': 43},
{'fullname':'abcccc aaaaa2', 'goals': 40},
{'fullname':'abcccc aaaaa3', 'goals': 35},
{'fullname':'abcccc aaaaa4', 'goals': 30},
]
/* */

function update_chart(chart,datas) {
	var labels = []
	var xdata = []
	datas.forEach( (data) => {
		labels.push(data.fullname)
		xdata.push(data.goals)
	})
	chart.data.labels = labels
	chart.data.datasets[0].data = xdata
	chart.update()
}




var ctx = document.getElementById('myChart').getContext('2d');
var main_chart = new Chart(ctx, {
    type: 'bar',
    data: {
    	datasets: [{
		label: 'goals',
		data: [ 30, 20, 10, 10 ],
		backgroundColor: 'rgba(0,0,255,0.5)',
	}],
    	labels: [ 'one','two','three','four']
	},
	options:{
		scales: {
			yAxes: [{
				id: 'left-axis',
				type: 'linear',
				position: 'left',
				beginAtZero: 'true',
			}]
		},
		plugins: {
			legend: {
				display: false,
//				position: 'bottom',
			}
		},
		maintainAspectRatio:false
//		responsive:false
		}
	});

//update_chart(main_chart,data)

const stats = {
  data() {
    return {
	  countries: [],
	  country: 'all',
	  playcountry: 'all',
	  players: [],
	  ndays: 0,
	  day_start: 0,
	  day_end: 1,
	  loaded_days: 0,
	  limit: 10,
    }
  }, /* */
  watch: {
    players(val,oldval){
      update_chart(main_chart,this.players)
    }
  }, /* */
  methods: {
	get_players() {
		var self = this;
		var request = '';
		if(self.country != 'all')request += '&country=' + self.country
		if(self.playcountry != 'all')request += '&playcountry=' + self.playcountry
		if(self.limit != '10')request += '&limit=' + self.limit
		axios.get('/api/?action=get' + request)
		.then(function (response){self.players = response.data})
		.catch(function (error) {console.log(error);});
	},
	load_data() {
		var self = this;
		axios.get('/api/?action=get_lastseasonstat').then(function (response){self.ndays = response.data.days})
		this.loaded_days = 0
		const step = 1
		var start = parseInt(this.day_start)
		var end = parseInt(this.day_end)
		var prom = []
		for(var i = start;i <= end; i += step){
		    prom.push(
			axios.get('/api/?action=load&from=' + i + "&to=" + (i + step - 1))
			.then(function(){
				++self.loaded_days
				var elem = document.getElementById("myBar");
				var progress = parseInt(self.loaded_days * 100 / (end - start + 1))
				elem.style.width = elem.innerHTML = progress + "%"
			}))
		}
		Promise.all(prom).then(function(result){
			self.get_players()
			self.get_countries()
			update_chart(main_chart,self.players)
		})
	},
	get_countries() {
		var self = this;
		axios.get('/api/?action=get_countries')
		.then(function (response) {self.countries = response.data;})
		.catch(function (error) {console.log(error);});
	}
  },
  mounted() {
	this.get_players()
	this.get_countries()
	var self = this;
	axios.get('/api/?action=get_lastseasonstat').then(function (response){self.ndays = response.data.days})
  }
//  updated: function() {update_chart(main_chart,this.players)}
}

Vue.createApp(stats).mount('#stats')
