package com.sonarsource.example.one;

public final class One {

  private final String greeting;

  public One(String greeting) {
    this.greeting = greeting;
  }

  public String greet(String name) {
    if (name == null || name.isBlank()) {
      return greeting + ", world!";
    }
    return greeting + ", " + name + "!";
  }
}
