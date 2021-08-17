#!/bin/bash

# THIS FILE MUST BE 'SOURCED' NOT EXECUTED, I.E.:
# source ~/.openstack/activate-openstack.sh

while true; do
    echo -e "Please Select which Region you would like to work in? \n 1) EDC\n 2) PDC\n 3) SDC\n 4) SDCEDN"
    read -p "Region: " REGION

    case $REGION in
        [1]* ) OS_REGION=EDC; LAB=FALSE;
               break;;
        [2]* ) OS_REGION=PDC; LAB=FALSE;
               break;;
        [3]* ) OS_REGION=SDC; LAB=FALSE;
               break;;
        [4]* ) OS_REGION=SDCEDN; LAB=FALSE;
               break;;
           * ) echo "Please answer with the number of the desired environment.";;
    esac
done

export OS_USERNAME=""
export OS_TENANT_NAME=""
export OS_PASSWORD=""
export OS_AUTH_URL=
export OS_IDENTITY_API_VERSION=3
export OS_REGION_NAME=$OS_REGION
