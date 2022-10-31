#
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

source /tmp/mariadbdemo/terraformDemo/.env


helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --set installCRDs=true
helm install nginx-ingress ingress-nginx/ingress-nginx --set controller.publishService.enabled=true  --namespace=$GITHUB_USER
kubectl create -f /tmp/mariadbdemo/terraformDemo/phpapp/production_issuer.yaml -n $GITHUB_USER
kubectl create -f /tmp/mariadbdemo/terraformDemo/phpapp/phpapp.yaml -n $GITHUB_USER