require 'spec_helper'

describe 'pe_backup' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'pe_backup class with destination => /tmp' do
          let(:params) do
            {
              destination: '/tmp',
            }
          end

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('pe_backup::params') }
          it { is_expected.to contain_class('pe_backup::install').that_comes_before('Class[pe_backup::service]') }

          it { is_expected.to contain_cron('pe_backup') }
          it { is_expected.to contain_file('/usr/local/bin/pe_backup.sh').with_ensure('file') }
        end
      end
    end
  end
end
