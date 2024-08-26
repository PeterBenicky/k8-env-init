```
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: jenkins
  namespace: argocd
spec:
  project: default
  source:
    repoURL: 'https://github.com/PeterBenicky/k8-env-init.git'
    targetRevision: HEAD
    path: ./jenkins
  destination:
    server: 'https://kubernetes.default.svc'
    namespace: jenkins
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```
