#!/bin/bash

# Vérifier que kubectl est installé
command -v kubectl >/dev/null 2>&1 || { echo >&2 "kubectl n'est pas installé. Abandon."; exit 1; }

# Vérifier que vous êtes connecté à un cluster Kubernetes
kubectl cluster-info >/dev/null 2>&1 || { echo >&2 "Vous n'êtes pas connecté à un cluster Kubernetes. Abandon."; exit 1; }

echo "Démarrage du déploiement Kubernetes..."

# Appliquer le PVC pour MySQL
echo "Application du PVC pour la base de données..."
kubectl apply -f k8s/mysql-pvc.yaml

# Appliquer les secrets pour la base de données (si nécessaire)
# kubectl apply -f kubernetes/mysql-secrets.yaml

# Appliquer les déploiements pour l'application et la base de données
echo "Application du déploiement pour la base de données..."
kubectl apply -f k8s/deployment-db.yaml

echo "Application du déploiement pour l'application..."
kubectl apply -f k8s/deployment-app.yaml

# Appliquer les services pour l'application et la base de données
echo "Application du service pour la base de données..."
kubectl apply -f k8s/service-db.yaml

echo "Application du service pour l'application..."
kubectl apply -f k8s/service-app.yaml

# Vérifier l'état des déploiements
echo "Vérification de l'état des pods et services..."
kubectl get pods
kubectl get svc

echo "Déploiement terminé !"
