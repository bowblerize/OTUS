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
root@lab:/otus# zfs get all otus
NAME  PROPERTY              VALUE                  SOURCE
otus  type                  filesystem             -
otus  creation              Fri May 15  4:00 2020  -
otus  used                  4.93M                  -
otus  available             347M                   -
otus  referenced            24K                    -
otus  compressratio         1.23x                  -
otus  mounted               yes                    -
otus  quota                 none                   default
otus  reservation           none                   default
otus  recordsize            128K                   local
otus  mountpoint            /otus                  default
otus  sharenfs              off                    default
otus  checksum              sha256                 local
otus  compression           zle                    local
otus  atime                 on                     default
otus  devices               on                     default
otus  exec                  on                     default
otus  setuid                on                     default
otus  readonly              off                    default
otus  zoned                 off                    default
otus  snapdir               hidden                 default
otus  aclmode               discard                default
otus  aclinherit            restricted             default
otus  createtxg             1                      -
otus  canmount              on                     default
otus  xattr                 on                     default
otus  copies                1                      default
otus  version               5                      -
otus  utf8only              off                    -
otus  normalization         none                   -
otus  casesensitivity       sensitive              -
otus  vscan                 off                    default
otus  nbmand                off                    default
otus  sharesmb              off                    default
otus  refquota              none                   default
otus  refreservation        none                   default
otus  guid                  14592242904030363272   -
otus  primarycache          all                    default
otus  secondarycache        all                    default
otus  usedbysnapshots       0B                     -
otus  usedbydataset         24K                    -
otus  usedbychildren        4.91M                  -
otus  usedbyrefreservation  0B                     -
otus  logbias               latency                default
otus  objsetid              54                     -
otus  dedup                 off                    default
otus  mlslabel              none                   default
otus  sync                  standard               default
otus  dnodesize             legacy                 default
otus  refcompressratio      1.00x                  -
otus  written               24K                    -
otus  logicalused           4.56M                  -
otus  logicalreferenced     12K                    -
otus  volmode               default                default
otus  filesystem_limit      none                   default
otus  snapshot_limit        none                   default
otus  filesystem_count      none                   default
otus  snapshot_count        none                   default
otus  snapdev               hidden                 default
otus  acltype               off                    default
otus  context               none                   default
otus  fscontext             none                   default
otus  defcontext            none                   default
otus  rootcontext           none                   default
otus  relatime              on                     default
otus  redundant_metadata    all                    default
otus  overlay               on                     default
otus  encryption            off                    default
otus  keylocation           none                   default
otus  keyformat             none                   default
otus  pbkdf2iters           0                      default
otus  special_small_blocks  0                      default
```

### Востановление из снапшота

Востанавливаемся из файла полученного с помощью команды zfs send.

![Receive zfs](https://github.com/bowblerize/OTUS/blob/main/resources/Receive%20zfs.png)








