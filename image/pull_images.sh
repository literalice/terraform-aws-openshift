#!/bin/bash

tag=v$OPENSHIFT_VERSION

echo OPENSHIFT_VERSION: $OPENSHIFT_VERSION
echo tag: $tag

sudo docker pull registry.access.redhat.com/openshift3/csi-attacher:$tag
sudo docker pull registry.access.redhat.com/openshift3/csi-driver-registrar:$tag
sudo docker pull registry.access.redhat.com/openshift3/csi-livenessprobe:$tag
sudo docker pull registry.access.redhat.com/openshift3/csi-provisioner:$tag
sudo docker pull registry.access.redhat.com/openshift3/efs-provisioner:$tag
sudo docker pull registry.access.redhat.com/openshift3/image-inspector:$tag
sudo docker pull registry.access.redhat.com/openshift3/local-storage-provisioner:$tag
sudo docker pull registry.access.redhat.com/openshift3/manila-provisioner:$tag
sudo docker pull registry.access.redhat.com/openshift3/ose-ansible:$tag
sudo docker pull registry.access.redhat.com/openshift3/ose-cli:$tag
sudo docker pull registry.access.redhat.com/openshift3/ose-cluster-capacity:$tag
sudo docker pull registry.access.redhat.com/openshift3/ose-deployer:$tag
sudo docker pull registry.access.redhat.com/openshift3/ose-descheduler:$tag
sudo docker pull registry.access.redhat.com/openshift3/ose-docker-builder:$tag
sudo docker pull registry.access.redhat.com/openshift3/ose-docker-registry:$tag
sudo docker pull registry.access.redhat.com/openshift3/ose-egress-dns-proxy:$tag
sudo docker pull registry.access.redhat.com/openshift3/ose-egress-http-proxy:$tag
sudo docker pull registry.access.redhat.com/openshift3/ose-egress-router:$tag
sudo docker pull registry.access.redhat.com/openshift3/ose-f5-router:$tag
sudo docker pull registry.access.redhat.com/openshift3/ose-haproxy-router:$tag
sudo docker pull registry.access.redhat.com/openshift3/ose-hyperkube:$tag
sudo docker pull registry.access.redhat.com/openshift3/ose-hypershift:$tag
sudo docker pull registry.access.redhat.com/openshift3/ose-keepalived-ipfailover:$tag
sudo docker pull registry.access.redhat.com/openshift3/ose-pod:$tag
sudo docker pull registry.access.redhat.com/openshift3/ose-docker-builder:$tag
sudo docker pull registry.access.redhat.com/openshift3/ose-node-problem-detector:$tag
sudo docker pull registry.access.redhat.com/openshift3/ose-recycler:$tag
sudo docker pull registry.access.redhat.com/openshift3/ose-web-console:$tag
sudo docker pull registry.access.redhat.com/openshift3/ose-node:$tag
sudo docker pull registry.access.redhat.com/openshift3/ose-control-plane:$tag
sudo docker pull registry.access.redhat.com/openshift3/registry-console:$tag
sudo docker pull registry.access.redhat.com/openshift3/snapshot-controller:$tag
sudo docker pull registry.access.redhat.com/openshift3/snapshot-provisioner:$tag
sudo docker pull registry.access.redhat.com/rhel7/etcd

sudo docker pull registry.access.redhat.com/openshift3/logging-auth-proxy:$tag
sudo docker pull registry.access.redhat.com/openshift3/logging-curator:$tag
sudo docker pull registry.access.redhat.com/openshift3/logging-elasticsearch:$tag
sudo docker pull registry.access.redhat.com/openshift3/logging-eventrouter:$tag
sudo docker pull registry.access.redhat.com/openshift3/logging-fluentd:$tag
sudo docker pull registry.access.redhat.com/openshift3/logging-kibana:$tag
sudo docker pull registry.access.redhat.com/openshift3/oauth-proxy:$tag
sudo docker pull registry.access.redhat.com/openshift3/metrics-cassandra:$tag
sudo docker pull registry.access.redhat.com/openshift3/metrics-hawkular-metrics:$tag
sudo docker pull registry.access.redhat.com/openshift3/metrics-hawkular-openshift-agent:$tag
sudo docker pull registry.access.redhat.com/openshift3/metrics-heapster:$tag
sudo docker pull registry.access.redhat.com/openshift3/metrics-schema-installer:$tag
sudo docker pull registry.access.redhat.com/openshift3/prometheus:$tag
sudo docker pull registry.access.redhat.com/openshift3/prometheus-alert-buffer:$tag
sudo docker pull registry.access.redhat.com/openshift3/prometheus-alertmanager:$tag
sudo docker pull registry.access.redhat.com/openshift3/prometheus-node-exporter:$tag
sudo docker pull registry.access.redhat.com/rhgs3/rhgs-server-rhel7
sudo docker pull registry.access.redhat.com/rhgs3/rhgs-volmanager-rhel7
sudo docker pull registry.access.redhat.com/rhgs3/rhgs-gluster-block-prov-rhel7
sudo docker pull registry.access.redhat.com/rhgs3/rhgs-s3-server-rhel7
