mkdir build32
cd build32Win
cmake .. -A Win32 -DMySuffix2=32
cmake --build . --config Release
cd ..

mkdir build64
cd build64Win
cmake .. -A x64 -DMySuffix2=64
cmake --build . --config Release
cd ..
