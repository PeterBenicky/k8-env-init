```
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: odoo-server 
  namespace: argocd
spec:
  project: default
  source:
    repoURL: 'https://github.com/PeterBenicky/k8-env-init.git'
    targetRevision: HEAD
    path: ./odoo
  destination:
    server: 'https://kubernetes.default.svc'
    namespace: odoo-server
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```
