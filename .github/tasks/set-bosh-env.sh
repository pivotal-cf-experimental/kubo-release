#!/usr/bin/env bash

if [ "$1" == "" ]; then
    echo "Usage: "
    echo "source set-bosh-env source"
    exit 1
fi

BOSH_CLIENT="$(bosh int "$1" --path=/client)"
BOSH_CLIENT_SECRET="$(bosh int "$1" --path=/client_secret)"
BOSH_CA_CERT="$(bosh int "$1" --path=/ca_cert)"
BOSH_ENVIRONMENT="$(bosh int "$1" --path=/target)"
if bosh int --path=/jumpbox_ssh_key  "$1" &>/dev/null ; then
    jumpbox_ssh_key="$(mktemp)"
    bosh int --path=/jumpbox_ssh_key "$1" > ${jumpbox_ssh_key}
    proxy="ssh+socks5://jumpbox@$(bosh int --path=/jumpbox_url "$1")?private-key=${jumpbox_ssh_key}"
    export BOSH_ALL_PROXY="${proxy}"
fi

export BOSH_CA_CERT BOSH_CLIENT BOSH_CLIENT_SECRET BOSH_ENVIRONMENT

