#include <iostream>

#include "Release.h"

#include "alpha/Calculator.h"


using namespace std;
using namespace alpha;

int main(int const argc, const char ** const argv)
{
    cout << "Release: " << RELEASE << endl;
    Calculator calc;
    cout << "1 + 3 = " << calc.add(1, 3) << endl;
}