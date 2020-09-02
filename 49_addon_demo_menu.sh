# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Create Demo Menus
#
# V1.0 
#
# ©2020 nikh@ch.ibm.com
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"

source ./99_config-global.sh


# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Do Not Edit Below
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"



headerModuleFileBegin "Create MCM Demo Menus " $0


# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# INSTALL CHECKS
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
header3Begin "Install Checks"

        getClusterFQDN

        getInstallPath



header3End



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# PREREQUISITES
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
header3Begin "Installing MCM Demo Menus" "rocket"
        
        __output " ${wrench} Create Config Directory"
          rm -r $INSTALL_PATH/* 
          mkdir -p $INSTALL_PATH 
          cd $INSTALL_PATH
        __output "    ${GREEN}  OK${NC}"
        __output "  "
        

        __output " ${wrench} Getting existing menu configuration"

        kubectl get navconfigurations.foundation.ibm.com multicluster-hub-nav -n kube-system -o yaml > navconfigurations.orginal

        cp navconfigurations.orginal navconfigurations.demo.yaml

        if grep -F "id: demo" navconfigurations.orginal;
        then
            __output "    ${RED}${cross}Demo Menus already installed! Skipping...${NC}"
            exit 0
        fi


# Add OpenLDAP to Admin
cat >> navconfigurations.demo.yaml <<EOL
  - id: id-ldap
    label: OpenLDAP Admin
    parentId: administer-mcm
    serviceId: webui-nav
    target: _blank
    url: http://openldap-admin-default.$CLUSTER_NAME/
EOL



cat >> navconfigurations.demo.yaml <<EOL
  - id: cp4apps
    isAuthorized:
      - ClusterAdministrator
      - AccountAdministrator
      - Administrator
      - Operator
      - Editor
    label: Cloud Pak for Applications
    parentId: applications
    serviceId: app-ta
    target: _blank
    url: http://ibm-cp-applications.$CLUSTER_NAME/
EOL


cat >> navconfigurations.demo.yaml <<EOL
  - id: ta-applications
    isAuthorized:
      - ClusterAdministrator
      - AccountAdministrator
      - Administrator
      - Operator
      - Editor
    label: Transformation Advisor
    parentId: applications
    serviceId: app-ta
    target: _blank
    url: https://ta-apps.$CLUSTER_NAME/
EOL

cat >> navconfigurations.demo.yaml <<EOL
  - id: appnav-applications
    isAuthorized:
      - ClusterAdministrator
      - AccountAdministrator
      - Administrator
      - Operator
      - Editor
    label: Application Navigator
    parentId: applications
    serviceId: appnav-ta
    target: _blank
    url: http://kappnav-ui-service-kappnav.$CLUSTER_NAME/
EOL

cat >> navconfigurations.demo.yaml <<EOL
  - id: tekton-applications
    isAuthorized:
      - ClusterAdministrator
      - AccountAdministrator
      - Administrator
      - Operator
      - Editor
    label: Tekton Pipelines
    parentId: applications
    serviceId: app-tekton
    target: _blank
    url: http://tekton-dashboard-tekton-pipelines.$CLUSTER_NAME/
EOL






# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# INSTALL
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------



kubectl apply -n kube-system --validate=false -f navconfigurations.demo.yaml  

header3End

headerModuleFileEnd "Create MCM Demo Menus " $0


# KUBE_EDITOR="nano" kubectl edit navconfigurations.foundation.ibm.com multicluster-hub-nav -n kube-system

