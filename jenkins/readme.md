```
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: devops-tools
  namespace: argocd
spec:
  project: default
  source:
    repoURL: 'https://github.com/PeterBenicky/k8-env-init.git'
    targetRevision: HEAD
    path: ./jenkins
  destination:
    server: 'https://kubernetes.default.svc'
    namespace: devops-tools
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```
# Access
localhost:32000
pasword is in the log.
