if [ ! -d "build" ]; then
	mkdir build
fi

cd build
cmake -A x64 -DCMAKE_BUILD_TYPE=Release ..
cmake --build . --config Release
cd ..

if [ ! -d "../ZBin" ]; then
	mkdir ../ZBin
fi
cp bin/Crazy.exe ../ZBin