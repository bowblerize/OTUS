# Практика с SELinux

### 🎯Задание

  1) Запустить nginx на нестандартном порту 3-мя разными способами:
    переключатели setsebool;

    добавление нестандартного порта в имеющийся тип;

    формирование и установка модуля SELinux.

  2) развернуть приложенный стенд https://github.com/mbfx/otus-linux-adm/tree/master/selinux_dns_problems;
    выяснить причину неработоспособности механизма обновления зоны (см. README);

    предложить решение (или решения) для данной проблемы;

    выбрать одно из решений для реализации, предварительно обосновав выбор;

    реализовать выбранное решение и продемонстрировать его работоспособность.

### Задание 1 

setsebool:

![Setsebool](https://github.com/bowblerize/OTUS/blob/main/resources/lab11setsebool.png)

добавление нестандартного порта в имеющийся тип:

![Port]((https://github.com/bowblerize/OTUS/blob/main/resources/lab11port.png))

модуль SELinux:

![Module](https://github.com/bowblerize/OTUS/blob/main/resources/lab11module.png)

### Задание 2

При выполнении команды выводит ошибку "update failed...", при просмотре статусе сервиса видно ошибку доступа до деректории.

![Статус named](https://github.com/bowblerize/OTUS/blob/main/resources/status%20named.png)


После чтения документации, можно выделить два варианта решения:

1. Задать тип для деректории /etc/named/dynamic named_cache_t, тк там etc_t
2. Поменять в конфиг, для зоны ddns.lab поменять поле file на "/var/named/dynamic/..."

Второй проще, поэтому делаю его.

![Конфиг named](https://github.com/bowblerize/OTUS/blob/main/resources/lab11confnamed.png)

После все работает.

![lab11](https://github.com/bowblerize/OTUS/blob/main/resources/lab11.png)
