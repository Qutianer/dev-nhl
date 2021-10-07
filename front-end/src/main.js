
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
    }
  },
  methods: {
	get_players() {
		var self = this;
		var request = '';
		if(self.country != 'all')request += '&country=' + self.country
		if(self.playcountry != 'all')request += '&playcountry=' + self.playcountry
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
		})
	},
	get_countries() {
		var self = this;
		axios.get('/api/?action=get_countries')
		.then(function (response) {self.countries = response.data;})
		.catch(function (error) {console.log(error);});
	}
  },
	computed: {
	},
  mounted() {
	this.get_players()
	this.get_countries()
  }
}

Vue.createApp(stats).mount('#stats')
