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


kubectl exec -it postgres-589fc949fd-tnls6 -n odo13 -- /bin/bash



kubectl get pod hello-world-deployment-f7df546c9-p5vq8 -o jsonpath='{.status.containerStatuses[*].ports}'


hello-world-deployment-f7df546c9-p5vq8

kubectl port-forward service/argocd-server 8000:80 --address 0.0.0.0 -n argocd

kubectl port-forward service/<service-name> <local-port>:<service-port> --address 0.0.0.0



kubectl exec -it argocd-server-7c746df554-qdlr9 -- nslookup argocd-server.argocd.svc.cluster.local
