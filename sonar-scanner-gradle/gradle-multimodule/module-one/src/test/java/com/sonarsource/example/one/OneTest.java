package com.sonarsource.example.one;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class OneTest {

  private final One one = new One("Hello");

  @Test
  void greetsByName() {
    assertEquals("Hello, Sonar!", one.greet("Sonar"));
  }

  @Test
  void fallsBackToWorldWhenNameIsMissing() {
    assertEquals("Hello, world!", one.greet(null));
    assertEquals("Hello, world!", one.greet("   "));
  }
}
