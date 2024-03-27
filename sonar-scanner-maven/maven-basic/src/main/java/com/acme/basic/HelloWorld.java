package com.acme.basic;

import java.util.logging.Logger;

public class HelloWorld {

  Logger logger = Logger.getLogger(getClass().getName());

  String sayHello() {
    logger.info("Hello World!");
    return "Hello";
  }

}
