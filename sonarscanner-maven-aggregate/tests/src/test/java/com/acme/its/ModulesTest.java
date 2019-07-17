package com.acme.its;

import com.acme.module1.Module1;
import com.acme.module2.Module2;
import org.junit.Test;

public class ModulesTest {

  @Test
  public void integrationTest1() {
    new Module1().coveredByIntegrationTest();
  }

  @Test
  public void integrationTest2() {
    new Module2().coveredByIntegrationTest();
  }
  
}
