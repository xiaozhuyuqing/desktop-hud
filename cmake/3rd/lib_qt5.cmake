set(QT5_ROOT "${THIRD_PARTY_DIR}/${HUD_ARCH_DIR}/qt5")
set(QT5_PLATFORM_DIR "${QT5_ROOT}")
set(QT5_LIB_DIR "${QT5_PLATFORM_DIR}/lib")

if(EXISTS "${QT5_PLATFORM_DIR}")
    list(PREPEND CMAKE_PREFIX_PATH "${QT5_PLATFORM_DIR}")
endif()

function(deploy_qt5 target)
    set(DEPLOY_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/deploy_qt5_${target}.cmake")

    if(WIN32)
        file(WRITE "${DEPLOY_SCRIPT}"
            "set(QT5_MODULES Qt5Core Qt5Gui Qt5Widgets Qt5Svg)
            set(QT5_DIRS \"${QT5_LIB_DIR}\" \"${QT5_PLATFORM_DIR}/bin\")
            foreach(mod IN LISTS QT5_MODULES)
                foreach(dir IN LISTS QT5_DIRS)
                    if(EXISTS \"\${dir}/\${mod}.dll\")
                        execute_process(COMMAND \"\${CMAKE_COMMAND}\" -E copy_if_different
                            \"\${dir}/\${mod}.dll\" \"${HUD_DEPLOY_LIB_DIR}/\${mod}.dll\")
                    endif()
                endforeach()
            endforeach()
            execute_process(COMMAND \"\${CMAKE_COMMAND}\" -E make_directory
                \"${HUD_DEPLOY_LIB_DIR}/platforms\")
            execute_process(COMMAND \"\${CMAKE_COMMAND}\" -E copy_if_different
                \"${QT5_PLATFORM_DIR}/plugins/platforms/qwindows.dll\"
                \"${HUD_DEPLOY_LIB_DIR}/platforms/\")
            if(EXISTS \"${QT5_PLATFORM_DIR}/plugins/imageformats\")
                file(COPY \"${QT5_PLATFORM_DIR}/plugins/imageformats/\"
                    DESTINATION \"${HUD_DEPLOY_LIB_DIR}/imageformats/\")
            endif()
            if(EXISTS \"${QT5_PLATFORM_DIR}/plugins/platforminputcontexts\")
                file(COPY \"${QT5_PLATFORM_DIR}/plugins/platforminputcontexts/\"
                    DESTINATION \"${HUD_DEPLOY_LIB_DIR}/platforminputcontexts/\")
            endif()"
        )
    else()
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
                        \"\${dep}\" \"${HUD_DEPLOY_LIB_DIR}/\${name}\")
                endif()
            endforeach()
            execute_process(COMMAND \"\${CMAKE_COMMAND}\" -E make_directory
                \"${HUD_DEPLOY_LIB_DIR}/platforms\")
            execute_process(COMMAND \"\${CMAKE_COMMAND}\" -E copy_if_different
                \"${QT5_PLATFORM_DIR}/lib/qt5/plugins/platforms/libqxcb.so\"
                \"${HUD_DEPLOY_LIB_DIR}/platforms/\")"
        )
    endif()

    add_custom_command(TARGET ${target} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -DTARGET_FILE="$<TARGET_FILE:${target}>" -P "${DEPLOY_SCRIPT}"
    )
endfunction()
