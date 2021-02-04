#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37
# Scale it back to 0 instance

#COLOR Preference
COLOR='\033[0;32m'
NC='\033[0m' # No Color

#Variables
TASKS_DIR=../artifacts/tasks
RESOURCES_DIR=../artifacts/resources
UTILS_DIR=../artifacts/utilities
PIPELINES_DIR=../artifacts/pipelines
PIPELINERUNS_DIR=../artifacts/pipelineruns
WORKSPACES_DIR=../artifacts/workspaces
TRIGGERS_DIR=../artifacts/triggers
DELAY_INTERVAL=10




echo ""
printf "${COLOR}[SCRIPT] : Change to tekton-demo-advanced project ${NC}\n"
sleep $DELAY_INTERVAL
oc project tekton-demo-advanced
echo ""

printf "${COLOR}[SCRIPT] : Create the Nexus Server and Expose the service ${NC}\n"
sleep $DELAY_INTERVAL
oc apply -f $UTILS_DIR/nexus.yaml
oc expose svc/nexus --port=8081
echo ""

read -p $'\e[32m[SCRIPT] : Verify the Nexus Server \e[0m: '
echo ""

printf "${COLOR}[SCRIPT] : Create a Config map with the maven settings ${NC}: oc create cm maven-settings --from-file=settings.xml=$WORKSPACES_DIR/maven-settings.xml \n"
oc create cm maven-settings --from-file=settings.xml=$WORKSPACES_DIR/maven-settings.xml
echo ""

# There should be a default storage class before we provision the pvc
printf "${COLOR}[SCRIPT] : Create a Persistent Volume Claim and Verify the claim status ${NC}\n"
oc apply -f $WORKSPACES_DIR/shared-space-pvc.yaml
sleep $DELAY_INTERVAL
oc get pvc/shared-space-pvc -o=wide
echo ""

printf "${COLOR}[SCRIPT] : Create the PipelineResources ${NC}\n"
sleep $DELAY_INTERVAL
oc apply -f $RESOURCES_DIR/resource.build.yaml
echo ""

printf "${COLOR}[SCRIPT] : Create the Pipeline ${NC}\n"
sleep $DELAY_INTERVAL
oc apply -f $PIPELINES_DIR/pipeline.quarkus.app.deploy.yaml
echo ""

printf "${COLOR}[SCRIPT] : Create the Event Listener, Trigger Binding and Trigger Template ${NC}\n"
sleep $DELAY_INTERVAL
oc apply -f $TRIGGERS_DIR/event.listener.github.yaml
oc apply -f $TRIGGERS_DIR/trigger.binding.yaml
oc apply -f $TRIGGERS_DIR/trigger.template.yaml
echo ""

printf "${COLOR}[SCRIPT] : Expose the Event Listener ${NC}\n"
oc expose svc/el-github-ea-webhook --port=8080
echo ""

printf "${COLOR}[SCRIPT] : Execute the PipelineRun ${NC}\n"
oc create -f $PIPELINERUNS_DIR/pipelinerun.quarkus.app.deploy.yaml
tkn pr logs -f -a $(tkn pr ls | awk 'NR==2{print $1}')
echo ""

printf "${COLOR}[SCRIPT] : List the Service and expose it ${NC}: oc get svc; oc expose svc/greeter --port=8080"
oc get svc
echo ""
oc expose svc/greeter --port=8080
echo ""

read -p $'\e[32m[SCRIPT] Create a Web Hook in the GitHub \e[0m: '
printf "${COLOR}[SCRIPT] Make a change in the Source Repository and Test ${NC}\n"
