#!/bin/bash
DOCKER_REGISTRY_URL='pdc-v-nvdocker1.epnet.com:5000'

# Openstack aliases
alias tstamp='~/Scripts/timestamp-to-clipboard.sh'
alias oa='source ~/.openstack/activate-openstack.sh'
alias od='source ~/.openstack/deactivate-openstack.sh'
alias o-sl='openstack server list'
alias o-ss='openstack server show'
alias o-il='openstack image list'
alias o-fl='openstack flavor list'
alias o-nl='openstack network list'
alias o-srw16='openstack server rebuild --image be0a195a-0c04-403a-8351-a8182c26e905'

alias pwdsize='du -sh .'
function finds { 
    if [[ $1 == 'rm' ]] && [[ -z $2 ]]; then
        printf 'Error: '\''rm'\'' must be followed by a file pattern, i.e. *.orig'
    elif [[ ! -z $1 ]] && [[ ! -z $2 ]]; then
        find . -name "$2" -exec rm {} \;
        printf "Removed recursively all files that match: $2"
    else
        find . -name "$1" 
    fi
}
function timer {
    echo "Starting function timer ..."; START_TIME=$(date +%s); $1; END_TIME=$(date +%s); echo "That took ... $(($END_TIME - $START_TIME)) seconds."
}
function nukedc {
        all_ids=`docker ps -aq`
        docker stop $all_ids; docker rm $all_ids
}