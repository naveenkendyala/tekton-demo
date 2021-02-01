#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37
# Scale it back to 0 instance

read -p $'\e[32m[STEP-00] : Change to tekton-demo project \e[0m'
oc project tekton-demo
echo ""

read -p $'\e[32m[STEP-01] : Create the Task with Hello \e[0m: '
oc apply -f demo/01.hello.task.yaml
echo ""

read -p $'\e[32m[STEP-02] : List the tasks available in namespace \e[0m: '
tkn task ls
echo ""

read -p $'\e[32m[STEP-03] : Run the Task and observe the output \e[0m: '
tkn task start hello --showlog
echo ""

