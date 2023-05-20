sudo pacman -S nasm yasm virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat base-devel bison flex gmp libmpc mpfr texinfo
export PREFIX="/usr/local/i386elfgcc"
export TARGET=i386-elf
export PATH="$PREFIX/bin:$PATH"

# using /GCC because failed at /tmp ( no space left )
[ ! -f /GCC/src ] && sudo mkdir -p /GCC/src
cd /GCC/src
curl -O http://ftp.gnu.org/gnu/binutils/binutils-2.39.tar.gz #44mb
tar xf binutils-2.39.tar.gz
mkdir binutils-build
cd binutils-build
../binutils-2.39/configure --target=$TARGET --enable-interwork --enable-multilib --disable-nls --disable-werror --prefix=$PREFIX 2>&1 | tee configure.log
sudo make all install 2>&1 | tee make.log

cd /GCC/src
curl -O https://ftp.gnu.org/gnu/gcc/gcc-12.2.0/gcc-12.2.0.tar.gz #140mb
tar xf gcc-12.2.0.tar.gz
mkdir gcc-build
cd gcc-build
echo Configure: . . . . . . .
../gcc-12.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --disable-libssp --enable-language=c,c++ --without-headers
echo MAKE ALL-GCC:
sudo make all-gcc
echo MAKE ALL-TARGET-LIBGCC:
sudo make all-target-libgcc
echo MAKE INSTALL-GCC:
sudo make install-gcc
echo MAKE INSTALL-TARGET-LIBGCC:
sudo make install-target-libgcc
echo HERE U GO MAYBE:
ls /usr/local/i386elfgcc/bin
export PATH="$PATH:/usr/local/i386elfgcc/bin"
