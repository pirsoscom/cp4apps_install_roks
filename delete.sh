export CP4APPS_VERSION=4.2.1

export ENTITLED_REGISTRY=cp.icr.io
export ENTITLED_REGISTRY_USER=ekey
export ENTITLED_REGISTRY_KEY=v9TD89Zh6IYAMT-66pTutBlOYy-PsRogngvI5X2v5iPz

docker run -v ~/.kube:/root/.kube:z -u 0 -t -v /Users/nhirt/TEMP/mcm-install/2_install_cp4apps.sh/cp4appstest-a376efc1170b9b8ace6422196c51e491-0000.eu-de.containers.appdomain.cloud/data:/installer/data:z -e LICENSE=accept -e ENTITLED_REGISTRY -e ENTITLED_REGISTRY_USER -e ENTITLED_REGISTRY_KEY cp.icr.io/cp/icpa/icpa-installer:4.2.1 uninstall



         docker run -v ~/.kube:/root/.kube:z -u 0 -t -v $PWD/data:/installer/data:z -e LICENSE=accept -e ENTITLED_REGISTRY -e ENTITLED_REGISTRY_USER -e ENTITLED_REGISTRY_KEY "$ENTITLED_REGISTRY/cp/icpa/icpa-installer:$CP4APPS_VERSION" cs-install
docker run -v ~/.kube:/root/.kube:z -u 0 -t -v /Users/nhirt/TEMP/mcm-install/2_install_cp4apps.sh/cp4appstest-a376efc1170b9b8ace6422196c51e491-0000.eu-de.containers.appdomain.cloud/data:/installer/data:z -e LICENSE=accept -e ENTITLED_REGISTRY -e ENTITLED_REGISTRY_USER -e ENTITLED_REGISTRY_KEY cp.icr.io/cp/icpa/icpa-installer:4.2.1 uninstall
