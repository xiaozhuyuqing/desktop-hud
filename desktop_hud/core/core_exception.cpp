#include "include/core_exception.h"

namespace yuqing {

CoreException::CoreException(const std::string& msg) : msg_(msg) {}

const char* CoreException::what() const noexcept {
    return msg_.c_str();
}

ComponentInitException::ComponentInitException(const std::string& component, const std::string& reason)
    : CoreException("[" + component + "] init failed: " + reason) {}

ComponentRuntimeException::ComponentRuntimeException(const std::string& component, const std::string& reason)
    : CoreException("[" + component + "] runtime error: " + reason) {}

}  // namespace yuqing
