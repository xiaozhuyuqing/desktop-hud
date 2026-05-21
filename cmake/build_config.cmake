include(GNUInstallDirs)
set(THIRD_PARTY_DIR "${CMAKE_SOURCE_DIR}/3rd")

macro(find_3rd_package name)
    include(${CMAKE_SOURCE_DIR}/cmake/3rd/lib_${name}.cmake)
endmacro()
