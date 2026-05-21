cmake_minimum_required(VERSION 3.10)
project(mainboard CXX)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_BUILD_RPATH "$ORIGIN")
set(CMAKE_INSTALL_RPATH "$ORIGIN")

find_3rd_package(qt5)
find_package(Qt5 COMPONENTS Widgets REQUIRED)

list(APPEND CMAKE_AUTOUIC_SEARCH_PATHS ${PROJECT_SOURCE_DIR}/ui)

file(GLOB SOURCE_FILE
    ${PROJECT_SOURCE_DIR}/*.cpp
    ${PROJECT_SOURCE_DIR}/include/*.h
    ${PROJECT_SOURCE_DIR}/ui/*.ui
)
file(GLOB RESOURCE_FILE ${PROJECT_SOURCE_DIR}/*.qrc)

add_executable(mainboard ${SOURCE_FILE} ${RESOURCE_FILE})

target_link_libraries(mainboard Qt5::Widgets)
target_include_directories(mainboard PRIVATE ${PROJECT_SOURCE_DIR}/include)
# 使用 RPATH 替代 RUNPATH，使 $ORIGIN 搜索对依赖库也生效
target_link_options(mainboard PRIVATE "LINKER:--disable-new-dtags")

deploy_qt5(mainboard)
