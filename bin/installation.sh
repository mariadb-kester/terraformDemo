#!/bin/bash
# /*
#  * Copyright (c) 2022.
#  *
#  *  - All Rights Reserved
#  *  Unauthorized copying of this project, via any medium is strictly prohibited
#  *  Proprietary and confidential
#  *  Written by Kester Riley <kesterriley@hotmail.com>
#  *
#  *  Please refer to the Projects LICENSE file for further details.
#  *
#  */
#

function clone_repos(){
  git clone https://github.com/$GITHUB_USER/terraformDemo.git
#  git clone https://github.com/$GITHUB_USER/phpAppDocker.git
#  git clone https://github.com/$GITHUB_USER/mariadbMaxscaleDocker.git
#  git clone https://github.com/$GITHUB_USER/mariadbServerDocker.git
#  git clone https://github.com/$GITHUB_USER/helmChartsDatabaseDemo
}

function test_forked_urls() {
  STATUS_CODE=$(curl \
      --output /dev/null \
      --silent \
      --write-out "%{http_code}" \
      "$1")

  if (( STATUS_CODE == 200 ))
  then
    echo "$1" is forked correctly.
  else
    echo "$1! Is Not Available. Please check you entered your username correctly and forked the required repositories.
    Expected
    200, got $STATUS_CODE"
    exit 1
  fi
}

function forked_list_test() {
  test_forked_urls https://github.com/$GITHUB_USER/terraformDemo
  test_forked_urls https://github.com/$GITHUB_USER/phpAppDocker
  test_forked_urls https://github.com/$GITHUB_USER/mariadbMaxscaleDocker
  test_forked_urls https://github.com/$GITHUB_USER/mariadbServerDocker
}
function getUserDetails() {
  clear
  echo "Welcome to this awesome demonstration."
  echo "Before we can start I need to know your GitHub User Name?"
  read GITHUB_USER
  echo "Great, and now please tell me which email address you use for GitHub:"
  read GITHUB_EMAIL

  clear
  echo "We now need your MariaDB Enterprise Token, you can get it from here:"
  echo "https://customers.mariadb.com/downloads/token/"
  echo "Please enter your token:"
  read MARIADB_TOKEN

  clear
  echo "Next we need a Digital Ocean API key, to get "
  echo "the key, check this URL https://github.com/mariadb-kester/terraformDemo/blob/main/docs/files/digitalocean/apikey.md"
  echo "Please enter the API key:"
  read DO_API_KEY

  clear
  echo "Great, to connect to CircleCI I need your CircleCI Personal Token"
  echo "https://github.com/mariadb-kester/terraformDemo/blob/main/docs/files/circleci/personaltoken.md"
  echo "Please enter the CircleCI Personal Token:"
  read CIRCLECI_API

  echo "Thanks! I also need your CircleCI User Name:"
  read CIRCLECI_USER

  clear
  echo "Which version of MariaDB would you like to install?"
  read MARIADB_SERVER_VERSION

  echo "and the version of MaxScale?"
  read MAXSCALE_VERSION


}

set_env_variables() {
    echo "export GITHUB_USER=$GITHUB_USER" >> /tmp/mariadbdemo/terraformDemo/.env
    echo "export GITHUB_EMAIL=$GITHUB_EMAIL" >> /tmp/mariadbdemo/terraformDemo/.env
    echo "export DO_REPO=registry.digitalocean.com/$GITHUB_USER-kdr-demo" >> /tmp/mariadbdemo/terraformDemo/.env
    echo "export MARIADB_TOKEN=$MARIADB_TOKEN" >> /tmp/mariadbdemo/terraformDemo/.env
    echo "export MARIADB_SERVER_VERSION=$MARIADB_SERVER_VERSION" >> /tmp/mariadbdemo/terraformDemo/.env
    echo "export MAXSCALE_VERSION=$MAXSCALE_VERSION" >> /tmp/mariadbdemo/terraformDemo/.env
    echo "export TF_VAR_demo_digital_ocean_token=$DO_API_KEY" >> /tmp/mariadbdemo/terraformDemo/.env
    echo "export CIRCLECI_API=$CIRCLECI_API" >> /tmp/mariadbdemo/terraformDemo/.env
    echo "export CIRCLECI_USER=$CIRCLECI_USER" >> /tmp/mariadbdemo/terraformDemo/.env

    chmod 700 /tmp/mariadbdemo/terraformDemo/.env
}

mkdir /tmp/mariadbdemo
cd /tmp/mariadbdemo

if [ -d ~/.kube/cache ]
then
  rm -rf ~/.kube/cache
fi

getUserDetails

#Test Repo's are forked.
forked_list_test

# Install git if not available

if [[ $OSTYPE == 'darwin'* ]]; then
  git version || brew install git
else
  git version || yum install -y git
fi



clone_repos
set_env_variables


#Set unique name for repos
sed -i.bak "s/dev/${GITHUB_USER}/" /tmp/mariadbdemo/terraformDemo/dev/main.tf

cd /tmp/mariadbdemo/terraformDemo
#Ensure local Git is configured with the entered variables.
git config user.name "$GITHUB_USER"
git config user.email "$GITHUB_EMAIL"


clear
echo "I am now going to try and install the required tools and utilities"


if [[ $OSTYPE == 'darwin'* ]]; then
  make prepare-mac
else
  make prepare-linux
fi


clear
echo "Next I am going to build the Digital Ocean Infrastructure."

make init-dev
make plan-dev
make apply-dev

clear
echo "Now that the infrastructure is built, I am going to build your Docker Containers and push them to your Private repository "


make circleci-configure-projects
clear
echo "Sit Back, Relax! I will need three or four minutes to build the containers for you."
echo "You can check the progress on https://app.circleci.com/pipelines/"
sleep 210
clear
echo "OK - if all has gone well, our Infrastructure is built, our CI system is configured and working"
echo "and our containers are ready to use."
echo "We are going to use HELM to build the database servers and MaxScale, to which we will download"
echo "the training database and apply it."

echo ""

#get Kubernetes ID
echo "Configuring doctl tool"
doctl auth init -t $DO_API_KEY
echo "Getting Cluster ID"
doctl registry login
kube_id=`doctl kubernetes cluster get mariadb-kester-kdr-demo | tail -n 1 | awk -F" " ' { print $1} '`
doctl kubernetes cluster registry add mariadb-kester-kdr-demo
echo "Configuring CLI tool"
doctl kubernetes cluster kubeconfig save $kube_id
echo "Configuring HELM"
helm repo add mariadb-kester-repo https://mariadb-kester.github.io/helmChartsDatabaseDemo/
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add jetstack https://charts.jetstack.io
helm repo update
echo "Creating a Name Space for: " $GITHUB_USER
kubectl create ns $GITHUB_USER

chmod 777 /tmp/mariadbdemo/terraformDemo/bin/install_phpapp.sh
/tmp/mariadbdemo/terraformDemo/bin/install_phpapp.sh &>/tmp/phpapp-install.log &



#helm install mariadb $GITHUB_USER-repo/galera --namespace=$GITHUB_USER --set maxscale.image.repository=registry.digitalocean.com/$GITHUB_USER-kdr-demo/mariadb-maxscale --set image.repository=$GITHUB_USER-kdr-demo/mariadb-es
helm install mariadb mariadb-kester-repo/masterreplica --namespace=$GITHUB_USER --set maxscale.image.repository=registry.digitalocean.com/$GITHUB_USER-kdr-demo/mariadb-maxscale --set image.repository=$GITHUB_USER-kdr-demo/mariadb-es

clear
echo "Please wait while I build the database servers, I will check the status in four minutes"
sleep 240
#For masterreplica mariadb-masterreplica-2
#For galera mariadb-galera-2
while [ "$(kubectl get pod -n mariadb-kester mariadb-masterreplica-2 --output="jsonpath={.status.containerStatuses[*].ready}" | cut -d' ' -f2)" != "true" ]; do
   sleep 30
   echo "Waiting for Database Service to be ready."
done

clear
echo "Great, we are now installing your databases, this takes a bit of time, as it is building and installing Two
MaxScale Servers, three Galera Servers and all the required infrastructure. "

kubectl cluster-info
kubectl exec -it -n $GITHUB_USER `kubectl get pods -n $GITHUB_USER | grep active | awk -F" " ' { print $1 } '` -- maxctrl list servers

echo "Success I can login!"
echo "... I am now going to load the training Database"
echo "Connecting to the Database Server"

# For async kubectl port-forward svc/masteronly -n $GITHUB_USER 3306:3306 &
# For galera kubectl port-forward svc/mariadb-galera-masteronly -n $GITHUB_USER 3306:3306 &
kubectl port-forward svc/masteronly -n $GITHUB_USER 3306:3306 &
kubePID=$!
sleep 5
cd /tmp/mariadbdemo/terraformDemo/data
echo "Creating Database"
mariadb -uMARIADB_USER -pmariadb -h 127.0.0.1 -P3306 -e "CREATE DATABASE employees"
echo "Loading Data in to Database...."
mariadb -uMARIADB_USER -pmariadb -h 127.0.0.1 -P3306 employees < dump.sql
cd /tmp/mariadbdemo/terraformDemo

echo "Excellent that is done..."
echo "... I am just going to check there are records in the database"
mariadb -uMARIADB_USER -pmariadb -h 127.0.0.1 -P3306 -e "SELECT COUNT(*) FROM employees.employees"
kill $kubePID
kubectl exec -it -n $GITHUB_USER `kubectl get pods -n $GITHUB_USER | grep active | awk -F" " ' { print $1 } '` -- maxctrl list servers

clear
while [ "$(kubectl describe services -n $GITHUB_USER nginx-ingress-ingress-nginx-controller |awk '/LoadBalancer Ingress/{print $3}')" = "" ]; do
   sleep 30
   echo "Waiting for load balancer Service to be ready. This may take awhile."
done
clear

lbip=$(kubectl describe services -n $GITHUB_USER nginx-ingress-ingress-nginx-controller |awk '/LoadBalancer Ingress/{print $3}')
doctl compute domain create kester.pro
doctl compute domain records create kester.pro --record-type A --record-data ${lbip} --record-ttl 3600 --record-name ${GITHUB_USER}
doctl compute domain records list kester.pro
kubectl port-forward svc/gui-active -n $GITHUB_USER 8989:8989 &

echo "Browse to https://${GITHUB_USER}.kester.pro"
echo "MaxScale is exposed locally: localhost:8989"


echo "This is how you connect to it - I am done"