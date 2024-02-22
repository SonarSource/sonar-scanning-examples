package com.acme.basic;

import org.junit.Test;

import static org.junit.Assert.assertTrue;

public class HelloWorldTest {

  @Test
  public void sayHello() {
    new HelloWorld().sayHello();
    assertTrue(true);
  }
}
