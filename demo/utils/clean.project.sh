#!/bin/bash

oc delete pods --field-selector=status.phase=Succeeded
oc delete pods --field-selector=status.phase=Failed
oc delete routes --all
tkn resource delete -f --all
tkn task delete  -f --all
tkn taskrun delete  -f --all
tkn pipelinerun delete -f --all

