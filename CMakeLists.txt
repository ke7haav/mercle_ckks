cmake_minimum_required(VERSION 3.16)
project(mercle_he_demo CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2 -march=native")

# Expect OpenFHE to be installed / findable via CMake. If you built OpenFHE from source,
# set CMAKE_PREFIX_PATH to its install dir.
find_package(OpenFHE CONFIG REQUIRED)

add_executable(demo src/demo.cpp)
# Include OpenFHE headers
target_include_directories(demo PRIVATE /usr/local/include /usr/local/include/openfhe/pke /usr/local/include/openfhe/core /usr/local/include/openfhe/binfhe /usr/local/include/openfhe)
# Link OpenFHE libs using targets (this should set up proper include paths)
target_link_libraries(demo PRIVATE OPENFHEpke OPENFHEcore OPENFHEbinfhe)
