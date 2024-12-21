Avant de démarrer les commandes docker ou toutes autres commandes verifiez que vous êtes dans le répertoire app :

Sinon généré par docker compose
généré image docker :

- docker build -t fastapi-app:latest .

Créer les conteneurs avec docker :

- docker-compose up --build -d

Autre commandes utiles pour docker :

- docker-compose stop
- docker-compose up
- docker-compose down

Installation de minikube pour linux (si installation non réalisée)
- curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
- sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64


Lancer le script création cluster minikube
- /app
- ./deploy.sh

Savoir si les pods sont générés : 
- kubectl get pods

Savoir si les nodes sont générés : 
- kubectl get nodes

Supprimer les pods et nodes
- kubectl delete pods --all --all-namespaces
- kubectl get nodes -o name | xargs kubectl delete

Sinon ciblé les pods et les nodes avec cette commande 
- kubectl delete pod <pod-name>
- kubectl delete node <node-name>

Pour supprimer le volume de mysql si besoin :
- kubectl patch pvc mysql-pvc -p '{"metadata":{"finalizers":null}}'
- kubectl delete pvc mysql-pvc --force --grace-period=0 --ignore-not-found

Verifiez que les package suivant sont installés

- fastapi

- unicorn

- mysql-connector-python 


Sinon les installer avec les commandes : 

- pip install fastapi
- pip install uvicorn
- pip install mysql-connector-python

- pip install fastapi

- pip install mysql-connector-python

- pip install uvicorn
