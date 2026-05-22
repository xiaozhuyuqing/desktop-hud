#pragma once

#include <filesystem>
#include <memory>

#include "component.h"

namespace yuqing{

class ComponentFactoryBase {
public:
    virtual std::shared_ptr<Component> getInstance(const std::string& name) = 0;
};


template <typename T>
class ComponentFactory : public ComponentFactoryBase{
public:
    std::shared_ptr<Component> getInstance(const std::string& name) override
    {
        return std::make_shared<T>(name);
    }
};

}
