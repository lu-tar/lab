# K8S

## kubeadm setup
- https://devopscube.com/setup-kubernetes-cluster-kubeadm/
- https://cri-o.io/
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/


## Microk8s

### Master
    1  sudo apt update
    2  sudo apt install snapd
    3  sudo snap install snapd
    4  sudo snap install microk8s --classic
    5  microk8s status
    6  sudo usermod -a -G microk8s luca
    7  sudo shutdown -r now
    8  microk8s status
    9  microk8s add-node
   10  microk8s kubectl get nodes
   11  microk8s kubectl get nodes --show-labels
   12  history > note.txt

### Workers
luca@microk8s-wk-1:~$ cat note.txt
    1  history
    2  sudo apt update
    3  sudo apt install snapd
    4  sudo snap install snapd
    5  sudo snap install microk8s --classic
    6  sudo usermod -a -G microk8s luca
    7  sudo shutdown -r now
    8  microk8s join 10.0.5.2:25000/0731d9c752532e122218e1e77392ba4a/4b5d18b3c81e --worker
    9  history > note.txt

### Local link to image repo (solo per test senza usare Docker Hub)
   65  sudo docker images
   66  cat deployment.yaml
   67  sudo docker save flask-app > flask-app.tar
   68  ls
   69  microk8s ctr image import flask-app.tar
   70  microk8s ctr images list
   71  microk8s ctr images list | grep flask
   72  history 3
   73  history 10
   74  history 10 >> note.txt

### service vs deployment K8s

- deployment: pod lifecycle
- service: loab balancing and networking

- create namespace 
microk8s kubectl create namespace flask-app

- Apply the deployment and service
microk8s kubectl apply -f deployment.yaml -n flask-app
microk8s kubectl apply -f service.yaml -n flask-app

microk8s kubectl get pods -n flask-app


