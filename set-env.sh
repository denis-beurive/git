#!/bin/bash

alias gpush="git push -u origin master"

function github_init {

    if [ "$#" -ne 1 ]; then
        echo "Usage: github_init <name of the repository>"
        return
    fi

    if [ -z "${GITHUB_REPO_HOST}" ]; then
        echo "Environment variable GITHUB_REPO_HOST is not set!"
        return
    fi

    if [ -z "${GITHUB_USER_ID}" ]; then
        echo "Environment variable GITHUB_USER_ID is not set!"
        return
    fi

    if [ -z "${GITHUB_USER_EMAIL}" ]; then
        echo "Environment variable GITHUB_USER_EMAIL is not set!"
        return
    fi

    local -r REPO_HOST="${GITHUB_REPO_HOST}"
    local -r REPO_NAME=$(echo "${1}" | sed -e 's/.git$//')
    local -r USER_ID="${GITHUB_USER_ID}"
    local -r USER_EMAIL="${GITHUB_USER_EMAIL}"

    echo "---"
    echo "host:       ${REPO_HOST}"
    echo "user:       ${USER_ID}"
    echo "email:      ${USER_EMAIL}"
    echo "repository: ${REPO_NAME}"
    echo

    return

    set -e
    git init
    git remote add origin git@${REPO_HOST}:${USER_ID}/${REPO_NAME}.git
    git config user.email "${USER_EMAIL}"
    set +e
}