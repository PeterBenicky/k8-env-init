```
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: jenkins
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://charts.jenkins.io
    chart: jenkins
    targetRevision: "4.7.4"  # Specify the version you want to deploy, or use "latest"
    helm:
      values: |
        controller:
          serviceType: NodePort  # or LoadBalancer
          nodePort: 32000        # Optional: Only if serviceType is NodePort
          adminPassword: "admin" # Replace with a secure password or use a Secret
  destination:
    server: https://kubernetes.default.svc
    namespace: jenkins
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```
