# Possible names:
# Lumberjack, Bunyan
require 'bunny'
require 'timeout'
require 'bunyan'

def timeout
  Timeout::timeout(0.5) do
    yield
  end
end

describe Bunyan do
  before do
    @received ||= []
    setup_listener
    until @ready
    end
  end

  it 'logs an event by sending to rabbit' do
    Bunyan.log :purchase

    @received.last.should match(/"label":"purchase"/)
  end

  it 'accepts a details hash' do
    Bunyan.log :purchase, item: :hammock

    @received.last.should match(/"details":{"item":"hammock"}}/)
  end

  def with_connection
    conn = Bunny.new
    conn.start

    channel = conn.create_channel
    exchange = channel.fanout "logs"
    queue = channel.queue "", exclusive: true

    queue.bind exchange

    @ready = true

    yield channel, queue

  ensure
    channel.close
    conn.close
  end

  def setup_listener
    Thread.new do
      with_connection do |channel, queue|

        timeout do
          queue.subscribe(block: true) do |delivery_info, properties, body|
            @received << body
            delivery_info.consumer.cancel
          end
        end
      end
    end
    Thread.list.each do |thread|
      thread.join unless thread = Thread.current
    end
  end
end

# Use in conjunction with ActiveModel::Serializers and #to_json
