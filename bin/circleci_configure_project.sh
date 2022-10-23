# A simple Script to configure the listed URL's within CircleCI

source /tmp/mariadbdemo/terraformDemo/.env
curl -X POST https://circleci.com/api/v1.1/project/gh/$CIRCLECI_USER/mariadbMaxscaleDocker/follow -H "Circle-Token: $CIRCLECI_API"
curl -X POST https://circleci.com/api/v1.1/project/gh/$CIRCLECI_USER/mariadbServerDocker/follow -H "Circle-Token: $CIRCLECI_API"
curl -X POST https://circleci.com/api/v1.1/project/gh/$CIRCLECI_USER/phpAppDocker/follow -H "Circle-Token: $CIRCLECI_API"

# Setup Environment Variables

curl -X POST --header "Content-Type: application/json" -d '{"name":"DO_ACCESS_TOKEN","value":"'$TF_VAR_demo_digital_ocean_token'"}' https://circleci.com/api/v1.1/project/gh/$CIRCLECI_USER/phpAppDocker/envvar -H "Circle-Token: $CIRCLECI_API"
curl -X POST --header "Content-Type: application/json" -d '{"name":"DO_ACCESS_TOKEN","value":"'$TF_VAR_demo_digital_ocean_token'"}' https://circleci.com/api/v1.1/project/gh/$CIRCLECI_USER/mariadbServerDocker/envvar -H "Circle-Token: $CIRCLECI_API"
curl -X POST --header "Content-Type: application/json" -d '{"name":"DO_ACCESS_TOKEN","value":"'$TF_VAR_demo_digital_ocean_token'"}' https://circleci.com/api/v1.1/project/gh/$CIRCLECI_USER/mariadbMaxscaleDocker/envvar -H "Circle-Token: $CIRCLECI_API"
curl -X POST --header "Content-Type: application/json" -d '{"name":"DO_REPO","value":"'$GITHUB_USER-kdr-demo'"}' https://circleci.com/api/v1.1/project/gh/$CIRCLECI_USER/phpAppDocker/envvar -H "Circle-Token: $CIRCLECI_API"
curl -X POST --header "Content-Type: application/json" -d '{"name":"DO_REPO","value":"'$GITHUB_USER-kdr-demo'"}' https://circleci.com/api/v1.1/project/gh/$CIRCLECI_USER/mariadbServerDocker/envvar -H "Circle-Token: $CIRCLECI_API"
curl -X POST --header "Content-Type: application/json" -d '{"name":"DO_REPO","value":"'$GITHUB_USER-kdr-demo'"}' https://circleci.com/api/v1.1/project/gh/$CIRCLECI_USER/mariadbMaxscaleDocker/envvar -H "Circle-Token: $CIRCLECI_API"
curl -X POST --header "Content-Type: application/json" -d '{"name":"MARIADB_TOKEN","value":"'$MARIADB_TOKEN'"}' https://circleci.com/api/v1.1/project/gh/$CIRCLECI_USER/mariadbServerDocker/envvar -H "Circle-Token: $CIRCLECI_API"
curl -X POST --header "Content-Type: application/json" -d '{"name":"MARIADB_TOKEN","value":"'$MARIADB_TOKEN'"}' https://circleci.com/api/v1.1/project/gh/$CIRCLECI_USER/mariadbMaxscaleDocker/envvar -H "Circle-Token: $CIRCLECI_API"
curl -X POST --header "Content-Type: application/json" -d '{"name":"MARIADB_SERVER_VERSION","value":"'$MARIADB_SERVER_VERSION'"}' https://circleci.com/api/v1.1/project/gh/$CIRCLECI_USER/mariadbServerDocker/envvar -H "Circle-Token: $CIRCLECI_API"
curl -X POST --header "Content-Type: application/json" -d '{"name":"MAXSCALE_VERSION","value":"'$MAXSCALE_VERSION'"}' https://circleci.com/api/v1.1/project/gh/$CIRCLECI_USER/mariadbMaxscaleDocker/envvar -H "Circle-Token: $CIRCLECI_API"


curl -X POST https://circleci.com/api/v2/project/gh/$CIRCLECI_USER/phpAppDocker/pipeline --header "Circle-Token: $CIRCLECI_API" --header "content-type: application/json" --data '{"branch":"main"}'
curl -X POST https://circleci.com/api/v2/project/gh/$CIRCLECI_USER/mariadbServerDocker/pipeline --header "Circle-Token: $CIRCLECI_API" --header "content-type: application/json" --data '{"branch":"main"}'
curl -X POST https://circleci.com/api/v2/project/gh/$CIRCLECI_USER/mariadbMaxscaleDocker/pipeline --header "Circle-Token: $CIRCLECI_API" --header "content-type: application/json" --data '{"branch":"main"}'