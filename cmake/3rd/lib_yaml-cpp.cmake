set(YAML_CPP_ROOT "${THIRD_PARTY_DIR}/${CMAKE_LIBRARY_ARCHITECTURE}/yaml-cpp")
set(YAML_CPP_INCLUDE_DIR "${YAML_CPP_ROOT}/include")
set(YAML_CPP_LIB_DIR "${YAML_CPP_ROOT}/lib")

if(NOT EXISTS "${YAML_CPP_INCLUDE_DIR}/yaml-cpp/yaml.h")
    message(FATAL_ERROR "yaml-cpp not found at ${YAML_CPP_ROOT}, run: cd 3rd && ./setup.sh yaml-cpp")
endif()

add_library(yaml-cpp SHARED IMPORTED)
set_target_properties(yaml-cpp PROPERTIES
    IMPORTED_LOCATION "${YAML_CPP_LIB_DIR}/libyaml-cpp.so"
    INTERFACE_INCLUDE_DIRECTORIES "${YAML_CPP_INCLUDE_DIR}"
)

function(deploy_yaml_cpp target)
    add_custom_command(TARGET ${target} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${YAML_CPP_LIB_DIR}/libyaml-cpp.so.0.7.0"
        "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/"
        COMMAND ${CMAKE_COMMAND} -E remove -f
        "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libyaml-cpp.so.0.7"
        COMMAND ${CMAKE_COMMAND} -E create_symlink
        "libyaml-cpp.so.0.7.0"
        "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libyaml-cpp.so.0.7"
    )
endfunction()
