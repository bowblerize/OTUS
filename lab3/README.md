 # Работа с LVM

### 🎯 Задание

На виртуальной машине с Ubuntu 24.04 и LVM.

  Уменьшить том под / до 8G.
  Выделить том под /home.
  Выделить том под /var - сделать в mirror.
  /home - сделать том для снапшотов.
  Прописать монтирование в fstab. Попробовать с разными опциями и разными файловыми системами (на выбор).
  Работа со снапшотами:
  сгенерить файлы в /home/;
  снять снапшот;
  удалить часть файлов;
  восстановиться со снапшота.

### ⭐️Задание со звездочкой 

На дисках поставить btrfs/zfs — с кэшем, снапшотами и разметить там каталог /opt.

### Уменьшение тома /

Запускаем скрипт:
```
bash move_data_from_root.sh <device> <VG> <LV>
```
Например:

![move_data_from_root.sh](https://github.com/bowblerize/OTUS/blob/main/resources/Move%20data%20from%20root.png)

### Выполняем выделение томов

Запускаем скрипт:
```
bash move_data_to_root.sh 
```
![move_data_ещ_root.sh](https://github.com/bowblerize/OTUS/blob/main/resources/Move%20data%20to%20root.png)


### ⭐️btrfs

Запускаем скрипт:
```
bash setup_btrfs.sh <device>
```
![setup_btrfs.sh](https://github.com/bowblerize/OTUS/blob/main/resources/Setup%20btrfs.png)

Итог:

![Итог](https://github.com/bowblerize/OTUS/blob/main/resources/opt%20btrfs.png)

### Работа со снапшотами

Удаляем и восстанавливаем файлы:

![Удаляем и восстанавливаем файлы](https://github.com/bowblerize/OTUS/blob/main/resources/snapshot%20home.png)



