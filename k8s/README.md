# Create Pod

Add secret for docker auth

```shell
kubectl apply -f k8s/dockerauth.yaml
```

Create config map

```shell
kubectl apply -f k8s/app-config.yaml
```

Create devops secret

```shell
kubectl apply -f k8s/devopssecret.yaml
```

Create the pod

```shell
kubectl apply -f k8s/testpod.yaml
```

OR all together

```shell
kubectl apply -f k8s
```