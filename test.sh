#!/usr/bin/env bash

set -o pipefail
set -o errexit
# set -o xtrace
set -o nounset

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
  for ext in go php js rb py bash sh pl coffee xml json; do
    failfile="syntax-fail.${ext}"
    okayfile="syntax-okay.${ext}"

    echo -e "#!/bin/bash\n<?php;-)" > ${failfile}
    git add ${failfile}
    if git commit -m "trying to commit a .${ext} with syntax errors"; then
      cat ${failfile}
      fail "Should not have been able to commit a .${ext} with syntax errors"
    else
      okay "Tried to commit a .${ext} with syntax errors and failed"
    fi
    git rm --cached ${failfile}

    if [ "${ext}" = "xml" ]; then
      good="<xml><items></items></xml>"
    elif [ "${ext}" = "json" ]; then
      good='{"foo": "bar"}'
    else
      good=""
    fi
    echo "${good}" > ${okayfile}
    git add ${okayfile}
    if ! git commit -m "trying to commit a .${ext} without syntax errors"; then
      cat ${okayfile}
      fail "Should have been able to commit a .${ext} without syntax errors"
    else
      okay "Tried to commit a .${ext} without syntax errors and succeeded"
    fi
    git rm --cached ${okayfile}
  done
popd

rm -rf "${TESTDIR}"
okay "All tests passed : )"
