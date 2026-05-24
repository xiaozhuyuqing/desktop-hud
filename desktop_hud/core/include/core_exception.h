#pragma once

#include <exception>
#include <string>

namespace yuqing {

class CoreException : public std::exception {
public:
    explicit CoreException(const std::string& msg);
    const char* what() const noexcept override;

private:
    std::string msg_;
};

class ComponentInitException : public CoreException {
public:
    explicit ComponentInitException(const std::string& component, const std::string& reason);
};

class ComponentRuntimeException : public CoreException {
public:
    explicit ComponentRuntimeException(const std::string& component, const std::string& reason);
};

}  // namespace yuqing
