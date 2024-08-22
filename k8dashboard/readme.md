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
