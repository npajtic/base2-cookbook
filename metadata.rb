name             'base2'
maintainer       'base2Services'
maintainer_email 'itsupport@base2services.com'
license          'All rights reserved'
description      'base2Services standard operating environment'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

["amazon", "centos", "redhat", "ubuntu"].each do |os|
  supports os
end

depends 'ntp'
depends 'users'
depends 'timezone-ii'
depends 'apt'
depends 'yum'
depends 'resource-control'
