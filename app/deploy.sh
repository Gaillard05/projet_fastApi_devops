#!/bin/bash

# Définitions des couleurs pour la sortie terminal
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # Pas de couleur

# Étape 1: Vérification si Minikube est démarré, sinon démarrez-le
echo -e "${GREEN}Vérification de Minikube...${NC}"
minikube_status=$(minikube status | grep -i 'host: Running' | wc -l)

if [ "$minikube_status" -eq 0 ]; then
  echo -e "${GREEN}Minikube n'est pas démarré. Démarrage de Minikube avec Docker comme driver...${NC}"
  minikube start --driver=docker || { echo -e "${RED}Erreur lors du démarrage de Minikube. Vérifiez les logs.${NC}"; exit 1; }
else
  echo -e "${GREEN}Minikube est déjà démarré.${NC}"
fi

# Étape 2: Supprimer les ressources Kubernetes existantes (Déploiements, Services)
echo -e "${GREEN}Suppression des ressources Kubernetes existantes...${NC}"

kubectl delete -f fast-api-deployment.yml --ignore-not-found || echo -e "${RED}Erreur lors de la suppression du déploiement FastAPI. Ignoré.${NC}"
kubectl delete -f mysql-deployment.yml --ignore-not-found || echo -e "${RED}Erreur lors de la suppression du déploiement MySQL. Ignoré.${NC}"
kubectl delete -f fast-api-service.yml --ignore-not-found || echo -e "${RED}Erreur lors de la suppression du service FastAPI. Ignoré.${NC}"
kubectl delete -f mysql-service.yml --ignore-not-found || echo -e "${RED}Erreur lors de la suppression du service MySQL. Ignoré.${NC}"

# Étape 3: Appliquer les nouveaux fichiers YAML pour FastAPI et MySQL
echo -e "${GREEN}Application des fichiers Kubernetes...${NC}"
kubectl apply -f fast-api-deployment.yml
kubectl apply -f mysql-deployment.yml
kubectl apply -f fast-api-service.yml
kubectl apply -f mysql-service.yml

# Étape 4: Vérification de l'état des Pods
echo -e "${GREEN}Vérification de l'état des Pods...${NC}"
kubectl get pods

# Étape 5: Vérification de l'état des Services
echo -e "${GREEN}Vérification de l'état des Services...${NC}"
kubectl get svc

# Étape 6: Vérification de l'état des Pods pour s'assurer qu'ils sont prêts
echo -e "${GREEN}Vérification que les Pods sont prêts...${NC}"
kubectl wait --for=condition=ready pod -l app=fast-api --timeout=600s || { echo -e "${RED}Les Pods de l'application FastAPI ne sont pas prêts. Vérifiez les logs avec 'kubectl logs'${NC}"; exit 1; }
kubectl wait --for=condition=ready pod -l app=mysql-db --timeout=600s || { echo -e "${RED}Les Pods de la base de données MySQL ne sont pas prêts. Vérifiez les logs avec 'kubectl logs'${NC}"; exit 1; }

# Étape 7: Ouvrir les services via Minikube
echo -e "${GREEN}Ouverture des services via Minikube...${NC}"
minikube service fast-api-service --url &
minikube service mysql-service --url &

# Étape 8: Vérification de l'adresse IP de Minikube pour accéder aux services
MINIKUBE_IP=$(minikube ip)
echo -e "${GREEN}Adresse IP de Minikube: ${MINIKUBE_IP}${NC}"

# Étape 9: Test avec curl pour vérifier que les services répondent
echo -e "${GREEN}Test de l'accès à FastAPI...${NC}"
curl http://$MINIKUBE_IP:8000 || echo -e "${RED}Erreur de connexion à l'application FastAPI. Vérifiez les logs avec 'kubectl logs'${NC}"

# Test avec curl pour MySQL (si un client est configuré sur votre machine)
echo -e "${GREEN}Test de l'accès à MySQL...${NC}"
curl http://$MINIKUBE_IP:3306 || echo -e "${RED}Erreur de connexion à MySQL. Vérifiez les logs avec 'kubectl logs'${NC}"

echo -e "${GREEN}Déploiement terminé !${NC}"
