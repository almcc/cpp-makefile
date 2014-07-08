#include "alpha/Calculator.h"

namespace alpha {
    Calculator::Calculator() {}
    Calculator::~Calculator() {}

    /**
     * It just uses the built in + operator for integers.
     */
    int Calculator::add(int first, int second) {
        return first + second;
    }
}  // namespace alpha
