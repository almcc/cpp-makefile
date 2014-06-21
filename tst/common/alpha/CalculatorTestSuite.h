#include <cxxtest/TestSuite.h>
#include <alpha/Calculator.h>

class CalculatorTestSuite : public CxxTest::TestSuite
{
public:

    void setUp(void)
    {
        this->calc = new alpha::Calculator();
    }

    void testAddition(void)
    {
        alpha::Calculator calc;
        TS_ASSERT_EQUALS(calc.add(1,1), 2);
        TS_ASSERT_EQUALS(calc.add(1,-1), 0);
    }

    void tearDown(void)
    {
        delete this->calc;
    }

protected:

    alpha::Calculator* calc;

};
