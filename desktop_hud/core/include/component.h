#pragma once

#include <filesystem>
#include <yaml-cpp/yaml.h>

namespace yuqing{

class ComponentBase{
public:
    ComponentBase(const std::string& name);
    virtual void init(const std::filesystem::path& config_path);
protected:
    std::filesystem::path config_path_;
    YAML::Node config_node_;
    std::string name_;
};

class Component: public ComponentBase{
public:
    virtual void config() = 0;
    virtual void show() = 0;
};

}