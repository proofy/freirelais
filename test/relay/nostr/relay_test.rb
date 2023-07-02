require "test_helper"

class Nostr::RelayTest < ActiveSupport::TestCase
  test "sample non-websocket request" do
    # TODO: text actual values
    assert_equal [200, {"Content-Type" => "application/json"}, [Nostr::Nips::Nip11.call.to_json]], Nostr::Relay.call({})
  end

  test "websocket request" do
    SecureRandom.stub(:hex, "CONN_ID") do
      ws_mock = Minitest::Mock.new
      # ws_mock.expect(:send, nil)
      ws_mock.expect(:rack_response, nil)
      ws_mock.expect(:send, nil, [["AUTH", "CONN_ID"].to_json])
      ws_mock.expect(:on, nil, [:message])
      ws_mock.expect(:on, nil, [:close])
      ws_mock.expect(:url, "ws://localhost:3000", [])

      Faye::WebSocket.stub(:new, ws_mock) do
        Nostr::Relay.call({
          "HTTP_CONNECTION" => "upgrade",
          "HTTP_UPGRADE" => "websocket",
          "REQUEST_METHOD" => "GET"
        })
      end

      ws_mock.verify
    end
  end
end
