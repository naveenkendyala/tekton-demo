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
TRIGGERS_DIR=../artifacts/triggers
DELAY_INTERVAL=10


printf "${COLOR}[SCRIPT] : Change to tekton-demo project ${NC}\n"
sleep $DELAY_INTERVAL
oc project tekton-demo
echo ""

printf "${COLOR}[SCRIPT] : Create the Resources ${NC}\n"
sleep $DELAY_INTERVAL
oc apply -f $RESOURCES_DIR/resource.build.yaml
echo ""

printf "${COLOR}[SCRIPT] : Create the Task with Param and Resource ${NC}\n"
sleep $DELAY_INTERVAL
oc apply -f $TASKS_DIR/task.build.app.yaml
echo ""

printf "${COLOR}[SCRIPT] : Create the Pipeline  ${NC}\n"
sleep $DELAY_INTERVAL
oc apply -f $PIPELINES_DIR/pipeline.build.app.deploy.yaml
echo ""

printf "${COLOR}[SCRIPT] : List tasks, resources and pipelines available in namespace ${NC}: tkn task ls; tkn resources ls; tkn pipeline ls"
sleep $DELAY_INTERVAL
tkn task ls
echo ""
tkn resources ls
echo ""
tkn pipeline ls
echo ""

printf "${COLOR}[SCRIPT] : Create the Event Listener ${NC}\n"
sleep $DELAY_INTERVAL
oc apply -f $TRIGGERS_DIR/event.listener.github.yaml
echo ""

printf "${COLOR}[SCRIPT] : Create the Trigger Binding to clone the details from Trigger ${NC}\n"
sleep $DELAY_INTERVAL
oc apply -f $TRIGGERS_DIR/trigger.binding.yaml
echo ""

printf "${COLOR}[SCRIPT] : Create the Trigger Template, pass the params & resources ${NC}\n"
sleep $DELAY_INTERVAL
oc apply -f $TRIGGERS_DIR/trigger.template.yaml
echo ""

printf "${COLOR}[SCRIPT] : Expose the Event Listener ${NC}\n"
sleep $DELAY_INTERVAL
oc expose svc/el-github-ea-webhook --port=8080
echo ""

read -p $'\e[32m[SCRIPT] : Run the Pipeline and observe the output \e[0m: tkn pipeline start build-app-deploy -p "contextDir=greetings-app/java/quarkus-api" -r="appSource=git-source" -r="appImage=tekton-repo-quarkus-image" -s="pipeline" --showlog'
tkn pipeline start build-app-deploy -p "contextDir=greetings-app/java/quarkus-api" -r="appSource=git-source" -r="appImage=tekton-repo-quarkus-image" -s="pipeline" --showlog
echo ""

printf "${COLOR}[SCRIPT] : List the Service ${NC}: oc get svc "
sleep $DELAY_INTERVAL
oc get svc
echo ""

printf "${COLOR}[SCRIPT] : Expose the service ${NC}: oc expose svc/greeter --port=8080 "
sleep $DELAY_INTERVAL
oc expose svc/greeter --port=8080
echo ""

printf "${COLOR}[SCRIPT] Create a Web Hook in the GitHub ${NC}\n"
printf "${COLOR}[SCRIPT] Make a change in the Source Repository and Test ${NC}\n"