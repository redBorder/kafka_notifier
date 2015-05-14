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

module Redborder
  module KafkaNotifier
    module Model
      private

      def acts_as_kafka_notifier_exportable_attributes
        attributes.except('created_at', 'updated_at').select do |_, v|
          !v.nil? || !acts_as_kafka_notifier_options[:ignore_nil_attributes]
        end
      end

      def acts_as_kafka_notifier_build_message(opts)
        merge_function = acts_as_kafka_notifier_options[:merge]
        message = opts.merge data: acts_as_kafka_notifier_exportable_attributes
        message[:data].merge! send(merge_function) unless merge_function.nil?
        message
      end

      def acts_as_kafka_notifier_send_message(opts = {})
        filter_function = acts_as_kafka_notifier_options[:filter]
        return if !filter_function.nil? && !send(filter_function)

        message = acts_as_kafka_notifier_build_message opts

        Redborder::KafkaNotifier.send(
          acts_as_kafka_notifier_options[:topic],
          message[:data][acts_as_kafka_notifier_options[:key]],
          message
        )
      end

      def acts_as_kafka_notifier_emit_create
        return unless acts_as_kafka_notifier_options[:notify_on_create]
        acts_as_kafka_notifier_send_message type: :create
      end

      def acts_as_kafka_notifier_emit_update
        return unless acts_as_kafka_notifier_options[:notify_on_update]
        acts_as_kafka_notifier_send_message type: :update
      end

      def acts_as_kafka_notifier_emit_destroy
        return unless acts_as_kafka_notifier_options[:notify_on_destroy]
        acts_as_kafka_notifier_send_message type: :destroy
      end
    end
  end
end
