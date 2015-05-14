require 'bundler/setup'
Bundler.setup

require 'active_record'
require 'active_support/all'

require 'kafka_notifier'

include Redborder::KafkaNotifier
