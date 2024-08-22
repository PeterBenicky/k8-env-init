# Kubernetes dashboard

## Deploy via argo cd
```
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: kubernetes-dashboard
  namespace: argocd
spec:
  project: default
  source:
    repoURL: 'https://github.com/PeterBenicky/k8-env-init.git'
    targetRevision: HEAD
    path: ./k8dashboard
  destination:
    server: 'https://kubernetes.default.svc'
    namespace: kubernetes-dashboard
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```
## How to access the dashboard
- forward port
```
kubectl port-forward svc/kubernetes-dashboard -n kubernetes-dashboard 9000:443 &
```
- get the token
```
kubectl -n kubernetes-dashboard create token kubernetes-dashboard
```

- call the web url, note it must be https
```
https://127.0.0.1:9000
```
