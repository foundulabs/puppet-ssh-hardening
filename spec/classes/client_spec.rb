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

require 'spec_helper'

describe 'ssh_hardening::client' do

  let(:facts) do
    { :osfamily => 'redhat' }
  end

  it do
    should contain_file('/etc/ssh/ssh_config').with(
      'owner' => 'root',
      'group' => 'root',
      'mode' => '0644'
    )
  end

  # default configuration
  it { should contain_file('/etc/ssh/ssh_config').with_content(/^Port = 22$/) }

  # user configuration
  context 'with ports => [8022]' do
    let(:params) { { :ports => [8022] } }
    it { should contain_file('/etc/ssh/ssh_config').with_content(/^Port = 8022$/) }
  end

  # default configuration
  it { should contain_file('/etc/ssh/ssh_config').with_content(/^AddressFamily = inet$/) }
  # user configuration
  context 'with ipv6_enabled => true' do
    let(:params) { { :ipv6_enabled => true } }
    it { should contain_file('/etc/ssh/ssh_config').with_content(/^AddressFamily = any$/) }
  end

  context 'with ipv6_enabled => false' do
    let(:params) { { :ipv6_enabled => false } }
    it { should contain_file('/etc/ssh/ssh_config').with_content(/^AddressFamily = inet$/) }
  end

end
