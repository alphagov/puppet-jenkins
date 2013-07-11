require 'spec_helper'

describe 'jenkins::config::mailer' do
  let(:config_file) { '/var/lib/jenkins/hudson.tasks.Mailer.xml' }

  describe 'no params, defaults' do
    let(:params) {{ }}

    it {
      should contain_file(config_file).with(
        :ensure => 'present',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0644',
        :notify => 'Class[Jenkins::Service]'
      )
    }

    it {
      should contain_file(config_file).with_content(<<EOS
<?xml version='1.0' encoding='UTF-8'?>
<hudson.tasks.Mailer_-DescriptorImpl plugin="mailer@1.4">
  <charset>UTF-8</charset>
</hudson.tasks.Mailer_-DescriptorImpl>
EOS
      )
    }
  end

  describe 'config_hash overrides config_defaults' do
    let(:params) {{
      :config_hash => {
        'charset'  => 'UTF-16',
      }
    }}

    it {
      should contain_file(config_file).with_content(<<EOS
<?xml version='1.0' encoding='UTF-8'?>
<hudson.tasks.Mailer_-DescriptorImpl plugin="mailer@1.4">
  <charset>UTF-16</charset>
</hudson.tasks.Mailer_-DescriptorImpl>
EOS
      )
    }
  end

  describe 'config_hash and config_defaults together' do
    let(:params) {{
      :config_hash          => {
        'z_should_be'       => 'last',
        'a_should_be'       => 'first',
        'default_should_be' => 'overridden',
      },
      :config_defaults => {
        'default_should_be' => 'not this val',
      }
    }}

    it {
      should contain_file(config_file).with_content(<<EOS
<?xml version='1.0' encoding='UTF-8'?>
<hudson.tasks.Mailer_-DescriptorImpl plugin="mailer@1.4">
  <a_should_be>first</a_should_be>
  <default_should_be>overridden</default_should_be>
  <z_should_be>last</z_should_be>
</hudson.tasks.Mailer_-DescriptorImpl>
EOS
      )
    }
  end

  describe 'plugin param' do
    let(:params) {{
      :plugin => 'mailer@2.0',
    }}

    it {
      should contain_file(config_file).with_content(<<EOS
<?xml version='1.0' encoding='UTF-8'?>
<hudson.tasks.Mailer_-DescriptorImpl plugin="mailer@2.0">
  <charset>UTF-8</charset>
</hudson.tasks.Mailer_-DescriptorImpl>
EOS
      )
    }
  end

  describe 'reject non-hash params' do
    %w{config_hash config_defaults}.each do |param|
      describe param do
        let(:params) {{
          param => 'this is a string',
        }}

        it { expect { should }.to raise_error(Puppet::Error, / is not a Hash\./) }
      end
    end
  end
end
