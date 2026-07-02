#include "cppproject/mathutils.h"

#include <stdexcept>

namespace cppproject {

int add(int a, int b) {
    return a + b;
}

long long factorial(int n) {
    if (n < 0) {
        throw std::invalid_argument("n must be non-negative");
    }

    long long result = 1;
    for (int i = 2; i <= n; ++i) {
        result *= i;
    }

    return result;
}

bool is_prime(int n) {
    if (n < 2) {
        return false;
    }

    for (int i = 2; static_cast<long long>(i) * i <= n; ++i) {
        if (n % i == 0) {
            return false;
        }
    }

    return true;
}

}  // namespace cppproject
