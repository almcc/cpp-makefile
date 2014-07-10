#ifndef SRC_COMMON_ALPHA_CALCULATOR_H_
#define SRC_COMMON_ALPHA_CALCULATOR_H_

namespace alpha {
    class Calculator {
     public:
        Calculator();
        ~Calculator();

        /**
         *  add function
         * @param  first  First argument
         * @param  second Second argument
         * @return        Sum of both arguments
         */
        int add(int first, int second);
    };
}  // namespace alpha

#endif  // SRC_COMMON_ALPHA_CALCULATOR_H_
