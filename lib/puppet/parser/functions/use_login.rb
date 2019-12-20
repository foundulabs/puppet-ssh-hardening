# frozen_string_literal: true

#
# Copyright 2015, Dominik Richter
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

Puppet::Parser::Functions.newfunction(:use_login, :type => :rvalue) do |args|
  os = args[0].downcase
  osrelease = args[1]
  osmajor = osrelease.sub(/\..*/, '')

  ps74 = nil
  ps = 'no'

  if os == 'debian' && osmajor.to_i >= 10
    ps = ps74
  end

  if os == 'ubuntu' && osmajor.to_i >= 18
    ps = ps74
  end

  ps
end
  