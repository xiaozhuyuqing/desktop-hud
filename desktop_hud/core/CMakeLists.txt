# Core SDK - shared library that plugins link against

if(WIN32)
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
endif()

add_library(desktop_hud_core SHARED
    component.cpp
    component_factory.cpp
    core_exception.cpp
)

target_include_directories(desktop_hud_core PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(desktop_hud_core PUBLIC yaml-cpp)
if(MSVC)
    target_compile_options(desktop_hud_core PRIVATE /utf-8)
endif()

add_custom_command(TARGET desktop_hud_core POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    $<TARGET_FILE:desktop_hud_core>
    ${HUD_DEPLOY_LIB_DIR}/
)
