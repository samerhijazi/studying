# Kubernetes-Subjects
* Setup: alias k=kubectl; KUBE_EDITOR="nano"; Autocomplation

* Cluster: 

* Pod: Label, Port, NodeSelector, Volumes, Secret, (Variables & Arguments & Commands), CPU, RAM, Logs, 

* Service: selector, Expose: (ClusterIP, NodePort, LoadBalancer), Port-forward

* Deployment: selector:matchLabels, Scale, Rollout 

* Label & Selector: See Pod, Deployment, Service

* Secrets: Pod, Volumes

* Job: backoffLimit (number of retries), activeDeadlineSeconds, completions, parallelism
* ConJob: schedule: "*/1 * * * *"

* Volume: emptyDir, hostPath, nfs, PV, PVC

* NetworkPolicy: 

* ConfigMap:

* ServiceAccounts: ClusterRole >>> RoleBinding >> Pod