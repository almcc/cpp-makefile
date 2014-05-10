#include "alpha/CalculatorTest.h"

CPPUNIT_TEST_SUITE_REGISTRATION( CalculatorTest );

namespace alpha
{
    void CalculatorTest::setUp()
    {
        this->obj = new Calculator();
    }

    void CalculatorTest::testSanity()
    {
        CPPUNIT_ASSERT_EQUAL(true, true);
    }

    void CalculatorTest::testAddition()
    {
        CPPUNIT_ASSERT_EQUAL(this->obj->add(1,3), 4);
        CPPUNIT_ASSERT_EQUAL(this->obj->add(0,3), 3);
        CPPUNIT_ASSERT_EQUAL(this->obj->add(-1,3), 2);
        CPPUNIT_ASSERT_EQUAL(this->obj->add(0,0), 0);
        CPPUNIT_ASSERT_EQUAL(this->obj->add(1,-3), -2);
    }

    void CalculatorTest::tearDown()
    {
        delete this->obj;
    }
}
