# https://www.ibm.com/support/knowledgecenter/en/SSFC4F_1.1.0/mcm/troubleshoot/delete_import.html
# docker run -it --entrypoint=cp -v /tmp:/data ibmcom/icp-multicluster-endpoint-operator:3.2.1 /usr/local/bin/self-destruct.sh /data/self-destruct.sh; /tmp/self-destruct.sh 2>&1 | tee self-destruct.log; rm /tmp/self-destruct.sh


#!/bin/bash

# Licensed Materials - Property of IBM
# 5737-E67
# (C) Copyright IBM Corporation 2016, 2019 All Rights Reserved
# US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.

if [ -z "${OPERATOR_NAMESPACE}" ]; then
	OPERATOR_NAMESPACE="multicluster-endpoint"
fi

# Delete all endpoints.multicloud.ibm.com
kubectl delete endpoints.multicloud.ibm.com -n ${OPERATOR_NAMESPACE}  --all --timeout=60s

# Delete Deployment
kubectl delete deployment ibm-multicluster-endpoint-operator -n ${OPERATOR_NAMESPACE}

# Force delete all component CRDs if they still exist
component_crds=(
	helmreleases.helm.bitnami.com
	applicationmanagers.multicloud.ibm.com
	certmanagers.multicloud.ibm.com
	connectionmanagers.multicloud.ibm.com
	meterings.multicloud.ibm.com
	mongodbs.multicloud.ibm.com
	monitorings.multicloud.ibm.com
	policycontrollers.multicloud.ibm.com
	searchcollectors.multicloud.ibm.com
	serviceregistries.multicloud.ibm.com
	tillers.multicloud.ibm.com
	topologycollectors.multicloud.ibm.com
	workmanagers.multicloud.ibm.com
	endpoints.multicloud.ibm.com
)

# Loop through all namespaces and delete all helmreleases.helm.bitnami.com CRD resources (backup in case operator fails)
for namespace in `kubectl get namespaces -o name`; do
    ns=`echo $namespace | cut -d "/" -f 2`
    echo "Processing namespace ${ns}"
    for cr in `kubectl get helmrelease -n ${ns} -o name`; do
        echo "Attempt to remove finalizer for CR ${cr}"
        kubectl patch ${cr} --type="json" -p '[{"op": "remove", "path":"/metadata/finalizers"}]'
        echo "Attempt to delete CR ${cr} in namespace ${ns}"
        kubectl delete ${cr} -n ${ns}
    done
done

# special case for meterings.multicloud.ibm.com
for resource in `kubectl get meterings.multicloud.ibm.com -n kube-system -o name`; do
	kubectl delete ${resource} -n kube-system --timeout=15s
	kubectl patch ${resource} -n kube-system --type="json" -p '[{"op": "remove", "path":"/metadata/finalizers"}
]'
done

for crd in "${component_crds[@]}"; do
	echo "force delete all CustomResourceDefination ${crd} resources..."
	for resource in `kubectl get ${crd} -o name -n ${OPERATOR_NAMESPACE}`; do
		echo "attempt to delete ${crd} resource ${resource}..."
		kubectl delete ${resource} -n ${OPERATOR_NAMESPACE} --timeout=15s
		echo "force remove ${crd} resource ${resource}..."
		kubectl patch ${resource} -n ${OPERATOR_NAMESPACE} --type="json" -p '[{"op": "remove", "path":"/met
adata/finalizers"}]'
	done
	echo "force delete all CustomResourceDefination ${crd} resources..."
	kubectl delete ${crd}
done

kubectl delete namespace ${OPERATOR_NAMESPACE}