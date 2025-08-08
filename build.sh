echo "[1/3] Building bootloader..."
nasm -f bin boot.asm -o boot.bin

echo "[2/3] Building kernel..."
nasm -f bin kernel/main.asm -o kernel.bin -ikernel/ -ilib/

echo "[3/3] Creating disk image..."
dd if=/dev/zero of=padding.bin bs=1 count=4096 2>/dev/null
cat boot.bin kernel.bin padding.bin > os.bin
rm -f padding.bin

echo
echo "File sizes:"
echo "- Bootloader: $(stat -c%s boot.bin) bytes"
echo "- Kernel: $(stat -c%s kernel.bin) bytes"
echo "- Disk image: $(stat -c%s os.bin) bytes"