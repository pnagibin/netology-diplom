export PATH=$PATH:/home/pnagibin/netology/ter-homeworks/
export ANSIBLE_HOST_KEY_CHECKING=False
ansible -i ./ansible/hosts.cfg -u nagibin all -m ping
ansible-playbook -i ./ansible/hosts.cfg -u nagibin ./ansible/kube-prerequisites.yaml
ansible-playbook -i ./ansible/hosts.cfg -u nagibin ./ansible/kube-masters.yaml
ansible-playbook -i ./ansible/hosts.cfg -u nagibin ./ansible/kube-workers.yaml