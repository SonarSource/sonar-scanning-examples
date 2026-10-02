package com.sonarsource.example.two;

import static org.junit.jupiter.api.Assertions.assertEquals;

import com.sonarsource.example.one.One;
import java.util.List;
import org.junit.jupiter.api.Test;

class TwoTest {

  @Test
  void greetsEveryName() {
    Two two = new Two();

    assertEquals(List.of("Hello, Sonar!", "Hello, Gradle!"), two.greetAll(List.of("Sonar", "Gradle")));
  }

  @Test
  void usesTheSuppliedGreeting() {
    Two two = new Two(new One("Bonjour"));

    assertEquals(List.of("Bonjour, Sonar!"), two.greetAll(List.of("Sonar")));
  }

  @Test
  void greetsNobody() {
    Two two = new Two();

    assertEquals(List.of(), two.greetAll(List.of()));
  }
}
