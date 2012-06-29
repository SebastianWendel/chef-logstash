maintainer        "Sebastian Wendel, SourceIndex IT-Services"
maintainer_email  "packages@sourceindex.de"
license           "Apache 2.0"
description       "Installs and configures logstash logfile aggregator"
version           "0.0.0"
recipe            "logstash", "Installs and configures logstash"

%w{redhat centos ubuntu debian}.each do |os|
  supports os
end

depends "java"
