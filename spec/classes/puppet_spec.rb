require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'puppet' do

  let(:title) { 'puppet' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { {
    :ipaddress => '10.42.42.42',
    :concat_basedir => '/tmp/cb',
    :operatingsystemrelease => '6.6'
  } }

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
    let(:params) { {:monitor => true , :monitor_tool => 'puppi' , :firewall => true, :mode => 'server', :port => '42', :protocol => 'tcp' } }

    it { should contain_package('puppet').with_ensure('present') }
    it { should contain_service('puppet').with_ensure('running') }
    it { should contain_service('puppet').with_enable('true') }
    it { should contain_file('puppet.conf').with_ensure('present') }
    it { should contain_monitor__process('puppet_process').with_enable('true') }
    it { should contain_firewall('puppet_tcp_42').with_enable('true') }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true, :monitor => true , :monitor_tool => 'puppi' , :firewall => true, :mode => 'server', :port => '42', :protocol => 'tcp'} }

    it 'should remove Package[puppet]' do should contain_package('puppet').with_ensure('absent') end 
    it 'should stop Service[puppet]' do should contain_service('puppet').with_ensure('stopped') end
    it 'should not enable at boot Service[puppet]' do should contain_service('puppet').with_enable('false') end
    it 'should remove puppet configuration file' do should contain_file('puppet.conf').with_ensure('absent') end
    it { should contain_monitor__process('puppet_process').with_enable('false') }
    it { should contain_firewall('puppet_tcp_42').with_enable('false') }
  end

  describe 'Test decommissioning - disable' do
    let(:params) { {:disable => true, :monitor => true , :monitor_tool => 'puppi' , :firewall => true, :mode => 'server', :port => '42', :protocol => 'tcp'} }

    it { should contain_package('puppet').with_ensure('present') }
    it 'should stop Service[puppet]' do should contain_service('puppet').with_ensure('stopped') end
    it 'should not enable at boot Service[puppet]' do should contain_service('puppet').with_enable('false') end
    it { should contain_file('puppet.conf').with_ensure('present') }
    it { should contain_monitor__process('puppet_process').with_enable('false') }
    it { should contain_firewall('puppet_tcp_42').with_enable('false') }
  end

  describe 'Test decommissioning - disableboot' do
    let(:params) { {:disableboot => true, :monitor => true , :monitor_tool => 'puppi' , :firewall => true, :mode => 'server', :port => '42', :protocol => 'tcp'} }
  
    it { should contain_package('puppet').with_ensure('present') }
    it { should_not contain_service('puppet').with_ensure('present') }
    it { should_not contain_service('puppet').with_ensure('absent') }
    it 'should not enable at boot Service[puppet]' do should contain_service('puppet').with_enable('false') end
    it { should contain_file('puppet.conf').with_ensure('present') }
    it { should contain_monitor__process('puppet_process').with_enable('false') }
    it { should contain_firewall('puppet_tcp_42').with_enable('true') }
  end 

  describe 'Test customizations - template' do
    let(:params) { {:template => "puppet/spec.erb" , :options => { 'opt_a' => 'value_a' } } }

    it { should contain_file('puppet.conf').with_content(/fqdn: rspec.example42.com/) }
    it { should contain_file('puppet.conf').with_content(/value_a/) }
  end

  describe 'Test customizations - source' do
    let(:params) { {:source => "puppet://modules/puppet/spec" , :source_dir => "puppet://modules/puppet/dir/spec" , :source_dir_purge => true } }

    it { should contain_file('puppet.conf').with_source('puppet://modules/puppet/spec') }
    it { should contain_file('puppet.dir').with_source('puppet://modules/puppet/dir/spec') }
    it { should contain_file('puppet.dir').with_purge('true') }
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:my_class => "puppet::spec" } }
    it { should contain_file('puppet.conf').with_content(/fqdn: rspec.example42.com/) }
  end

  describe 'Test service autorestart default (false)' do
    it { should contain_file('puppet.conf').with_notify(nil) }
  end

  describe 'Test service autorestart=true' do
    let(:params) { {:service_autorestart => true } }

    it { should contain_file('puppet.conf').with_notify('Service[puppet]') }
  end

  describe 'Test Puppi Integration' do
    let(:params) { {:puppi => true, :puppi_helper => "myhelper"} }

    it { should contain_puppi__ze('puppet').with_helper('myhelper') }
  end

  describe 'Test Monitoring Tools Integration' do
    let(:params) { {:monitor => true, :monitor_tool => "puppi" } }

    it { should contain_monitor__process('puppet_process').with_tool('puppi') }
  end

  describe 'Test Firewall Tools Integration' do
    let(:params) { {:firewall => true, :mode => 'server', :firewall_tool => "iptables" , :protocol => "tcp" , :port => "42" } }

    it { should contain_firewall('puppet_tcp_42').with_tool('iptables') }
  end

  describe 'Test OldGen Module Set Integration' do
    let(:params) { {:monitor => true , :monitor_tool => "puppi" , :firewall => "yes" , :mode => 'server', :firewall_tool => "iptables" , :puppi => "yes" , :port => "42" , :protocol => 'tcp', :runmode => 'service' } }

    it { should contain_monitor__process('puppet_process').with_tool('puppi') }
    it { should contain_firewall('puppet_tcp_42').with_tool('iptables') }
    it { should contain_puppi__ze('puppet').with_ensure('present') }
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => true , :monitor_tool => 'puppi' , :ipaddress => '10.42.42.42' } }
    let(:params) { { :port => '42' } }

    it { should contain_monitor__process('puppet_process').with_enable('true') }
  end

  describe 'Test params lookup' do
    let(:facts) { { :puppet_monitor => true , :monitor_tool => 'puppi' , :ipaddress => '10.42.42.42' } }
    let(:params) { { :port => '42' } }

    it { should contain_monitor__process('puppet_process').with_enable('true') }
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => false , :puppet_monitor => true , :monitor_tool => 'puppi' , :ipaddress => '10.42.42.42' } }
    let(:params) { { :port => '42' } }

    it { should contain_monitor__process('puppet_process').with_enable('true') }
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => false , :ipaddress => '10.42.42.42' } }
    let(:params) { { :monitor => true , :monitor_tool => 'puppi' , :firewall => true, :mode => 'server', :port => '42' } }

    it { should contain_monitor__process('puppet_process').with_enable('true') }
  end

end

