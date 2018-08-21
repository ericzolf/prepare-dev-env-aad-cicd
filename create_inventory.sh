#!/bin/bash

if [ -n "$2" ]
then
	sed -e "s/GUID/$1/g" -e "s/USERNAME/$2/g" \
		${0%.sh}.template.inventory > ${0%.sh}.local.inventory
else
	echo "Usage: $0 <GUID> <RHPDS-USERNAME>"
	exit 1
fi

# create our final inventory
ansible-playbook -i ${0%.sh}.local.inventory ${0%.sh}.yml || exit 1

echo "Inventory created, it is correct if the following lines are green:"

# verify that it runs correctly as normal user
ansible -i ansible-cicd-lab.local.inventory -m ping all

# verify that it runs correctly as root
ansible -i ansible-cicd-lab.local.inventory -m command -a id all -b
