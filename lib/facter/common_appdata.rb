require 'facter'
require 'win32/dir'
Facter.add(:common_appdata) do
  confine :operatingsystem => :windows
  setcode do
    Dir::COMMON_APPDATA
  end
end
