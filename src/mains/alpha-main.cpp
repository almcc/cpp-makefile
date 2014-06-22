#include "./Release.h"
#include "alpha/Calculator.h"

int main(int const argc, const char ** const argv)
{
    alpha::Calculator calc;
    return calc.add(1, -1);
}
