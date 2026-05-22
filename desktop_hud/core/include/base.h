#pragma once

#include <map>

#include "component_factory.h"

namespace yuqing {

using FactoryMap = std::map<std::string, ComponentFactoryBase*>;

FactoryMap& getFactoryMap();

template <typename T>
void registClass(const std::string& class_name) {
    if (getFactoryMap().count(class_name)) {
        return;
    }
    getFactoryMap()[class_name] = new ComponentFactory<T>();
}

} // namespace yuqing

#define MINIHUD_COMPONENT_IMPL(name, counter) \
namespace { \
    struct ComponentRegister##counter { \
        ComponentRegister##counter() { \
            yuqing::registClass<name>(#name); \
        } \
    }; \
    static ComponentRegister##counter register_##counter; \
}

#define MINIHUD_COMPONENT(name) MINIHUD_COMPONENT_IMPL(name, __COUNTER__)