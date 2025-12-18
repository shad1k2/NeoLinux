#!/bin/bash

# NeoLinux installer script v1.0
# Запускать на минимальной Debian 13 (root или с sudo)

set -e  # Остановка при ошибке

echo "========================================"
echo "   Установка NeoLinux v1.0"
echo "   Минимальный TUI-десктоп на Debian"
echo "========================================"
echo

# Проверка root-прав
if [ "$EUID" -ne 0 ]; then
    echo "Ошибка: Запускайте от root или с sudo"
    exit 1
fi

# Обновление системы
echo "Обновление системы..."
apt update && apt upgrade -y

# Установка необходимых пакетов
echo "Установка пакетов..."
apt install -y tmux mc ranger htop fastfetch dialog w3m w3m-img links2 nmtui firefox-esr xorg doas git curl

# Настройка doas вместо sudo
echo "Настройка doas..."
echo "permit persist :wheel" > /etc/doas.conf
# Удаляем sudo (опционально, можно оставить)
# apt remove sudo -y

# Создание пользователя (если нужно, но обычно уже есть)
# read -p "Имя пользователя: " username
# adduser $username
# usermod -aG wheel $username

# Копирование файлов NeoLinux в домашнюю директорию первого обычного пользователя
# Находим первого пользователя с UID >= 1000
USER_HOME=$(getent passwd {1000..60000} | cut -d: -f6 | head -1)
if [ -z "$USER_HOME" ]; then
    echo "Ошибка: Не найден обычный пользователь. Создайте его вручную."
    exit 1
fi

USERNAME=$(basename "$USER_HOME")

echo "Установка для пользователя: $USERNAME ($USER_HOME)"

# textdesk.sh
cat > "$USER_HOME/textdesk.sh" << 'EOF'
#!/bin/bash

while true; do
    clear
    fastfetch

    echo
    echo "Система готова. Меню через 7 секунд..."
    sleep 7

    choice=$(dialog --clear --title "NeoLinux Desktop" \
        --menu "Выбери действие (мышь или клавиши):" 24 70 12 \
        1 "Файловый менеджер (mc)" \
        2 "Файлы (ranger)" \
        3 "Мониторинг (htop)" \
        4 "Карта мира (mapscii)" \
        5 "Браузер (w3m)" \
        6 "Графический браузер (Firefox)" \
        7 "Настройка сети (nmtui)" \
        8 "Терминалы (tmux)" \
        9 "О системе (fastfetch)" \
        10 "Чистый терминал (bash)" \
        11 "Выключение" \
        12 "Перезагрузка" \
        3>&1 1>&2 2>&3)

    clear
    case $choice in
        1) mc ;;
        2) ranger ;;
        3) htop ;;
        4) mapscii ;;
        5) w3m https://duckduckgo.com ;;
        6) startx firefox ;;
        7) nmtui ;;
        8) tmux new-session -s main ;;
        9) fastfetch; echo; read -p "Нажми Enter..." ;;
        10) bash ;;
        11) doas poweroff ;;
        12) doas reboot ;;
        *) clear; echo "Выход... Пока!"; exit ;;
    esac

    echo
    echo "Нажми Enter для возврата в меню..."
    read -r
done
EOF

chmod +x "$USER_HOME/textdesk.sh"
chown $USERNAME:$USERNAME "$USER_HOME/textdesk.sh"

# fastfetch config
mkdir -p "$USER_HOME/.config/fastfetch"
cat > "$USER_HOME/.config/fastfetch/config.jsonc" << 'EOF'
{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
        "type": "raw",
        "source": "πππππππππππππππππππππππππππ πππππππππππππππππππππππππππ \n ππππππππππππππππππ                   ππππππππππππππππππ \n ππππππππππππππ         πππππππππ          ππππππππππππππ \n ππππππππππππ       √÷-+++++++++++-÷√       ππππππππ  ππ \n
ππππππππππ     π≠-+++++++++++++++++++-≠π     πππ    πππ \n
ππππππππ     √×+++++++++++++++++++++++++×√       ππππππ \n
πππππππ    π÷++++++++++++++++++++++++++++≠π      ππππππ \n
ππππππ    ≈+++++++++++++++++++++++++++-∞π        ππππππ \n
ππππ     ≠++++++++++++++++++++++++++÷π    π√×≠     ππππ \n
ππππ    ≈+++++++++++++++++++++++++≠π    π≈++++≠    ππππ \n
πππ    √+++++++++++++++++++++++×∞     √÷+++++++∞    πππ \n
πππ    =+++++++++++++++++++++÷π    π∞-+++++++++=    πππ \n
ππ     -+++++++++++++++++++≈π    π≠++++++++++++-     ππ \n
ππ     +++++++++++++++++×∞     √÷+++++++++++++++     ππ \n
ππ     +++++++++++++++÷π     ∞-+++++++++++++++++     ππ \n
ππ     -++++++++++++≈      ≠+++++++++++++++++++-     ππ \n
πππ    =+++++++++×√π    √×+++++++++++++++++++++=    πππ \n
πππ    √+++++++=π    π≈-+++++++++++++++++++++++∞    πππ \n
ππππ    ≠++++∞      ≠+++++++++++++++++++++++++≠    ππππ \n
ππππ     ≠÷√π    √×++++++++++++++++++++++++++≠     ππππ \n
ππππππ        π≈-+++++++++++++++++++++++++++≠    ππππππ \n
πππππππ     π=++++++++++++++++++++++++++++×π    πππππππ \n
πππππ        √×+++++++++++++++++++++++++×√     ππππππππ \n
πππ    πππ     π≠-+++++++++++++++++++-≠π     ππππππππππ \n
ππ   πππππππ       √÷-+++++++++++-÷√       ππππππππππππ \n
ππππππππππππππ         πππ√√√πππ         ππππππππππππππ \n
ππππππππππππππππππ                   ππππππππππππππππππ \n
πππππππππππππππππππππππππππ πππππππππππππππππππππππππππ",
        "padding": {
            "top": 1,
            "left": 2
        }
    },
    "display": {
        "separator": " : "
    },
    "modules": [
        "title",
        "separator",
        "os",
        "host",
        "kernel",
        "uptime",
        "packages",
        "shell",
        "terminal",
        "cpu",
        "gpu",
        "memory",
        "disk",
        "break",
        "colors"
    ]
}
EOF

chown -R $USERNAME:$USERNAME "$USER_HOME/.config/fastfetch"

# Автозапуск textdesk.sh после логина
echo "exec ~/textdesk.sh" >> "$USER_HOME/.bash_profile"
chown $USERNAME:$USERNAME "$USER_HOME/.bash_profile"

echo
echo "========================================"
echo "NeoLinux успешно установлен!"
echo "Перезагрузись или выйди/войди в систему."
echo "После логина увидишь TUI-десктоп."
echo "========================================"

exit 0
