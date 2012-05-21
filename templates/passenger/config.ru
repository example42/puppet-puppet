# File managed by Puppet
# SSL needs to be handled outside this, though.

# if puppet is not in your RUBYLIB:
# $:.unshift('/opt/puppet/lib')

$0 = <% if scope.lookupvar('puppet::params::mayor_version') == "0.2" -%>"puppetmasterd"<% else -%>"master"<% end %>
<% if scope.lookupvar('puppetversion') <= '2.6.1' -%>require 'puppet'<% end %>

# if you want debugging:
# ARGV << "--debug"

ARGV << "--rack"
require 'puppet/application/<% if scope.lookupvar('puppet::params::major_version') == "0.2" -%>puppetmasterd<% else -%>master<% end %>'
# we're usually running inside a Rack::Builder.new {} block,
# therefore we need to call run *here*.
run Puppet::Application[:<% if scope.lookupvar('puppet::params::major_version') == "0.2" -%>puppetmasterd<% else -%>master<% end %>].run
