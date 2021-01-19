# k3sup cluster using Vagrant provisioning

Before running the vagrant, make sure to generate the public and private key and put it into keys folder

```
keys/
    |
    +--id_rsa
    |
    +--id_rsa.pub
```

To start the VMs run:

```
vagrant up
```

SSH into k3sup-host instance:

```
vagrant ssh k3sup-host 
```

Run k3sup-cluster.sh to install k3s and kubectl

```
bash k3sup-cluster.sh
```