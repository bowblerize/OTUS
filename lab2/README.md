# Дисковая подсистема

### 🎯 Задание

  Добавьте в виртуальную машину несколько дисков
  Соберите RAID-0/1/5/10 на выбор
  Сломайте и почините RAID
  Создайте GPT таблицу, пять разделов и смонтируйте их в системе.

### Создание RAID 5

Запускаем скрипт:
```
bash script.sh
```
Результат выполнения:

![Создание RAID5](https://github.com/bowblerize/OTUS/blob/main/resources/Create%20RAID5.png)

### Ломаем и чиним RAID 5

![Ломаем и чиним RAID 5](https://github.com/bowblerize/OTUS/blob/main/resources/Breaking%20and%20rebuilding%20RAID5.png)

### Создаем 5 разделов и монтируме их

С помощью команды fdisk размечаем диск на 5 разделов и создаем на них ФС с помощью mkfs.ext4

![Разметка и создание ФС](https://github.com/bowblerize/OTUS/blob/main/resources/Create%205%20partitions%20and%20mount%20them%20into%20the%20system%201.png)

Монтируем и смотрим что все ок.

![Монтирование](https://github.com/bowblerize/OTUS/blob/main/resources/Create%205%20partitions%20and%20mount%20them%20into%20the%20system%202.png)
