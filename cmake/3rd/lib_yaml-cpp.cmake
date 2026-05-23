set(YAML_CPP_ROOT "${THIRD_PARTY_DIR}/${HUD_ARCH_DIR}/yaml-cpp")
set(YAML_CPP_INCLUDE_DIR "${YAML_CPP_ROOT}/include")
set(YAML_CPP_LIB_DIR "${YAML_CPP_ROOT}/lib")

if(NOT EXISTS "${YAML_CPP_INCLUDE_DIR}/yaml-cpp/yaml.h")
    message(FATAL_ERROR "yaml-cpp not found at ${YAML_CPP_ROOT}, run: cd 3rd && ./setup.sh yaml-cpp")
endif()

add_library(yaml-cpp SHARED IMPORTED)

if(WIN32)
    set_target_properties(yaml-cpp PROPERTIES
        IMPORTED_LOCATION "${YAML_CPP_LIB_DIR}/yaml-cpp${CMAKE_SHARED_LIBRARY_SUFFIX}"
        INTERFACE_INCLUDE_DIRECTORIES "${YAML_CPP_INCLUDE_DIR}"
    )
    if(MSVC AND EXISTS "${YAML_CPP_LIB_DIR}/yaml-cpp.lib")
        set_target_properties(yaml-cpp PROPERTIES
            IMPORTED_IMPLIB "${YAML_CPP_LIB_DIR}/yaml-cpp.lib"
        )
    endif()
else()
    set_target_properties(yaml-cpp PROPERTIES
        IMPORTED_LOCATION "${YAML_CPP_LIB_DIR}/libyaml-cpp${CMAKE_SHARED_LIBRARY_SUFFIX}"
        INTERFACE_INCLUDE_DIRECTORIES "${YAML_CPP_INCLUDE_DIR}"
    )
endif()

function(deploy_yaml_cpp target)
    if(WIN32)
        add_custom_command(TARGET ${target} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${YAML_CPP_LIB_DIR}/yaml-cpp${CMAKE_SHARED_LIBRARY_SUFFIX}"
            "${HUD_DEPLOY_LIB_DIR}/"
        )
    else()
        add_custom_command(TARGET ${target} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${YAML_CPP_LIB_DIR}/libyaml-cpp${CMAKE_SHARED_LIBRARY_SUFFIX}.0.7.0"
            "${HUD_DEPLOY_LIB_DIR}/"
            COMMAND ${CMAKE_COMMAND} -E remove -f
            "${HUD_DEPLOY_LIB_DIR}/libyaml-cpp${CMAKE_SHARED_LIBRARY_SUFFIX}.0.7"
            COMMAND ${CMAKE_COMMAND} -E create_symlink
            "libyaml-cpp${CMAKE_SHARED_LIBRARY_SUFFIX}.0.7.0"
            "${HUD_DEPLOY_LIB_DIR}/libyaml-cpp${CMAKE_SHARED_LIBRARY_SUFFIX}.0.7"
        )
    endif()
endfunction()
