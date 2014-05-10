#ifndef alpha_Calculator_H
#define alpha_Calculator_H

using namespace std;

namespace alpha
{
    class Calculator
    {
        friend class CalculatorTest;

        public:
            Calculator();
            ~Calculator();

            int add(int a, int b);
    };
}

#endif
