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

describe 'ssh_hardening::server' do

  let(:facts) do
    { :osfamily => 'redhat' }
  end

  it do
    should contain_file('/etc/ssh').with(
      'ensure' => 'directory',
      'owner' => 'root',
      'group' => 'root',
      'mode' => '0755'
    )
  end

  sshd_config = '/etc/ssh/sshd_config'

  it do
    should contain_file(sshd_config).with(
      'owner' => 'root',
      'group' => 'root',
      'mode' => '0600'
    )
  end

  # default configuration
  it { should contain_file(sshd_config).with_content(/^Port 22$/) }
  # user configuration
  context 'with ports => [8022]' do
    let(:params) { { :ports => [8022] } }
    it { should contain_file(sshd_config).with_content(/^Port 8022$/) }
  end

  # user configuration
  context 'with listen_to => 1.2.3.4' do
    let(:params) { { :listen_to => '1.2.3.4' } }
    it { should contain_file(sshd_config).with_content(/^ListenAddress 1.2.3.4$/) }
  end

  # default configuration
  it { should_not contain_file(sshd_config).with_content(/^HostKey$/) }
  # user configuration
  context 'with host_key_files => [/a/file]' do
    let(:params) { { :host_key_files => ['/a/file'] } }
    it { should contain_file(sshd_config).with_content(%r{^HostKey /a/file$}) }
  end

  # default configuration
  it { should contain_file(sshd_config).with_content(/^ClientAliveInterval 600$/) }
  # user configuration
  context 'with client_alive_interval => 300' do
    let(:params) { { :client_alive_interval => 300 } }
    it { should contain_file(sshd_config).with_content(/^ClientAliveInterval 300$/) }
  end

  # default configuration
  it { should contain_file(sshd_config).with_content(/^ClientAliveCountMax 3$/) }
  # user configuration
  context 'with client_alive_count => 2' do
    let(:params) { { :client_alive_count => 2 } }
    it { should contain_file(sshd_config).with_content(/^ClientAliveCountMax 2$/) }
  end

  # default configuration
  it { should contain_file(sshd_config).with_content(/^PermitRootLogin no$/) }
  # user configuration
  context 'with allow_root_with_key => true' do
    let(:params) { { :allow_root_with_key => true } }
    it { should contain_file(sshd_config).with_content(/^PermitRootLogin without-password$/) }
  end

  context 'with allow_root_with_key => false' do
    let(:params) { { :allow_root_with_key => false } }
    it { should contain_file(sshd_config).with_content(/^PermitRootLogin no$/) }
  end

  # default configuration
  it { should contain_file(sshd_config).with_content(/^AddressFamily inet$/) }
  # user configuration
  context 'with ipv6_enabled => true' do
    let(:params) { { :ipv6_enabled => true } }
    it { should contain_file(sshd_config).with_content(/^AddressFamily any$/) }
  end

  context 'with ipv6_enabled => false' do
    let(:params) { { :ipv6_enabled => false } }
    it { should contain_file(sshd_config).with_content(/^AddressFamily inet$/) }
  end

  # default configuration
  it { should contain_file(sshd_config).with_content(/^UsePAM yes$/) }
  # user configuration
  context 'with use_pam => true' do
    let(:params) { { :use_pam => true } }
    it { should contain_file(sshd_config).with_content(/^UsePAM yes$/) }
  end

  context 'with use_pam => false' do
    let(:params) { { :use_pam => false } }
    it { should contain_file(sshd_config).with_content(/^UsePAM no$/) }
  end

  # default configuration
  it { should contain_file(sshd_config).with_content(/^AllowTcpForwarding no$/) }
  # user configuration
  context 'with allow_tcp_forwarding => true' do
    let(:params) { { :allow_tcp_forwarding => true } }
    it { should contain_file(sshd_config).with_content(/^AllowTcpForwarding yes$/) }
  end

  context 'with allow_tcp_forwarding => true' do
    let(:params) { { :allow_tcp_forwarding => false } }
    it { should contain_file(sshd_config).with_content(/^AllowTcpForwarding no$/) }
  end

  # default configuration
  it { should contain_file(sshd_config).with_content(/^AllowAgentForwarding no$/) }
  # user configuration
  context 'with allow_agent_forwarding => true' do
    let(:params) { { :allow_agent_forwarding => true } }
    it { should contain_file(sshd_config).with_content(/^AllowAgentForwarding yes$/) }
  end

  context 'with allow_agent_forwarding => false' do
    let(:params) { { :allow_agent_forwarding => false } }
    it { should contain_file(sshd_config).with_content(/^PermitRootLogin no$/) }
  end

end
