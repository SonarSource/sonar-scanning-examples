package com.sonarsource.example.two;

import com.sonarsource.example.one.One;
import java.util.List;

public final class Two {

  private final One one;

  public Two() {
    this(new One("Hello"));
  }

  public Two(One one) {
    this.one = one;
  }

  public List<String> greetAll(List<String> names) {
    return names.stream()
      .map(one::greet)
      .toList();
  }
}
