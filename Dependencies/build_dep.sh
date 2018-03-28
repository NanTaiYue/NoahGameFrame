echo Building dependencies...

unzip --version
if [ $? -ne 0 ]; then
    echo "[ERROR] Please install cmake first."
    echo "apt-get install zip unzip"
    exit 1
fi

mkdir -p lib/Debug/
mkdir -p lib/Release/

# compiling libevent
cd libevent
chmod +x ./configure
./configure CPPFLAGS=-fPIC --disable-shared --disable-openssl
make

cp -R -f ./.libs/*.a ../lib/Debug/
cp -R -f ./.libs/*.a ../lib/Release/

cd ../


# compiling protobuf
cd protobuf
chmod -R 755 *
./configure CXXFLAGS=-fPIC
make
make check

cp -r -f ./src/.libs/*.a ../lib/Debug/
cp -r -f ./src/.libs/*.a ../lib/Release/

cp -r -f ./src/.libs/*.so ../../_Out/Debug/
cp -r -f ./src/.libs/*.so.* ../../_Out/Debug/
cp -r -f ./src/.libs/*.so ../../_Out/Release/
cp -r -f ./src/.libs/*.so.* ../../_Out/Release/

cp -r -f ./src/.libs/*.dylib ../../_Out/Debug/
cp -r -f ./src/.libs/*.dylib.* ../../_Out/Debug/
cp -r -f ./src/.libs/*.dylib ../../_Out/Release/
cp -r -f ./src/.libs/*.dylib.* ../../_Out/Release/

cd ../

# compiling Theron
cd Theron
chmod -R 755 *
make library mode=debug boost=off c++11=on posix=on shared=on
cp -r -f ./Lib/*.a ../lib/Debug/

make clean
make library mode=release boost=off c++11=on posix=on shared=on
cp -r -f ./Lib/*.a ../lib/Release/
make clean
cd ../


# TODO: other libs
unzip -o gperftools-2.5.zip -d ./
cd gperftools-2.5
chmod -R 755 *
./configure --enable-frame-pointers
make
make install
cd ../


# back to main dir
pwd
