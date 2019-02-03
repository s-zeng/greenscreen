x = 44
y = 66

SCHEDULER.every '2s', :first_in => 0 do |job|
  delta = rand(-10..10)
  x = [x + delta, 100].min
  y = [y - delta, 0].max
  send_event 'modes_graph', {
    value: [{label: "City", value: x},
            {label: "Highway", value: y}],
    moreinfo: "#{x+y} miles driven in the past 24 hours"
  }
end
