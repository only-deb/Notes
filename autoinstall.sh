#!/bin/bash

# Название виртуального окружения
VENV_DIR="$HOME/my_widget_env"

# Путь к исполняемым файлам виджета и редактора
WIDGET_EXECUTABLE_PATH="$VENV_DIR/bin/widget"
EDITOR_EXECUTABLE_PATH="$VENV_DIR/bin/editor"

# URL для скачивания готовых исполняемых файлов
WIDGET_URL="https://github.com/only-deb/Notes/releases/download/v1.0.0/widget"
EDITOR_URL="https://github.com/only-deb/Notes/releases/download/v1.0.0/editor"

# Обновление системы и установка необходимых пакетов
sudo apt update
sudo apt install -y python3 python3-venv python3-pip python3-gi python3-gi-cairo gir1.2-gtk-3.0 glade wmctrl curl

# Создание виртуального окружения
python3 -m venv $VENV_DIR
if [ ! -d "$VENV_DIR" ]; then
    echo "Ошибка: не удалось создать виртуальное окружение в $VENV_DIR"
    exit 1
fi

# Активация виртуального окружения
source $VENV_DIR/bin/activate

# Установка необходимых пакетов в виртуальном окружении
pip install pygobject

# Деактивация виртуального окружения
deactivate

# Создание директории для исполняемых файлов
mkdir -p $VENV_DIR/bin

# Загрузка готовых исполняемых файлов
curl -L -o $WIDGET_EXECUTABLE_PATH $WIDGET_URL
if [ $? -ne 0 ]; then
    echo "Ошибка: не удалось загрузить виджет с $WIDGET_URL"
    exit 1
fi

curl -L -o $EDITOR_EXECUTABLE_PATH $EDITOR_URL
if [ $? -ne 0 ]; then
    echo "Ошибка: не удалось загрузить редактор с $EDITOR_URL"
    exit 1
fi

# Сделать исполняемые файлы действительно исполняемыми
chmod +x $WIDGET_EXECUTABLE_PATH
chmod +x $EDITOR_EXECUTABLE_PATH

# Создание скрипта для запуска виджета
cat <<EOL > $HOME/start_widget.sh
#!/bin/bash

# Запуск виджета
$WIDGET_EXECUTABLE_PATH &

# Дождаться, пока виджет запустится
sleep 2

# Закрепить окно виджета на рабочем столе
wmctrl -r "Notes Widget" -b add,sticky
EOL

# Сделать скрипт исполняемым
chmod +x $HOME/start_widget.sh

# Создание скрипта для запуска редактора
cat <<EOL > $HOME/start_editor.sh
#!/bin/bash

# Запуск редактора
$EDITOR_EXECUTABLE_PATH &
EOL

# Сделать скрипт исполняемым
chmod +x $HOME/start_editor.sh

# Создание директории автозагрузки (если она не существует)
mkdir -p ~/.config/autostart

# Создание файла автозагрузки для виджета
cat <<EOL > ~/.config/autostart/widget.desktop
[Desktop Entry]
Type=Application
Exec=$HOME/start_widget.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=Notes Widget
Name=Notes Widget
Comment[en_US]=Start the Notes Widget at login
Comment=Start the Notes Widget at login
EOL

echo "Установка завершена. Перезагрузите систему, чтобы виджет автоматически запустился и был закреплен на рабочем столе."
echo "Вы можете запустить виджет вручную с помощью команды: $HOME/start_widget.sh"
echo "Вы можете запустить редактор вручную с помощью команды: $HOME/start_editor.sh"
