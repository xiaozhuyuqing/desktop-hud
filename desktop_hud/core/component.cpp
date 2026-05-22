#include "component.h"

namespace yuqing{
    
ComponentBase::ComponentBase(const std::string &name): name_(name)
{}

void ComponentBase::init(const std::filesystem::path &config_path)
{
    config_path_ = config_path;
    try {
        config_node_ = YAML::LoadFile(config_path_);
    } catch (const YAML::Exception& e) {
        // TO DO 输出日志和异常，等待外界捕获
    }
}

} // namespace yuqing