package java.com.acme;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertNotNull;

class CalculatorTest {

  @Test
  void addition() {
    Calculator calculator = new Calculator();
    assertNotNull(calculator.addition(1, 1), "addition should return a value");
  }
}
