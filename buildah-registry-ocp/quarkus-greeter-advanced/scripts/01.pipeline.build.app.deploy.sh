#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37
# Scale it back to 0 instance

#Variables
TASKS_DIR=../artifacts/tasks
RESOURCES_DIR=../artifacts/resources
UTILS_DIR=../artifacts/utilities
PIPELINES_DIR=../artifacts/pipelines
PIPELINERUNS_DIR=../artifacts/pipelineruns
WORKSPACES_DIR=../artifacts/workspaces
TRIGGERS_DIR=../artifacts/triggers


echo ""
read -p $'\e[32m[SCRIPT] : Change to tekton-demo-advanced project \e[0m: '
oc project tekton-demo-advanced
echo ""

read -p $'\e[32m[SCRIPT] : Create the Nexus Server and expose the service \e[0m: '
oc apply -f $UTILS_DIR/nexus.yaml
oc expose svc/nexus --port=8081
echo ""

read -p $'\e[32m[SCRIPT] : Verify the Nexus Server \e[0m: '
echo ""

read -p $'\e[32m[SCRIPT] : Create a Config map with the maven settings \e[0m: oc create cm maven-settings --from-file=settings.xml=$WORKSPACES_DIR/maven-settings.xml'
oc create cm maven-settings --from-file=settings.xml=$WORKSPACES_DIR/maven-settings.xml
echo ""

# There should be a default storage class before we provision the pvc
read -p $'\e[32m[SCRIPT] : Create a Persistent Volume Claim and verify the claim status \e[0m: '
oc apply -f $WORKSPACES_DIR/shared-space-pvc.yaml
oc get pvc/shared-space-pvc -o=wide
echo ""

read -p $'\e[32m[SCRIPT] : Create the PipelineResources \e[0m: '
oc apply -f $RESOURCES_DIR/resource.build.yaml
echo ""

read -p $'\e[32m[SCRIPT] : Create the Pipeline \e[0m: '
oc apply -f $PIPELINES_DIR/pipeline.quarkus.app.deploy.yaml
echo ""

read -p $'\e[32m[SCRIPT] : Create the Event Listener, Trigger Binding and Trigger Template \e[0m: '
oc apply -f $TRIGGERS_DIR/event.listener.github.yaml
oc apply -f $TRIGGERS_DIR/trigger.binding.yaml
oc apply -f $TRIGGERS_DIR/trigger.template.yaml
echo ""

read -p $'\e[32m[SCRIPT] : Expose the Event Listener \e[0m: '
oc expose svc/el-github-ea-webhook --port=8080
echo ""

read -p $'\e[32m[SCRIPT] : Execute the PipelineRun \e[0m: '
oc create -f $PIPELINERUNS_DIR/pipelinerun.quarkus.app.deploy.yaml
echo ""

read -p $'\e[32m[SCRIPT] : List the Service and expose it \e[0m: oc get svc; oc expose svc/greeter --port=8080 '
oc get svc
echo ""
oc expose svc/greeter --port=8080
echo ""

read -p $'\e[32m[SCRIPT] Create a Web Hook in the GitHub \e[0m: '
read -p $'\e[32m[SCRIPT] Make a change in the Source Repository and Test \e[0m: '
