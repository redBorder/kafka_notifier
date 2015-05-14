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
    class MessageQueue
      def initialize(limit = 500, timeout = 1)
        @mutex = Mutex.new
        @queue = []
        @limit = limit
        @timeout = timeout
        @recieved = ConditionVariable.new
      end
     
      def <<(x)
        @mutex.synchronize do
          @queue << x
          @recieved.signal if @queue.size >= @limit
        end
      end

      def pop_all
        @mutex.synchronize do
          @recieved.wait(@mutex, @timeout) while @queue.empty?
          to_return = []

          if @queue.size >= @limit
            to_return = @queue[0..(@limit - 1)]
            @queue = @queue[@limit..-1]
          else
            @recieved.wait(@mutex, @timeout)
            to_return = @queue.dup
            @queue.clear
          end

          return to_return
        end
      end

      def size
        @mutex.synchronize do
          @queue.size
        end
      end
    end
  end
end
