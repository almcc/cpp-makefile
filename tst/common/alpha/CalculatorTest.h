#ifndef alpha_CalculatorTest_H
#define alpha_CalculatorTest_H

#include <cppunit/extensions/HelperMacros.h>

#include "alpha/Calculator.h"

using namespace std;
using namespace alpha;

namespace alpha
{
    class CalculatorTest : public CppUnit::TestFixture
    {
      public:
        void setUp();
        void testSanity();
        void testAddition();
        void tearDown();

        CPPUNIT_TEST_SUITE( CalculatorTest );
        CPPUNIT_TEST( testSanity );
        CPPUNIT_TEST( testAddition );
        CPPUNIT_TEST_SUITE_END();

      private:
        Calculator* obj;

    };

}

#endif
