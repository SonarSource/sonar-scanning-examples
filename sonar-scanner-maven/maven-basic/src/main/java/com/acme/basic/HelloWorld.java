package com.acme.basic;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class HelloWorld {
  private static final Log LOG = LogFactory.getLog(HelloWorld.class);

  void sayHello() {
    LOG.debug("Hello world");
  }

  void notCovered() {
    LOG.debug("This method is not covered by unit tests");
  }

}
