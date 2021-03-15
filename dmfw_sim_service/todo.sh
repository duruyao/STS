#! /bin/bash

exe="dmfw_sim_service"

service="${exe}.service"

mkdir -p ../doc/

chmod +x build.sh

chmod +x code_count.sh

./code_count.sh

./build.sh

dpkg -r ${exe}

dpkg -i build/*.deb

systemctl start ${service}

systemctl status ${service}


