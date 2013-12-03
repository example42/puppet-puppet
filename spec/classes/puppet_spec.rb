require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'puppet' do

  let(:title) { 'puppet' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test standard installation' do
    it { should contain_package('puppet').with_ensure('present') }
    it { should contain_service('puppet').with_ensure('running') }
    it { should contain_service('puppet').with_enable('true') }
    it { should contain_file('puppet.conf').with_ensure('present') }
  end

  describe 'Test standard installation on Debian' do
    let(:facts) { { :ipaddress => '10.42.42.42', :operatingsystem => 'Debian' } }

    it { should contain_package('puppet').with_ensure('present') }
    it { should contain_service('puppet').with_ensure('running') }
    it { should contain_service('puppet').with_enable('true') }
    it { should contain_file('puppet.conf').with_ensure('present') }
    it { should contain_file('default-puppet').with_ensure('present') }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:version => '1.0.42' } }
    it { should contain_package('puppet').with_ensure('1.0.42') }
  end

  describe 'Test standard installation with monitoring and firewalling' do
    let(:facts) { { :ipaddress => '10.42.42.42', :concat_basedir => '/var/lib/puppet/concat'} }
    let(:params) { {:monitor => true , :firewall => true, :mode => 'server', :port => '42', :protocol => 'tcp', :runmode => 'service' } }
    it { should contain_package('puppet').with_ensure('present') }
    it { should contain_service('puppet').with_ensure('running') }
    it { should contain_service('puppet').with_enable('true') }
    it { should contain_file('puppet.conf').with_ensure('present') }
    it { should  contain_monitor__process('puppet_process_agent').with_enable('true') }
    it { should  contain_monitor__process('puppet_process_server').with_enable('true') }
    it 'should place a firewall rule' do should contain_firewall('puppet_tcp_42').with_enable('true') end
  end

  describe 'Test decommissioning - absent' do
    let(:facts) { { :ipaddress => '10.42.42.42', :concat_basedir => '/var/lib/puppet/concat'} }
    let(:params) { {:absent => true, :monitor => true , :firewall => true, :mode => 'server', :port => '42', :protocol => 'tcp', :runmode => 'service' } }
    it 'should remove Package[puppet]' do should contain_package('puppet').with_ensure('absent') end 
    it 'should stop Service[puppet]' do should contain_service('puppet').with_ensure('stopped') end
    it 'should not enable at boot Service[puppet]' do should contain_service('puppet').with_enable('false') end
    it 'should remove puppet configuration file' do should contain_file('puppet.conf').with_ensure('absent') end
    it 'should not monitor the agent process' do should contain_monitor__process('puppet_process_agent').with_enable('false') end
    it 'should not monitor the server process' do should contain_monitor__process('puppet_process_server').with_enable('false') end
    it 'should remove a firewall rule' do should contain_firewall('puppet_tcp_42').with_enable('false') end
  end

  describe 'Test decommissioning - disable' do
    let(:facts) { { :ipaddress => '10.42.42.42', :concat_basedir => '/var/lib/puppet/concat'} }
    let(:params) { {:disable => true, :monitor => true , :firewall => true, :mode => 'server', :port => '42', :protocol => 'tcp', :runmode => 'service' } }
    it { should contain_package('puppet').with_ensure('present') }
    it 'should stop Service[puppet]' do should contain_service('puppet').with_ensure('stopped') end
    it 'should not enable at boot Service[puppet]' do should contain_service('puppet').with_enable('false') end
    it { should contain_file('puppet.conf').with_ensure('present') }
    it 'should not monitor the agent process' do should contain_monitor__process('puppet_process_agent').with_enable('false') end
    it 'should not monitor the server process' do should contain_monitor__process('puppet_process_server').with_enable('false') end
    it 'should keep a firewall rule' do should contain_firewall('puppet_tcp_42').with_enable('false') end
  end

  describe 'Test decommissioning - disableboot' do
    let(:facts) { { :ipaddress => '10.42.42.42', :concat_basedir => '/var/lib/puppet/concat'} }
    let(:params) { {:disableboot => true, :monitor => true , :firewall => true, :mode => 'server', :port => '42', :protocol => 'tcp', :runmode => 'service' } }
    it { should contain_package('puppet').with_ensure('present') }
    it { should_not contain_service('puppet').with_ensure('present') }
    it { should_not contain_service('puppet').with_ensure('absent') }
    it 'should not enable at boot Service[puppet]' do should contain_service('puppet').with_enable('false') end
    it { should contain_file('puppet.conf').with_ensure('present') }
    it 'should not monitor the agent process' do should contain_monitor__process('puppet_process_agent').with_enable('false') end
    it 'should not monitor the server process' do should contain_monitor__process('puppet_process_server').with_enable('false') end
    it 'should keep a firewall rule' do should contain_firewall('puppet_tcp_42').with_enable('true') end
  end

  describe 'Test customizations - template' do
    let(:params) { {:template => "puppet/spec.erb" , :options => { 'opt_a' => 'value_a' } } }

    it 'should generate a valid template' do
      content = catalogue.resource('file', 'puppet.conf').send(:parameters)[:content]
      content.should match "fqdn: rspec.example42.com"
    end
    it 'should generate a template that uses custom options' do
      content = catalogue.resource('file', 'puppet.conf').send(:parameters)[:content]
      content.should match "value_a"
    end

  end

  describe 'Test customizations - source' do
    let(:params) { {:source => "puppet://modules/puppet/spec" , :source_dir => "puppet://modules/puppet/dir/spec" , :source_dir_purge => true } }

    it 'should request a valid source ' do
      content = catalogue.resource('file', 'puppet.conf').send(:parameters)[:source]
      content.should == "puppet://modules/puppet/spec"
    end
    it 'should request a valid source dir' do
      content = catalogue.resource('file', 'puppet.dir').send(:parameters)[:source]
      content.should == "puppet://modules/puppet/dir/spec"
    end
    it 'should purge source dir if source_dir_purge is true' do
      content = catalogue.resource('file', 'puppet.dir').send(:parameters)[:purge]
      content.should == true
    end
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:my_class => "puppet::spec" } }
    it 'should automatically include a custom class' do
      content = catalogue.resource('file', 'puppet.conf').send(:parameters)[:content]
      content.should match "fqdn: rspec.example42.com"
    end
  end

  describe 'Test service autorestart' do
    let(:params) { {:service_autorestart => "true" } }
    it { should contain_file('puppet.conf').with_notify('Service[puppet]') }
  end

  describe 'Test service autorestart' do
    let(:params) { {:service_autorestart => true } }

    it 'should automatically restart the service, when service_autorestart => true' do
      content = catalogue.resource('file', 'puppet.conf').send(:parameters)[:notify]
      content.should == "Service[puppet]"
    end
  end

  describe 'Test Puppi Integration' do
    let(:params) { {:puppi => true, :puppi_helper => "myhelper"} }

    it 'should generate a puppi::ze define' do
      content = catalogue.resource('puppi::ze', 'puppet').send(:parameters)[:helper]
      content.should == "myhelper"
    end
  end

  describe 'Test Monitoring Tools Integration' do
    let(:params) { {:monitor => true, :monitor_tool => "puppi", :runmode => 'service' } }
    it { should contain_monitor__process('puppet_process_agent').with_tool('puppi') }
  end

  describe 'Test Firewall Tools Integration' do
    let(:facts) { { :ipaddress => '10.42.42.42', :concat_basedir => '/var/lib/puppet/concat'} }
    let(:params) { {:firewall => true, :mode => 'server', :firewall_tool => "iptables" , :protocol => "tcp" , :port => "42" } }

    it 'should generate correct firewall define' do
      content = catalogue.resource('firewall', 'puppet_tcp_42').send(:parameters)[:tool]
      content.should == "iptables"
    end
  end

  describe 'Test OldGen Module Set Integration' do
    let(:facts) { { :ipaddress => '10.42.42.42', :concat_basedir => '/var/lib/puppet/concat'} }
    let(:params) { {:monitor => "yes" , :monitor_tool => "puppi" , :firewall => "yes" , :mode => 'server' , :firewall_tool => "iptables" , :puppi => "yes" , :port => "42" , :protocol => 'tcp', :runmode => 'service' } }
    it { should contain_monitor__process('puppet_process_agent').with_tool('puppi') }
    it { should contain_monitor__process('puppet_process_server').with_tool('puppi') }
    it { should contain_firewall('puppet_tcp_42').with_tool('iptables') }
    it { should contain_puppi__ze('puppet').with_ensure('present') }
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => true , :ipaddress => '10.42.42.42' } }
    let(:params) { { :port => '42', :runmode => 'service' } }
    it 'should honour top scope global vars' do should contain_monitor__process('puppet_process_agent').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) { { :puppet_monitor => true , :ipaddress => '10.42.42.42' } }
    let(:params) { { :port => '42', :runmode => 'service' } }
    it 'should honour module specific vars' do should contain_monitor__process('puppet_process_agent').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => false , :puppet_monitor => true , :ipaddress => '10.42.42.42' } }
    let(:params) { { :port => '42', :runmode => 'service' } }
    it 'should honour top scope module specific over global vars' do should contain_monitor__process('puppet_process_agent').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => false , :ipaddress => '10.42.42.42' } }
    let(:params) { { :monitor => true , :port => '42', :runmode => 'service' } }
    it 'should honour passed params over global vars' do should contain_monitor__process('puppet_process_agent').with_enable('true') end
  end

end

