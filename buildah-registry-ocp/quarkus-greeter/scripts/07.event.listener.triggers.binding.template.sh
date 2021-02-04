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
TRIGGERS_DIR=../artifacts/triggers

echo ""
read -p $'\e[32m[SCRIPT] : Change to tekton-demo project \e[0m: '
oc project tekton-demo
echo ""

read -p $'\e[32m[SCRIPT] : Create the Event Listener \e[0m: '
oc apply -f $TRIGGERS_DIR/event.listener.github.yaml
echo ""

read -p $'\e[32m[SCRIPT] : Create the Trigger Binding to clone the details from Trigger \e[0m: '
oc apply -f $TRIGGERS_DIR/trigger.binding.yaml
echo ""

read -p $'\e[32m[SCRIPT] : Create the Trigger Template, pass the params & resources \e[0m: '
oc apply -f $TRIGGERS_DIR/trigger.template.yaml
echo ""

read -p $'\e[32m[SCRIPT] : Expose the Event Listener \e[0m: '
oc expose svc/el-github-ea-webhook --port=8080
echo ""

read -p $'\e[32m[SCRIPT] Create a Web Hook in the GitHub \e[0m: '

read -p $'\e[32m[SCRIPT] Make a change in the Source Repository and Test \e[0m: '