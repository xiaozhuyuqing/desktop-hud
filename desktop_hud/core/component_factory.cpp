#include "base.h"

namespace yuqing {

FactoryMap& getFactoryMap() {
    static FactoryMap instance;
    return instance;
}

} // namespace yuqing
