```
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: odooo
spec:
  destination:
    name: ''
    namespace: sss
    server: https://kubernetes.default.svc
  source:
    path: odoo
    repoURL: https://github.com/PeterBenicky/k8-env-init.git
    targetRevision: main
    helm:
      valueFiles:
        - values.yaml
  sources: []
  project: default
  syncPolicy:
    automated: null
```


psql -h localhost -U admin -d aaa

