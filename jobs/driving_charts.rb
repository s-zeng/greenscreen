labels = (1..150).to_a.map {|n| n / 60}

$city_data = 200.times.map{Random.rand(16.0 .. 30.0 )}
city_hundred_mile_average = $city_data[100..].reduce(:+) / 100.0
$highway_data = 200.times.map{Random.rand(20.0 .. 37.0)}
highway_hundred_mile_average = $highway_data[100..].reduce(:+) / 100.0

$gas_constant = (100.0 / 24.7) * 120000000

SCHEDULER.every '3s', :first_in => 0 do |job|
  old_city_average = city_hundred_mile_average
  old_highway_average = highway_hundred_mile_average
  $city_data = $city_data[1..] << Random.rand(16.0 .. 30.0 )
  $highway_data = $highway_data[1..] << Random.rand(20.0 .. 37.0)
  city_hundred_mile_average = $city_data[100..].reduce(:+) / 100.0
  highway_hundred_mile_average = $highway_data[100..].reduce(:+) / 100.0

  $EV_Variable = 3600000*(city_hundred_mile_average)
  $gas_factor = (1 - $EV_Variable / $gas_constant)
  $gas_car_index = $gas_constant*(0.17+0.21)/2.0
  $ev_index = $EV_Variable*(0.59+0.62)/2.0

  $greenscreen_effect = $gas_car_index / $ev_index

  $city_graph = $city_data.inject([0]) {|acc, n| acc << (n + acc[-1])} [1..].reverse
  $city_graph = $city_graph.map {|n| n * 42 / $city_graph[0]}
  $highway_graph = $highway_data.inject([0]) {|acc, n| acc << (n + acc[-1])} [1..].reverse
  $highway_graph = $highway_graph.map {|n| 5 + n * 37 / $highway_graph[0]} 

  # city_graph = ([city_hundred_mile_average] * 200).map {|n| n + Random.rand(-0.5 .. 0.5)}
  # highway_graph = ([highway_hundred_mile_average] * 200).map {|n| n + Random.rand(-0.5 .. 0.5)}

  # data = [
  #   {
  #     label: 'Energy per mile (City) (kwh/mi)',
  #     # data: [city_hundred_mile_average] * 200,
  #     data: city_graph,
  #     backgroundColor: [ 'rgba(255, 99, 132, 0.2)' ] * labels.length,
  #     borderColor: [ 'rgba(255, 99, 132, 1)' ] * labels.length,
  #     borderWidth: 1,
  #   }, {
  #     label: 'Energy per mile (City) (kwh/mi)',
  #     # data: [highway_hundred_mile_average] * 200, 
  #     data: highway_graph,
  #     backgroundColor: [ 'rgba(255, 206, 86, 0.2)' ] * labels.length,
  #     borderColor: [ 'rgba(255, 206, 86, 1)' ] * labels.length,
  #     borderWidth: 1,
  #   }
  # ]

  fuel = 100 - $inverse_fuel
  send_event('fuel',   { value: fuel })

  # send_event('driving_charts', { labels: labels, datasets: data })
  send_event('city', { current: city_hundred_mile_average.round(2), last: old_city_average.round(2) })
  send_event('highway', { current: highway_hundred_mile_average.round(2), last: old_highway_average.round(2) })

  send_event('factor', { value: ($gas_factor*100 + rand(-5..5)).round()})
  send_event('green', { current: ($greenscreen_effect + rand(-0.1 .. 0.1)).round(2)})

end
