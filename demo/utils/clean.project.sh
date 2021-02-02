#!/bin/bash

tkn resource delete -f --all
tkn task delete  -f --all
tkn taskrun delete  -f --all
tkn triggertemplate delete -f --all
tkn pipeline delete -f --all
tkn pipelinerun delete -f --all

oc delete pods --field-selector=status.phase=Succeeded
oc delete pods --field-selector=status.phase=Failed
oc delete pods --all
oc delete deployments --all
oc delete services --all
oc delete routes --all