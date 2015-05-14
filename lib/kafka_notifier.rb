#######################################################################
# Copyright (c) 2014 ENEO Tecnologia S.L.
# This file is part of redBorder.
# redBorder is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# redBorder is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License
# along with redBorder. If not, see <http://www.gnu.org/licenses/>.
#######################################################################

require 'poseidon'
require 'yaml'

require 'kafka_notifier/base'
require 'kafka_notifier/model'
require 'kafka_notifier/message_queue'

module Redborder
  module KafkaNotifier
    mattr_accessor :config
    mattr_accessor :producer
    mattr_accessor :message_queue

    self.config = YAML.load(File.read('config/kafka.yml')).symbolize_keys

    def self.start
      self.producer = Poseidon::Producer.new(
        config[:brokers], config[:client_id], type: :sync, required_acks: 1
      )

      self.message_queue = MessageQueue.new(500, 1)
      create_producer_thread
    end

    def self.send(topic, key, message)
      start if message_queue.nil?
      strmsg = JSON.generate(message) if message.is_a? Hash
      message_queue << Poseidon::MessageToSend.new(topic, strmsg, key)
    end

    def self.create_producer_thread
      Thread.new do
        loop do
          messages = message_queue.pop_all # Get the max number of msgs or wait
          @@producer.send_messages messages unless messages.empty?
        end
      end
    end
  end
end

ActiveRecord::Base.send :extend, Redborder::KafkaNotifier::Base
