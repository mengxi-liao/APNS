require File.dirname(__FILE__) + '/../spec_helper'

describe APNS do
  before do
    ::APNS.host = "gateway.abc.com"
    ::APNS.port = 1234
    allow(File).to receive(:exist?) { true }
  end

  describe ".send_notification" do
    it "accepts default app and pem" do
      ::APNS.pem = 'default_pem'

      context = OpenStruct.new
      socket = OpenStruct.new
      ssl = OpenStruct.new

      expect(socket).to receive(:close)
      expect(ssl).to receive(:close)
      expect(ssl).to receive(:write)

      expect(APNS).to receive(:build_context).with('default_pem') { context }
      expect(APNS).to receive(:build_socket).with(::APNS.host, ::APNS.port) { socket }
      expect(APNS).to receive(:build_ssl).with(context, socket) { ssl }

      ::APNS.send_notification("device_token1", message: "message", otherstuff: "others")
    end

    it "accepts an app key" do
      ::APNS.pems = { app1: 'cert1'}

      context = OpenStruct.new
      socket = OpenStruct.new
      ssl = OpenStruct.new

      expect(socket).to receive(:close)
      expect(ssl).to receive(:close)
      expect(ssl).to receive(:write)

      expect(APNS).to receive(:build_context).with('cert1') { context }
      expect(APNS).to receive(:build_socket).with(::APNS.host, ::APNS.port) { socket }
      expect(APNS).to receive(:build_ssl).with(context, socket) { ssl }

      ::APNS.send_notification("device_token1", :app1, "message1")
    end
  end

  describe ".feedback" do
    it "accept default app and pem" do
      ::APNS.pem = 'default_pem'

      context = OpenStruct.new
      socket = OpenStruct.new
      ssl = OpenStruct.new

      expect(socket).to receive(:close)
      expect(ssl).to receive(:read).with(38)
      expect(ssl).to receive(:close)

      expect(APNS).to receive(:build_context).with('default_pem') { context }
      expect(APNS).to receive(:build_socket).with("feedback.abc.com", 2196) { socket }
      expect(APNS).to receive(:build_ssl).with(context, socket) { ssl }

      ::APNS.feedback
    end

    it "accepts an app key" do
      ::APNS.pems = { app1: 'cert1'}

      context = OpenStruct.new
      socket = OpenStruct.new
      ssl = OpenStruct.new

      expect(socket).to receive(:close)
      expect(ssl).to receive(:read).with(38)
      expect(ssl).to receive(:close)

      expect(APNS).to receive(:build_context).with('cert1') { context }
      expect(APNS).to receive(:build_socket).with("feedback.abc.com", 2196) { socket }
      expect(APNS).to receive(:build_ssl).with(context, socket) { ssl }

      ::APNS.feedback(:app1)
    end
  end
end
