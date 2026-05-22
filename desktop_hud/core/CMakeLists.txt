# Core SDK - shared library that plugins link against

add_library(desktop_hud_core SHARED
    component.cpp
    component_factory.cpp
)

target_include_directories(desktop_hud_core PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(desktop_hud_core PUBLIC yaml-cpp)

# Deploy SDK .so to output/lib for RPATH resolution
add_custom_command(TARGET desktop_hud_core POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    $<TARGET_FILE:desktop_hud_core>
    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/
)
