#!/bin/bash

_PATH=$1
_CHUNKS=$2
_INDEX=1
_HEADER=$(head -1 "${_PATH}")
_NAME=$(basename "${_PATH}" .csv)
_DIR=$(dirname -- "${_PATH}")

split -l "${_CHUNKS}" "${_PATH}" ${_DIR}/_CHUNKS

for _CHUNK in ${_DIR}/_CHUNKS*
do
    if (( ${_INDEX} > 1 )); then
        echo ${_HEADER} > ${_DIR}/${_NAME}-chunk-${_INDEX}.csv
    fi

    cat ${_CHUNK} >> ${_DIR}/${_NAME}-chunk-${_INDEX}.csv

    rm ${_CHUNK}

    ((_INDEX=_INDEX+1))
done
