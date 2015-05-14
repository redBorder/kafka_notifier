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
    module Base
      def acts_as_kafka_notifier(opts = {})
        acts_as_kafka_notifier_options opts

        include Model

        after_create :acts_as_kafka_notifier_emit_create
        after_update :acts_as_kafka_notifier_emit_update
        after_destroy :acts_as_kafka_notifier_emit_destroy
      end

      private

      def acts_as_kafka_notifier_options(opts)
        opts = acts_as_kafka_notifier_default_options.merge opts

        class_attribute :acts_as_kafka_notifier_options
        self.acts_as_kafka_notifier_options = opts
      end

      def acts_as_kafka_notifier_default_options
        {
          topic: "changelog_#{name.underscore}",
          ignore_nil_attributes: true,
          exportable_fields: [],
          notify_on_create: true,
          notify_on_update: true,
          notify_on_destroy: true,
          key_field: nil,
          filter: nil,
          merge: nil
        }
      end
    end
  end
end
