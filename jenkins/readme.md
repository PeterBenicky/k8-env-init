apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: jenkins
  namespace: argocd
spec:
  destination:
    name: ''
    namespace: jenkins
    server: https://kubernetes.default.svc
  source:
    path: ''
    repoURL: https://charts.jenkins.io
    targetRevision: 5.5.9
    chart: jenkins
    helm:
      values: |
        controller:
          serviceType: NodePort  # or LoadBalancer
          nodePort: 32000        # Optional: Only if serviceType is NodePort
          adminPassword: "admin" # Replace with a secure password or use a Secret
  sources: []
  project: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
