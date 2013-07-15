require 'em-websocket'

EventMachine.run do
  @flizzychat = EM::Channel.new

  EventMachine::WebSocket.start(host: '0.0.0.0', port: 8090, debug: true) do |ws|
    ws.onopen{
      sid = @flizzychat.subscribe{|msg| ws.send msg}
      @flizzychat.push "#{sid} has connected!"

      ws.onmessage{ |msg|
        @flizzychat.push "<#{sid}>: #{msg}"
      }

      ws.onclose{@flizzychat.unsubscribe(sid)}
    }
  end
  puts "server started on port 8090"
end