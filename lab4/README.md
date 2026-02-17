# ZFS


### 🎯 Что нужно сделать?

  Определить алгоритм с наилучшим сжатием:

  определить, какие алгоритмы сжатия поддерживает zfs (gzip, zle, lzjb, lz4);
  создать 4 файловых системы, на каждой применить свой алгоритм сжатия;
  для сжатия использовать либо текстовый файл, либо группу файлов.

  Определить настройки пула.
  С помощью команды zfs import собрать pool ZFS.
  Командами zfs определить настройки:

  размер хранилища;
  тип pool;
  значение recordsize;
  какое сжатие используется;
  какая контрольная сумма используется.

  Работа со снапшотами:

  cкопировать файл из удаленной директории;
  восстановить файл локально. zfs receive;
  найти зашифрованное сообщение в файле secret_message.

### Исходное состояние

![Start lsblk](https://github.com/bowblerize/OTUS/blob/main/resources/start%20ztfs%20lsblk%20.png)

### Создаем 4 пула

![Pool create](https://github.com/bowblerize/OTUS/blob/main/resources/Create%20pool%20zfs.png)

``` zpool create <name-pool> mirror <disk1> <disk2>  ``` - команда создает pool с именем name-pool на перечисленных дисках с типом mirror что эквивалентно raid 1.

### Тестируем алгоритмы сжатия

![Set compression](https://github.com/bowblerize/OTUS/blob/main/resources/Set%20compression%20zfs.png)

![Check compression zfs](https://github.com/bowblerize/OTUS/blob/main/resources/Check%20compression%20zfs.png)

В рамках тестирования опеределено, что сильнее всего сжимает gzip-9.

### Импорт пула

![Import pool](https://github.com/bowblerize/OTUS/blob/main/resources/Import%20pool%20zfs.png)

Получаем параметры файловой системы:
```
root@lab:/otus# zfs get type,used,recordsize,compression,checksum otus
NAME  PROPERTY     VALUE           SOURCE
otus  type         filesystem      -
otus  used         4.93M           -
otus  recordsize   128K            local
otus  compression  zle             local
otus  checksum     sha256          local
```

### Востановление из снапшота

Востанавливаемся из файла полученного с помощью команды zfs send.

![Receive zfs](https://github.com/bowblerize/OTUS/blob/main/resources/Receive%20zfs.png)








