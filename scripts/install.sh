#!/bin/bash
sudo apt-add-repository ppa:ansible/ansible
sudo apt -y update
sudo apt -y install ansible unzip
# sudo wget https://deb.nodesource.com/setup_${node_version}.x --output-document /tmp/node_setup.sh
# sudo chmod a+x /tmp/node_setup.sh
# sudo sh /tmp/node_setup.sh
# sudo apt -y install nodejs nginx
# sudo npm install
# sudo npm install -g @angular/cli
# sudo sed -i -- 's#'"http://localhost:9966/petclinic/api/"'#'"${be_lb_dns}"'#g' ./src/environments/environment.prod.ts
# cat ./src/environments/environment.prod.ts
# ng build --prod --base-href=/ --deploy-url=/