Kustomization Final Deployment Example
======================================

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

Variables sebserver webservice
------------------------------
- `JAVA_HEAP_MIN`: Minimum heap memory space given to the JVM process
- `JAVA_HEAP_MAX`: Maximum heap memory space given to the JVM process
- `sebserver_password`: SEB Server internal password for encryption. NOTE: This password must be the same vor all webservice and gui instances
- `spring_profiles_active`: SEB Server profiles. For a productive webservice setup "ws,prod-ws,prod"
- `spring_datasource_password`: password for MariaDB database
- `spring_datasource_username`: MariaDB user name
- `datastore_mariadb_server_address`: MariaDB server hostname
- `datastore_mariadb_server_port`: MariaDB port
- `sebserver_webservice_http_external_scheme`: Webservice external URL scheme (http/https)
- `sebserver_webservice_http_external_servername`: Webservice external URL host name
- `sebserver_webservice_http_external_port`: Webservice external URL port (empty for default http(80) https(443))
- `sebserver_webservice_autologin_url`: External URL from where the sebserver guiservice is available. See also `sebserver_gui_http_external_servername`
- `sebserver_feature_exam_seb_screenProctoring_bundled_url`: The URL on which the screen proctoring webservice is externally available
- `sps_sebserver_client_secret`: SEB Servers client secret to connect to screen proctoring service. This must match with the sebserver_client_secret setting in screen proctoring (sps) webservice
- `sps_sebserver_password`: SEB Servers screen proctoring service maintenance account password. This must match with the same setting in screen proctoring (sps) webservice

Variables sebserver guiservice
------------------------------

- `JAVA_HEAP_MIN`: Minimum heap memory space given to the JVM process
- `JAVA_HEAP_MAX`: Maximum heap memory space given to the JVM process
- `sebserver_password` : SEB Server internal password for encryption. NOTE: This password must be the same vor all webservice and gui instances
- `spring_profiles_active` : SEB Server profiles. For a productive guiservice setup "gui,prod-gui,prod"
- `sebserver_gui_http_external_scheme`: Guiservice external URL scheme (http/https)
- `sebserver_gui_http_external_servername`: Guiservice external URL host name
- `sebserver_gui_http_external_port`: Guiservice external URL port (empty for default http(80) https(443))
- `sebserver_gui_http_webservice_scheme`: Webservice external connection URL scheme (http/https)
- `sebserver_gui_http_webservice_servername` : Webservice external connection URL host name.
- `sebserver_gui_http_webservice_port` : Webservice external connection URL port (empty for default http(80) https(443))

Variables screen proctoring (sps) webservice
--------------------------------------------

- `JAVA_HEAP_MIN`: Minimum heap memory space given to the JVM process
- `JAVA_HEAP_MAX`: Maximum heap memory space given to the JVM process
- `sebserver_password`: SEB Server internal password for encryption. NOTE: This password must be the same vor all webservice and gui instances
- `spring_profiles_active`: SEB Server profiles. For a productive webservice setup "prod"
- `spring_datasource_password`: password for MariaDB database
- `spring_datasource_username`: MariaDB user name
- `datastore_mariadb_server_address`: MariaDB server hostname
- `datastore_mariadb_server_port`: MariaDB port
- `sps_data_store_adapter`: Image (Screenshots) data store adapter. "FULL_RDBMS" for storing images into DB or "S3_RDBMS" for S3 compatible storage
- `sps_webservice_http_external_scheme`: Webservice external URL scheme (http/https)
- `sps_webservice_http_external_servername`: Webservice external URL host name
- `sps_webservice_http_external_port`: Webservice external URL port (empty for default http(80) https(443))
- `sps_gui_redirect_url`: SPS GUI external URL used for redirect and autologin link creation
- `sebserver_client_secret`: Client secret for SEB Server binding. SEB Server must use this to connect to screen proctoring service. See also sps_sebserver_client_secret
- `spsgui_client_secret`: Client secret for screen proctoring GUI service binding. SPS GUI service must use this to connect to the SPS webservice
- `sps_init_sebserveraccount_password`: Password for the SEB Server user account that is used by SEB Server to manage SPS service data. This account is initially generated by the SPS service if it doesn't exist

Variables sebserver screen proctoring (sps) guiservice
------------------------------------------------------

- `NODE_ENV`: Node environment profile. "prod" for production setup
- `LOG_LEVEL`: Log level. Default is "info"
- `SERVER_PORT`: Internal service port mapping. Default is "3000"
- `VITE_SERVER_URL`: The external URL of the VITE server
- `VITE_SERVER_PORT`: The port mapping for above VITE server URL if needed. If not needed (default ports http/https) this can be empty
- `PROCTOR_SERVER_URL`: The external URL of the screen proctoring webservice. This can also be internal URL connection to sps-webservice
- `PROCTOR_SERVER_PORT`: Port mapping for above screen proctoring webservice URL if needed. If not needed (default ports http/https) this can be empty
- `PROCTOR_DEFAULT_URL`: Default webservice root API endpoint. Usually "/admin-api/v1"
- `PROCTOR_SERVER_USERNAME`: Client id name for sps-guiservice to connect to sps-webservice. Default is "spsGuiClient"
- `PROCTOR_SERVER_PASSWORD`: Client secret for sps-guiservice to connect to sps-webservice. Must match with spsgui_client_secret
- `SEB_SERVER_INTEGRATED_MODE`: Integration mode. Default is true


Usage
--------------------
to distribute "SebSever Cloud" to Kubernetes run:
``` 
kustomize build . | kubectl apply -f -
```
