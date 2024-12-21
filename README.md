Avant de démarrer les commandes docker ou toutes autres commandes verifiez que vous êtes dans le répertoire app :

Si non généré par docker compose
généré image docker :

- docker build -t fastapi-app:latest .

créer les conteneurs avec docker :

- docker-compose up --build -d

autre commandes utiles pour docker :

- docker-compose stop
- docker-compose up
- docker-compose down

installation de minikube pour linux (si installation non réalisée)
- curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
- sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64


lancer le script création cluster minikube
- /app
- ./deploy.sh

savoir si les pods sont générés : 
- kubectl get pods

savoir si les nodes sont générés : 
- kubectl get nodes

supprimer les pods et nodes
- kubectl delete pods --all --all-namespaces
- kubectl get nodes -o name | xargs kubectl delete

sinon ciblé les pods et les nodes avec cette commande 
- kubectl delete pod <pod-name>
- kubectl delete node <node-name>

pour supprimer le volume de mysql si besoin :
- kubectl patch pvc mysql-pvc -p '{"metadata":{"finalizers":null}}'
- kubectl delete pvc mysql-pvc --force --grace-period=0 --ignore-not-found

verifiez que les package suivant sont installés

- fastapi

- unicorn

- mysql-connector-python 


sinon les installer avec les commandes : 

- pip install fastapi

- pip install mysql-connector-python

- pip install uvicorn
