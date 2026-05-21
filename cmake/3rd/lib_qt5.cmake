set(QT5_ROOT "${THIRD_PARTY_DIR}/qt5")
set(QT5_PLATFORM_DIR "${QT5_ROOT}/${CMAKE_LIBRARY_ARCHITECTURE}")
set(QT5_LIB_DIR "${QT5_PLATFORM_DIR}/lib")

list(PREPEND CMAKE_PREFIX_PATH "${QT5_PLATFORM_DIR}")

function(deploy_qt5 target)
    set(DEPLOY_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/deploy_qt5_${target}.cmake")
    file(
        WRITE "${DEPLOY_SCRIPT}"
        "file(GET_RUNTIME_DEPENDENCIES
            EXECUTABLES \"\${TARGET_FILE}\"
            RESOLVED_DEPENDENCIES_VAR QT5_DEPS
            DIRECTORIES \"${QT5_LIB_DIR}\"
            PRE_INCLUDE_REGEXES \"libQt5.*\"
        )
        foreach(dep IN LISTS QT5_DEPS)
            get_filename_component(name \"\${dep}\" NAME)
            if(name MATCHES \"^libQt5\")
                execute_process(COMMAND \"\${CMAKE_COMMAND}\" -E copy_if_different
                    \"\${dep}\" \"${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/\${name}\")
            endif()
        endforeach()
        execute_process(COMMAND \"\${CMAKE_COMMAND}\" -E make_directory
            \"${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/platforms\")
        execute_process(COMMAND \"\${CMAKE_COMMAND}\" -E copy_if_different
            \"${QT5_PLATFORM_DIR}/lib/qt5/plugins/platforms/libqxcb.so\"
            \"${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/platforms/\")"
    )

    add_custom_command(TARGET ${target} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -DTARGET_FILE="$<TARGET_FILE:${target}>" -P "${DEPLOY_SCRIPT}"
    )
endfunction()
