x = 44
y = 66

SCHEDULER.every '2s', :first_in => 0 do |job|
  x += rand(0..10)
  y += rand(0..10)
  send_event 'modes_graph', {
    value: [{label: "City", value: x},
            {label: "Highway", value: y}],
    moreinfo: "#{x+y} miles driven in the past 24 hours"
  }
end
