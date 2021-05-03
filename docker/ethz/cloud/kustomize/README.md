Kustomization Base for Kubernetes
=================================

This kustomization directory provides a base which has to be extended by just a few
mandatory items:

 - environment variables like database connection information
 - an ingress definition for the GUI

 See the example directory for a usage introduction.

Variables webservice
--------------------

 - `spring_profiles_active` : SEB Server profiles. For a productive webservice setup "ws,prod-ws,prod"
 - `sebserver_password` | `SEBSERVER_PWD` : SEB Server internal password for encryption. NOTE: This password must be the same vor all webservice and gui instances
 - `spring_datasource_password` | `DB_SA_PWD`: password for MariaDB database
 - `spring_datasource_username`: MariaDB user name
 - `datastore_mariadb_server_address`: MariaDB server hostname
 - `datastore_mariadb_server_port`: MariaDB port
 - `sebserver_webservice_http_external_scheme`: Webservice external URL scheme (http/https)
 - `sebserver_webservice_http_external_servername`: Webservice external URL host name
 - `sebserver_webservice_http_external_port`: Webservice external URL port (empty for default http(80) https(443))
 
 
 Variables guiservice
---------------------

 - `spring_profiles_active` : SEB Server profiles. For a productive guiservice setup "gui,prod-gui,prod"
 - `sebserver_password` | `SEBSERVER_PWD` : SEB Server internal password for encryption. NOTE: This password must be the same vor all webservice and gui instances
 - `sebserver_gui_http_external_scheme`: Guiservice external URL scheme (http/https)
 - `sebserver_gui_http_external_servername`: Guiservice external URL host name
 - `sebserver_gui_http_external_port`: Guiservice external URL port (empty for default http(80) https(443))
 - `sebserver_gui_http_webservice_scheme`: Webservice connection URL scheme (http/https)
 - `sebserver_gui_http_webservice_servername` : Webservice connection URL host name
 - `sebserver_gui_http_webservice_port` : Webservice connection URL port (empty for default http(80) https(443))


Versions
--------

The version of *kustomize* included in `kubectl` usually lags behind the standalone tool.
To get the full set of features mentioned in the documentation, get the standalone binary.

Links
-----

kustomize website: https://kustomize.io/
kustomize introduction: https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/
kustomize guides and reference: https://kubectl.docs.kubernetes.io/guides/
