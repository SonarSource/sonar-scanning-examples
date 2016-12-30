package example;

import org.junit.Test;

public class HelloWorldIntegrationTest {

    @Test
    public void test() {
        new HelloWorld().coveredByIntegrationTest();
    }
	
}
