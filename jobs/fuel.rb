$inverse_fuel = 10
$inverse_fuel_city = 6
# labels = (1..150).to_a.map {|n| (n / 60).round()}
labels = [""]*200
labels[0] = 0
labels[50] = 1
labels[100] = 2
labels[150] = 3

SCHEDULER.every '30s' do
  delta = ($inverse_fuel + rand(1..10))
  $inverse_fuel = (delta + $inverse_fuel) % 100
  $inverse_fuel_city = (delta*0.6 + $inverse_fuel_city) % 100
  fuel = 100 - $inverse_fuel
  fuel_city = 100 - $inverse_fuel_city
  fuel_highway = 100 - $inverse_fuel + $inverse_fuel_city

  # send_event('valuation', { current: current_valuation, last: last_valuation })
  # send_event('karma', { current: current_karma, last: last_karma })
  # send_event('fuel',   { value: fuel })
  data = [
    {
      label: 'Energy per mile (City) (kwh/mi)',
      # data: [city_hundred_mile_average] * 200,
      data: $city_graph,
      backgroundColor: [ 'rgba(255, 99, 132, 0.2)' ] * labels.length,
      borderColor: [ 'rgba(255, 99, 132, 1)' ] * labels.length,
      borderWidth: 1,
    }, {
      label: 'Energy per mile (City) (kwh/mi)',
      # data: [highway_hundred_mile_average] * 200, 
      data: $highway_graph,
      backgroundColor: [ 'rgba(255, 206, 86, 0.2)' ] * labels.length,
      borderColor: [ 'rgba(255, 206, 86, 1)' ] * labels.length,
      borderWidth: 1,
    }
  ]
  send_event('driving_charts', { labels: labels, datasets: data })
  send_event('driving_charts2', { labels: labels, datasets: data })
end
