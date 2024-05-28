package com.acme.basic;

public class HelloWorld {
  
  private static String variable = "Stringhere";

  void sayHello() {
    System.out.println("Hello World!");
  }

  void notCovered() {
    System.out.println("This method is not covered by unit tests");
  }

}
