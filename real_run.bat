@echo off
echo Starting QEMU with options old computer
qemu-system-i386 -machine pc -drive file=os.bin,format=raw,if=ide -net none -m 64 -vga std