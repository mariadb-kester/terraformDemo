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
  git clone https://github.com/$GITHUB_USER/phpAppDocker.git
  git clone https://github.com/$GITHUB_USER/mariadbMaxscaleDocker.git
  git clone https://github.com/$GITHUB_USER/mariadbServerDocker.git
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
chmod 700 /tmp/mariadbdemo/terraformDemo/.env

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

