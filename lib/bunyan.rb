require 'json'

module Bunyan
  def self.log label, details = nil
    hash = {label: label, details: details}
    hash.delete_if { |k, v| v.nil? }

    msg = hash.to_json
    conn = Bunny.new
    conn.start

    channel = conn.create_channel
    exchange = channel.fanout "logs"

    exchange.publish(msg)

    conn.close
  end
end
