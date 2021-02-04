# frozen_string_literal: true

#
# Copyright 2014, Deutsche Telekom AG
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

Puppet::Parser::Functions.newfunction(:get_ssh_kex, :type => :rvalue) do |args|
  os = args[0].downcase
  osrelease = args[1]
  osmajor = osrelease.sub(/\..*/, '')
  weak_kex = args[2] ? 'weak' : 'default'

  kex59 = {}
  kex59.default = 'diffie-hellman-group-exchange-sha256'
  kex59['weak'] = kex59['default'] + ',diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1'

  kex66 = {}
  kex66.default = 'curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256'
  kex66['weak'] = kex66['default'] + ',diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1'

  kex82 = {}
  kex82.default = 'sntrup4591761x25519-sha512@tinyssh.org,curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256'
  kex82['weak'] = kex66['default'] + ',diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1'

  # creat the default version map (if os + version are default)
  default_vmap = {}
  default_vmap.default = kex59

  # create the main map
  m = {}
  m.default = default_vmap

  m['ubuntu'] = {}
  m['ubuntu']['12'] = kex59
  m['ubuntu']['14'] = kex66
  m['ubuntu']['16'] = kex66
  m['ubuntu']['18'] = kex66
  m['ubuntu']['20'] = kex82
  m['ubuntu'].default = kex82

  m['debian'] = {}
  m['debian']['6'] = ''
  m['debian']['7'] = kex59
  m['debian']['8'] = kex66
  m['debian']['10'] = kex66
  m['debian'].default = kex66

  m['redhat'] = {}
  m['redhat']['6'] = ''
  m['redhat'].default = kex59

  m['centos'] = m['redhat']
  m['oraclelinux'] = m['redhat']

  m[os][osmajor][weak_kex]
end
