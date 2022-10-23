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

clear
echo "Welcome to this awesome demonstration."
echo "Before we can start I need to know your GitHub User Name?"
read GITHUB_USER

echo "Great, and now please tell me which email address you use for GitHub"
read GITHUB_EMAIL


#Test Repo's are forked.
forked_list_test

# Install git if not available

if [[ $OSTYPE == 'darwin'* ]]; then
  git version || brew install git
else
  git version || yum install -y git
fi


mkdir /tmp/mariadbdemo
cd /tmp/mariadbdemo
clone_repos

echo "export GITHUB_USER=$GITHUB_USER" >> /tmp/mariadbdemo/terraformDemo/.env
echo "export GITHUB_EMAIL=$GITHUB_EMAIL" >> /tmp/mariadbdemo/terraformDemo/.env
echo "export DO_REPO=registry.digitalocean.com/$GITHUB_USER-kdr-demo" >> /tmp/mariadbdemo/terraformDemo/.env
chmod 700 /tmp/mariadbdemo/terraformDemo/.env

#Set unique name for repos
sed -i.bak "s/dev/${GITHUB_USER}/" /tmp/mariadbdemo/terraformDemo/dev/main.tf

cd /tmp/mariadbdemo/terraformDemo
#Ensure local Git is configured with the entered variables.
git config user.name "$GITHUB_USER"
git config user.email "$GITHUB_EMAIL"


clear
read -p  "I am now going to try and install the required tools and utillites, press Y to continue." prompt
if [[ $prompt =~ [yY](es)* ]]
then

  if [[ $OSTYPE == 'darwin'* ]]; then
    make prepare-mac
  else
    make prepare-linux
  fi
else
  clear
  echo "Exiting, you will need to run this script again"
  exit 1
fi

clear
echo "Next I am going to build the Digital Ocean Infrastructure."
echo "To do this I will need a Digital Ocean API key, to get "
echo "the key, check this URL https://github.com/mariadb-kester/terraformDemo/blob/main/docs/files/digitalocean/apikey.md"
echo "Please enter the API key:"

read DO_API_KEY
echo "export TF_VAR_demo_digital_ocean_token=$DO_API_KEY" >> /tmp/mariadbdemo/terraformDemo/.env
make init-dev
make plan-dev
make apply-dev

clear
echo "Great, we can now start to build the containers and push them to your Private repository"
echo "But before we can do that, we need to configure CircleCI to build your Docker Containers"
echo "To do this we are going to need a CircleCI Personal Token"
echo "https://github.com/mariadb-kester/terraformDemo/blob/main/docs/files/circleci/personaltoken.md"
echo "Please enter the CircleCI Personal Token:"

read CIRCLECI_API
echo "export CIRCLECI_API=$CIRCLECI_API" >> .env

echo "Thanks! I also need your CircleCI User Name"
read CIRCLECI_USER
echo "export CIRCLECI_USER=$CIRCLECI_USER" >> .env

clear
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
echo "Getting Cluster ID"
doctl registry login
kube_id=`doctl kubernetes cluster get mariadb-kester-kdr-demo | tail -n 1 | awk -F" " ' { print $1} '`
doctl kubernetes cluster registry add mariadb-kester-kdr-demo
echo "Configuring CLI tool"
doctl kubernetes cluster kubeconfig save $kube_id
echo "Configuring HELM"
helm repo add mariadb-kester-repo https://mariadb-kester.github.io/helmChartsDatabaseDemo/
helm repo update
echo "Creating a Name Space for: " $GITHUB_USER
kubectl create ns $GITHUB_USER

helm install mariadb $GITHUB_USER/galera --namespace=$GITHUB_USER --set image.repository="$GITHUB_USER-kdr-demo/mariadb-maxscale"


