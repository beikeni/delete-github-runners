#!bin/bash

REPO=$1
TOKEN=$2

RUNNER_LIST=$(curl -H "Authorization: token ${TOKEN}" -H "Accept: application/vnd.github+json" https://api.github.com/repos/${REPO}/actions/runners | jq '[.runners[] | select(.status | contains("offline")) | {id: .id}]')

for id in $(echo "$RUNNER_LIST" | jq -r '.[] | @base64'); do
        _jq() {
                echo ${id} | base64 --decode | jq -r ${1}
        }
        echo $(_jq '.id')
        curl -X DELETE -H "Accept: application/vnd.github+json" -H "Authorization: token ${TOKEN}"  https://api.github.com/repos/${REPO}/actions/runners/$(_jq '.id')
done