package example

class GreetingTest extends GroovyTestCase {
  void testSay() {
    new Greeting().say()
  }
}