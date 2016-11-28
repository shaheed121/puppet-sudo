require 'spec_helper'

describe 'sudo::logging', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with default parameters' do
        let(:params) do
          {
            enabled: true,
            log_dir: '/var/log/sudo-io/%Y-%m-%d',
            log_file: '%{seq}',
            disable_cmnd_logging:
              ['/usr/bin/sudoreplay', '/usr/bin/rsync', '/sbin/reboot'],
            disable_user_logging: %w(root nagios)
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('sudo') }

        it do
          is_expected.to contain_file(
            '/etc/sudoers.d/logging'
          ).with(
            ensure: 'present',
            owner: 'root',
            group: 'root',
            mode: '0400',
            content:
              "# Sudo::logging\n" \
              "# Enabling sudo output logging\n" \
              "Defaults log_output\n" \
              "Defaults iolog_dir=\"/var/log/sudo-io/%Y-%m-%d\"\n" \
              "Defaults iolog_file=\"%{seq}\"\n" \
              "Defaults!/usr/bin/sudoreplay !log_output\n" \
              "Defaults!/usr/bin/rsync !log_output\n" \
              "Defaults!/sbin/reboot !log_output\n" \
              "Defaults:root !log_output\n" \
              "Defaults:nagios !log_output\n"
          )
        end
      end

      context 'with invalid values for parameter' do
        [
          [:enabled, RSpecHelper::BadValues::INVALID_BOOL],
          [:log_dir, RSpecHelper::BadValues::INVALID_STRING],
          [:log_file, RSpecHelper::BadValues::INVALID_STRING],
          [:disable_cmnd_logging, RSpecHelper::BadValues::INVALID_ARRAY],
          [:disable_user_logging, RSpecHelper::BadValues::INVALID_ARRAY]
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
