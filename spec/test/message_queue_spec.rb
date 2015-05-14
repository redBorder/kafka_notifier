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

require 'spec_helper'

describe MessageQueue do
  it 'should be thread-safe' do
    results = []

    100.times do
      queue = MessageQueue.new(1000)
      threads = []
      mutex = Mutex.new
      elements_removed = 0

      10.times do
        threads << Thread.new do
          1000.times do
            queue << 1
          end
        end
      end

      10.times do
        threads << Thread.new do
          count = queue.pop_all.size
          mutex.synchronize do
            elements_removed += count
          end
        end
      end

      threads.each(&:join)

      results << (elements_removed + queue.size == 10_000)
    end

    expect(results.any? { |result| result != true }).to eq(false)
  end
end
