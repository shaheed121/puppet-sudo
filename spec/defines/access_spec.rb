require 'spec_helper'

describe 'sudo::access', type: :define do
  let(:title) { 'test_grant' }
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'job with default values' do
        it do
          is_expected.to contain_file(
            "/etc/sudoers.d/#{title}"
          ).with(
            ensure: 'present',
            owner:  'root',
            group:  'root',
            mode:   '0400'
          ).with_content(
            "# Sudo access for test_grant\n"\
            "%test_grant ALL=(ALL) NOPASSWD:ALL\n"
          )
        end
      end

      context 'job with custom values' do
        let(:params) do
          {
            commands: '/usr/bin/tcpdump',
            target: 'sysadmin',
            group:  'adminusers'
          }
        end
        it do
          is_expected.to contain_file(
            "/etc/sudoers.d/#{title}"
          ).with(
            ensure: 'present',
            owner:  'root',
            group:  'root',
            mode:   '0400'
          ).with_content(
            "# Sudo access for adminusers\n"\
            "Cmnd_Alias TEST_GRANT_CMDS=/usr/bin/tcpdump\n"\
            "%adminusers ALL=(sysadmin) NOPASSWD:TEST_GRANT_CMDS\n"
          )
        end
      end

      context 'job with invalid values' do
        [
          [:commands, RSpecHelper::BadValues::INVALID_STRING],
          [:defaults, RSpecHelper::BadValues::INVALID_ARRAY],
          [:group, RSpecHelper::BadValues::INVALID_STRING],
          [:target, RSpecHelper::BadValues::INVALID_STRING],
          [:template, RSpecHelper::BadValues::INVALID_STRING]
        ].each do |parameter, invalid|
          describe parameter do
            invalid.each do |value|
              describe "=> '#{value}' (#{value.class})" do
                let(:params) { { parameter => value } }
                it { is_expected.to raise_error(Puppet::ParseError) }
              end
            end
          end
        end
      end
    end
  end
end
