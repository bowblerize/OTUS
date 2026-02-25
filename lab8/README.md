systemctl list-timers checklog.timer
sudo journalctl -u checklog.service | grep -P 'WARNING(\ not|) found in'
ansible-playbook -i inventory/yandex-cloud labs.yml --tags lab8 -e "host_ip= user= ssh_private_key="
