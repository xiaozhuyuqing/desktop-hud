set(QT5_ROOT "${THIRD_PARTY_DIR}/qt5")
set(QT5_PLATFORM_DIR "${QT5_ROOT}/${CMAKE_LIBRARY_ARCHITECTURE}")
set(QT5_LIB_DIR "${QT5_PLATFORM_DIR}/lib")

list(PREPEND CMAKE_PREFIX_PATH "${QT5_PLATFORM_DIR}")

function(deploy_qt5 target)
    file(GLOB QT5_RUNTIME_LIBS "${QT5_LIB_DIR}/libQt5*.so.5")
    add_custom_command(TARGET ${target} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${QT5_RUNTIME_LIBS}
            "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/"
        COMMAND ${CMAKE_COMMAND} -E make_directory
            "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/platforms"
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${QT5_PLATFORM_DIR}/lib/qt5/plugins/platforms/libqxcb.so"
            "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/platforms/"
    )
endfunction()
