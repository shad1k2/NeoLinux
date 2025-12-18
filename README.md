# Im wanna found a co-developer for NeoLinux Project
# NeoLinux

**Минималистичный TUI-десктоп на базе Debian**

NeoLinux — это кастомная надстройка над минимальной установкой Debian, превращающая систему в полноценный терминал-десктоп. Всё работает в консоли: меню с мышью, файловые менеджеры, браузер, мониторинг, карта мира — без тяжёлых графических окружений вроде KDE или GNOME.

Цель проекта — быстрый, лёгкий и удобный терминал для кодинга, серфинга и повседневных задач.

![NeoLinux screenshot](screenshots/menu.png)  
*(скрин меню textdesk.sh — добавь свой позже)*

## Особенности

- Кастомный TUI-десктоп на Bash + dialog (мышь поддерживается)
- Автозапуск после логина
- fastfetch с кастомным ASCII-логотипом
- Предустановленные TUI-приложения:
  - `mc` и `ranger` — файловые менеджеры
  - `htop` — мониторинг процессов
  - `mapscii` — интерактивная карта мира
  - `w3m` — текстовый браузер
  - `nmtui` — настройка сети
  - `tmux` — мультиплексор терминалов
  - Firefox через bare X11 (по запросу)
- doas вместо sudo
- Полностью в терминале — минимум ресурсов

## Установка

1. Установи минимальную Debian 13 (netinstall или server ISO)
2. Скачай и запусти установочный скрипт:
   ```bash
   wget https://raw.githubusercontent.com/shad1k2/NeoLinux/main/install_neolinux.sh
   chmod +x install_neolinux.sh
   ./install_neolinux.sh
