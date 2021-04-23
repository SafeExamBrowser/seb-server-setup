Kustomization Base for Kubernetes
=================================

This kustomization directory provides a base which has to be extended by just a few
mandatory items:

 - environment variables like database connection information
 - an ingress definition for the GUI

 See the example directory for a usage introduction.


Versions
--------

The version of *kustomize* included in `kubectl` usually lags behind the standalone tool.
To get the full set of features mentioned in the documentation, get the standalone binary.

Links
-----

kustomize website: https://kustomize.io/
kustomize introduction: https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/
kustomize guides and reference: https://kubectl.docs.kubernetes.io/guides/
