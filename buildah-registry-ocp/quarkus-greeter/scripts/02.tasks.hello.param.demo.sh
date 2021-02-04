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
UTILS_DIR=../artifacts/utilities

echo ""
read -p $'\e[32m[SCRIPT] : Change to tekton-demo project \e[0m: '
oc project tekton-demo
echo ""

read -p $'\e[32m[SCRIPT] : Create the **MULTI-STEP** Task with Hello Param \e[0m: '
oc apply -f $TASKS_DIR/task.hello.param.yaml
echo ""

read -p $'\e[32m[SCRIPT] : List the tasks available in namespace \e[0m: tkn task ls'
tkn task ls
echo ""

read -p $'\e[32m[SCRIPT] : Run the Task and observe the output \e[0m: tkn task start hello-param -p "entity=Tekton Using Params" --showlog'
tkn task start hello-param -p "entity=Tekton Using Params" --showlog
echo ""

read -p $'\e[32m[SCRIPT] : Cleanup \e[0m: '
$UTILS_DIR/clean.project.sh
echo ""