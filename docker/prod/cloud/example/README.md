Kustomization Final Deployment Example
======================================

**Not working yet**

Note on Secrets in Git
--------------

Kubernetes secrets should never get into Git unencrpyted. This is only an example.
One solution to encrypt secrets for Git and decrypt it during deployment into the
cluster is [SealedSecrets](https://github.com/bitnami-labs/sealed-secrets). 

Kustomization Flow
------------------

The kustomization file first sets common values which are modified most: image version
and replica count.

It then uses the base config published in this repository and extends it to
a production ready deployment.

Add Ingress
-----------

Ingresses depend on the particular Kubernetes environment an application gets deployed.
You probably have to adjust almost anything shown here.

Set Environment Variables
-------------------------

Most of the configurable settings can be set by environment variable. 

To create the `app-env` secret, a command like this can be used to convert the secret value(s)
to base64 and create a valid secret definition:

```
kubectl create secret generic --from-literal=SECRET=b5cb0f32f72ca06056146c0c752f65a3488b09a4 --dry-run=client app-env -o json >app-env.json
```

If you have SealedSecrets deployed, encrypt the data just generated:

```
kubeseal --format=yaml <app-env.json -n sealed-secrets --namespace=local-system --scope=namespace-wide >app-env.yml
```

Usage
--------------------
to distribute "SebSever Cloud" to Kubernetes run:
``` 
kustomize build . | kubectl apply -f -
```
