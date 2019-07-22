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

Puppet::Parser::Functions.newfunction(:get_ssh_macs, :type => :rvalue) do |args|
  os = args[0].downcase
  osrelease = args[1]
  osmajor = osrelease.sub(/\..*/, '')
  weak_macs = args[2] ? 'weak' : 'default'

  macs53 = {}
  macs53.default = 'hmac-ripemd160,hmac-sha1'

  macs59 = {}
  macs59.default = 'hmac-sha2-512,hmac-sha2-256,hmac-ripemd160'
  macs59['weak'] = macs59['default'] + ',hmac-sha1'

  macs66 = {}
  macs66.default = 'hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256'
  macs66['weak'] = macs66['default'] + ',hmac-sha1'

  # creat the default version map (if os + version are default)
  default_vmap = {}
  default_vmap.default = macs59

  # create the main map
  m = {}
  m.default = default_vmap

  m['ubuntu'] = {}
  m['ubuntu']['12'] = macs59
  m['ubuntu']['14'] = macs66
  m['ubuntu']['16'] = macs66
  m['ubuntu'].default = macs59

  m['debian'] = {}
  m['debian']['6'] = macs53
  m['debian']['7'] = macs59
  m['debian']['8'] = macs66
  m['debian'].default = macs59

  m['redhat'] = {}
  m['redhat']['6'] = macs53
  m['redhat'].default = macs53

  m['centos'] = m['redhat']
  m['oraclelinux'] = m['redhat']

  m[os][osmajor][weak_macs]
end
