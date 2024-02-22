package com.acme.basic;

import org.junit.Assert;
import org.junit.Test;

public class HelloWorldTest {

  @Test
  public void sayHello() {
    String hello = new HelloWorld().sayHello();
    Assert.assertEquals("Hello", hello);
  }
}
