# С чего начинается Linux

### 🎯Задание

  Запустите ВМ c Ubuntu.
  Обновите ядро ОС на новейшую стабильную версию из mainline-репозитория.
  Оформите отчет в README-файле в GitHub-репозитории.

### ⭐️Задание со звездочкой

Собрать ядро самостоятельно из исходных кодов.

Исходная версия ядра:

![Исходная версия ядра](https://github.com/bowblerize/OTUS/blob/main/resources/Original%20kernal.png)

### Сборка ядра будет производиться на Debian 11.11 для этого выполняем следующие команды:

```
sudo apt update
sudo apt install build-essential linux-source bc kmod cpio flex libncurses5-dev libelf-dev libssl-dev dwarves bison rsync packaging-dev
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.7.tar.xz
tar xfv linux-5.15.7.tar.xz
cd linux-5.15.7
cp /boot/config-$(uname -r) .config
make olddefconfig
sed -i   -e 's|^CONFIG_MODULE_SIG_KEY=.*|CONFIG_MODULE_SIG_KEY=""|'   -e 's|^CONFIG_SYSTEM_TRUSTED_KEYS=.*|CONFIG_SYSTEM_TRUSTED_KEYS=""|'   .config
nice make -j`nproc` bindeb-pkg
cd ..
sudo dpkg -i ./*.deb
sudo reboot
```

Версия ядра после сборки:

![Исходная версия ядра](https://github.com/bowblerize/OTUS/blob/main/resources/New%20kernal.png)
