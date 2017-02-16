#!/usr/bin/env bash

set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

__DIR__="$(cd "$(dirname "${0}")"; echo $(pwd))"
__BASE__="$(basename "${0}")"
__FILE__="${__DIR__}/${__BASE__}"

TESTDIR="${__DIR__}/testdir"

# Takes a command as arguments and paints both it's STDOUT & STDERR in
# colors specified in first and second arguments. Use 'purge' to skip printing
# at all
function paint() (
  set -o pipefail;

  green=$'s,.*,\x1B[32m&\x1B[m,'
  red=$'s,.*,\x1B[31m&\x1B[m,'
  gray=$'s,.*,\x1B[37m&\x1B[m,'
  purge="/.*/d"

  stdout="${!1}"
  stderr="${!2}"

  ("${@:3}" 2>&1>&3 |sed ${stderr} >&2) 3>&1 \
                    |sed ${stdout}
)
function fail () {
  paint red red echo ${@}
  exit 1
}
function okay () {
  paint green red echo ${@}
}


rm -rf "${TESTDIR}"
mkdir -p "${TESTDIR}"

pushd "${_}"
  git init
  cp -af "${__DIR__}/pre-commit" ".git/hooks/pre-commit" && chmod 755 "${_}"
  for ext in go php js es6 rb py bash sh pl coffee xml json yaml; do
    failfile="syntax-fail.${ext}"
    failbuff="#!/bin/bash\n<?php;-): -"
    okayfile="syntax-okay.${ext}"
    okaybuff=""
    if [ "${ext}" = "xml" ]; then
      okaybuff="<xml><items></items></xml>"
    elif [ "${ext}" = "json" ]; then
      okaybuff='{"foo": "bar"}'
    fi

    # Test failing syntax
    action="commit a .${ext} with syntax errors"
    echo -e "${failbuff}" > ${failfile}
    git add ${failfile}
    if git commit -m "trying to ${action}"; then
      cat ${failfile}
      fail "Should not have been able to ${action}"
    else
      okay "Tried to ${action} and failed"
    fi
    git rm --cached ${failfile}
    rm ${failfile}

    # Test okay syntax
    action="commit a .${ext} without syntax errors"
    echo -e "${okaybuff}" > ${okayfile}
    git add ${okayfile}
    if ! git commit -m "trying to ${action}"; then
      cat ${okayfile}
      fail "Should have been able to ${action}"
    else
      okay "Tried to ${action} and succeeded"
    fi
    git rm --cached ${okayfile}
    rm ${okayfile}
  done

  # failing pre-ochtra
  action="commit with a failing pre-ochtra"
  echo -e 'exit 1' > .git/hooks/pre-ochtra
  chmod 755 .git/hooks/pre-ochtra
  okayfile="syntax-okay-for-pre-ochtra.txt"
  echo -e "foobar" > ${okayfile}
  git add ${okayfile}
  if git commit -m "trying to ${action}"; then
    fail "Should not have been able to ${action}"
  else
    okay "Tried to ${action} and failed"
  fi
  git rm --cached ${okayfile}
  rm ${okayfile}
  rm .git/hooks/pre-ochtra

  # succeeding pre-ochtra
  action="commit with a succeeding pre-ochtra"
  echo -e 'exit 0' > .git/hooks/pre-ochtra
  chmod 755 .git/hooks/pre-ochtra
  okayfile="syntax-okay-for-pre-ochtra.txt"
  echo -e "foobar" > ${okayfile}
  git add ${okayfile}
  if ! git commit -m "trying to ${action}"; then
    fail "Should have been able to ${action}"
  else
    okay "Tried to ${action} and succeeded"
  fi
  git rm --cached ${okayfile}
  rm ${okayfile}
  rm .git/hooks/pre-ochtra
popd

rm -rf "${TESTDIR}"
okay "All tests passed : )"
