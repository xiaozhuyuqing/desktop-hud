# 集中式构建后部署，统一定义 deploy 逻辑

function(deploy_runtime target)
    set(CLEANUP_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/cleanup_qt5_${target}.cmake")
    file(WRITE "${CLEANUP_SCRIPT}"
        "file(GLOB old_qt5 \"${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libQt5*.so*\")
        foreach(f IN LISTS old_qt5)
            file(REMOVE \"\${f}\")
        endforeach()"
    )
    add_custom_command(TARGET ${target} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -P "${CLEANUP_SCRIPT}"
    )

    deploy_qt5(${target})
    deploy_yaml_cpp(${target})
endfunction()
