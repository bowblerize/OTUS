# Systemd - создание unit-файла

## Цель:

  Научиться редактировать существующие и создавать новые unit-файлы;


## Выполнить следующие задания:

  Написать service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова (файл лога и ключевое слово должны задаваться в /etc/default).
  
  Установить spawn-fcgi и создать unit-файл (spawn-fcgi.sevice) с помощью переделки init-скрипта (https://gist.github.com/cea2k/1318020).
  
  Доработать unit-файл Nginx (nginx.service) для запуска нескольких инстансов сервера с разными конфигурационными файлами одновременно.


### Настройка хоста

Для настройки необходимо выполнить:

```
git clone https://github.com/bowblerize/OTUS
cd OTUS/ansible
ansible-playbook -i inventory/yandex-cloud labs.yml --tags lab8 -e "host_ip=<ip> user=<user> ssh_private_key=<path priv key>"
```

### Сервис мониторинга

Для проверки работы выполняем: 

```
systemctl list-timers checklog.timer
sudo journalctl -u checklog.service | grep -P 'WARNING(\ not|) found in'
```

### spawn-fcgi

Для проверки работы выполняем:

```
systemctl status spawn-fcgi
```

### Nginx

Для проверки работы выполняем:

```
systemctl status nginx.service
systemctl status nginx@1.service
systemctl status nginx@2.service
```
