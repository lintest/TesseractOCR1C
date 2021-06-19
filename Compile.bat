mkdir build32
cd build32
cmake .. -A Win32 -DMySuffix2=32
cmake --build . --config Release
cd ..

mkdir build64
cd build64
cmake .. -A x64 -DMySuffix2=64
cmake --build . --config Release
cd ..
