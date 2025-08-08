# Документация к LosOS

LosOS - дистрибутив PidOS. Основана на KillerGrass OS. Автор идеи - losos, вклад в разработку: Findix, программист - KillerGrass.

# Характеристики

- **BIOS прерывания** - Для ввода и вывода
- **16 битный режим**
- **MBR загрузчик**
- **Модульность** - легко подключить команду или драйвер.
- **Лёгкость** - Всё закомментировано, модульность, простота.

# Сборка

# Windows

```bash
build.bat
```

Или запустите build.bat

## Linux

```bash
chmod +x build.sh
./build.sh
```

# Запуск

## Windows

Запустите run.bat

## Linux

```bash
qemu-system-i386 -drive format=raw,file=os.bin
```

Или

```bash
chmod +x run.sh
./run.sh
```

# Запуск с параметрами старого компьютера

## Windows

```bash
qemu-system-i386 -machine pc -drive file=os.bin,format=raw,if=ide -net none -m 64 -vga std
```

Или запустите real_run.bat

## Linux

```bash
qemu-system-i386 -machine pc -drive file=os.bin,format=raw,if=ide -net none -m 64 -vga std
```

Или

```bash
chmod +x real_run.sh
./real_run.sh
```

# Создание своего дистрибутива

Для создания своего дистрибутива требуется знание ассемблера и работы с ОС. Здесь инструкция для продвинутых пользователей.

Клонируйте репозиторий к себе на диск. Вы должны увидеть такую структуру:

```
LosOS/
|-kernel/
  |-programs/
    |...
  |-commands/
    |...
  |-main.asm
|-boot.asm
|-VERSION
```

*Здесь написаны только нужные файлы и папки, а так же сокращенно*

Пример команды которая выводит текст:

```asm
check_sas:
    mov di, .command
    call strcmp ; сравнивает строки
    jne .skip
    
    mov si, .sas_msg
    call print
    mov byte [cmd_handled], 1 ; флаг, что команда выполнилась
.skip:
    ret

.command db "sas", 0 ; текст который нужно ввести в консоли чтобы сработала эта команда
.sas_msg db "LosOS v1.0", 0x0D, 0x0A, 0
```

Затем подключите команду в `kernel/main.asm`:

```asm
%include "commands/sas.asm"
```

И добавьте в handle_command call:

```asm
call check_sas
```

Готово! Команда добавлена.

# Вызов команда из другой команды

Вызов команды происходит так:

```asm
mov si, ses_command ; загружаем команду которую хотим выполнить (ses)
call execute_command
```

То есть загружается в регистр команда которую нужно выполнить и вызывается функция execute_command для выполнения.

Автор идеи ОС и названий команд - losos
Делал вклад в разработку - Findix
Главный (и единственный) программист - KillerGrass (создатель KillerGrass OS)