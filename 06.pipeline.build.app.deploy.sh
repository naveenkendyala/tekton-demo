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
TASKS_DIR=demo/tasks
RESOURCES_DIR=demo/resources
PIPELINES_DIR=demo/pipelines
UTILS_DIR=demo/utils

echo ""
read -p $'\e[32m[SCRIPT] : Change to tekton-demo project \e[0m: '
oc project tekton-demo
echo ""

read -p $'\e[32m[SCRIPT] : Create the Resources \e[0m: '
oc apply -f $RESOURCES_DIR/resource.build.yaml
echo ""

read -p $'\e[32m[SCRIPT] : Create the Task with Param and Resource \e[0m: '
oc apply -f $TASKS_DIR/task.build.app.yaml
echo ""

read -p $'\e[32m[SCRIPT] : Create the Pipeline  \e[0m: '
oc apply -f $PIPELINES_DIR/pipeline.build.app.deploy.yaml
echo ""


read -p $'\e[32m[SCRIPT] : List tasks, resources and pipelines available in namespace \e[0m: tkn task ls; tkn resources ls; tkn pipeline ls'
tkn task ls
echo ""
tkn resources ls
echo ""
tkn pipeline ls
echo ""

read -p $'\e[32m[SCRIPT] : Run the Pipeline and observe the output \e[0m: tkn pipeline start build-app-deploy -p "contextDir=quarkus" -r="appSource=git-source" -r="appImage=tekton-repo-quarkus-image" -s="pipeline" --showlog'
tkn pipeline start build-app-deploy -p "contextDir=quarkus" -r="appSource=git-source" -r="appImage=tekton-repo-quarkus-image" -s="pipeline" --showlog
echo ""

#read -p $'\e[32m[SCRIPT] : Cleanup \e[0m: '
#$UTILS_DIR/clean.project.sh
#echo ""