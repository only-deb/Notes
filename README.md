# Notes
Приложение заметки для Debian 12.



Перед запуском установите необходимые пакеты:

``` 
sudo apt update
sudo apt install python3 python3-gi python3-gi-cairo gir1.2-gtk-3.0 glade sqlite3
pip install pygobject 
```

Для запуска Notes Editor нужно перейти в дерикторию с файлами программы и ввести команду

```
./editor/editor
```

Для запуска Notes Widget нужно перейти в дерикторию с файлами программы и ввести команду

```
./widget/widget
```

# Шаг 1: Создание автозагрузки для виджета

1. Создание .desktop файла
Создайте файл widget.desktop в директории ~/.config/autostart

```
nano ~/.config/autostart/widget.desktop
```

(если у вас нет такой директории, то создайте ее)

```
mkdir -p ~/.config/autostart
```


Добавьте в этот файл следующее содержимое:

```
[Desktop Entry]
Type=Application
Exec=/path/to/widget_executable
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=Notes Widget
Name=Notes Widget
```

Замените /path/to/widget_executable на путь к вашему исполняемому файлу виджета.

2. Сохранение и выход из редактора

Сохраните файл и выйдите из редактора (Ctrl + O, затем Enter, и Ctrl + X).

# Шаг 2: Закрепление виджета на рабочем столе

Чтобы виджет был закреплен на рабочем столе, вам нужно настроить его запуск в "закрепленном" состоянии. Один из способов — это использование оконного менеджера для закрепления окна виджета. Здесь рассмотрим использование wmctrl для управления окном.
1. Установка wmctrl

Убедитесь, что у вас установлен wmctrl:


```
sudo apt install wmctrl
```


2. Скрипт для закрепления виджета

Создайте скрипт, который будет запускать виджет и закреплять его окно на рабочем столе.

Создайте файл start_widget.sh в домашней директории:

```
nano ~/start_widget.sh
```

Добавьте в этот файл следующее содержимое:


```
#!/bin/bash

# Запуск виджета
/path/to/widget_executable &

# Дождаться, пока виджет запустится
sleep 2

# Закрепить окно виджета на рабочем столе
wmctrl -r "Notes Widget" -b add,sticky
```

Замените /path/to/widget_executable на путь к вашему исполняемому файлу виджета.


3. Сделайте скрипт исполняемым

Сделайте скрипт исполняемым:

```
chmod +x ~/start_widget.sh
```
4. Обновление .desktop файла для использования скрипта

Измените путь в Exec вашего widget.desktop файла, чтобы он указывал на новый скрипт:

```
nano ~/.config/autostart/widget.desktop
```

Добавьте в этот файл следующее содержимое:

```
[Desktop Entry]
Type=Application
Exec=/home/yourusername/start_widget.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=Notes Widget
Name=Notes Widget
```
Замените yourusername на ваше имя пользователя.
