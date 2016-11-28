require 'spec_helper'

describe 'sudo', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('sudo') }

      it do
        is_expected.to contain_class('sudo::install').that_comes_before(
          'Class[sudo::config]'
        )
      end

      it { is_expected.to contain_class('sudo::config') }

      context 'with default values for all parameters' do
        describe 'sudo::install' do
          it do
            is_expected.to contain_package('sudo').only_with(
              ensure: 'present',
              name: 'sudo'
            )
          end
        end

        describe 'sudo::config' do
          it do
            is_expected.to contain_file(
              '/usr/bin/sudo'
            ).with(
              ensure: 'present',
              owner: 'root',
              group: 'root',
              mode: '4111'
            )
          end

          it do
            is_expected.to contain_file(
              '/etc/sudoers.d'
            ).with(
              ensure: 'directory',
              owner: 'root',
              group: 'root',
              mode: '0755',
              recurse: true,
              purge: true
            )
          end

          it do
            is_expected.to contain_file(
              '/etc/sudoers'
            ).with(
              ensure: 'present',
              owner: 'root',
              group: 'root',
              mode: '0440'
            )
          end
        end
      end

      context 'with custom settings for default_sudo_vars' do
        let(:params) do
          {
            default_sudo_vars: ['env_reset']
          }
        end
        it do
          is_expected.to contain_file(
            '/etc/sudoers'
          ).with(
            ensure: 'present',
            owner: 'root',
            group: 'root',
            mode: '0440'
          ).with_content(/Defaults     env_reset/)
        end
      end

      context 'with custom settings for full_sudo_groups' do
        let(:params) do
          {
            full_sudo_groups: ['superusers']
          }
        end
        it do
          is_expected.to contain_file(
            '/etc/sudoers'
          ).with(
            ensure: 'present',
            owner: 'root',
            group: 'root',
            mode: '0440'
          ).with_content(/%superusers   ALL=\(ALL\)  NOPASSWD: ALL/)
        end
      end

      context 'with invalid values for parameter' do
        [
          [:default_sudo_vars, RSpecHelper::BadValues::INVALID_ARRAY],
          [:full_sudo_groups, RSpecHelper::BadValues::INVALID_ARRAY],
          [:logging_enabled, RSpecHelper::BadValues::INVALID_BOOL]
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
