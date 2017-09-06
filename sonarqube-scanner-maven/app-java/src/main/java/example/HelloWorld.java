package example;

public class HelloWorld {

  public void coveredByUnitTest() {
    System.out.println("coveredByUnitTest1");
    System.out.println("coveredByUnitTest2");
    System.out.println("coveredByUnitTest3");
  }

  public void coveredByIntegrationTest() {
    System.out.println("coveredByIntegrationTest1");
    System.out.println("coveredByIntegrationTest2");
    System.out.println("coveredByIntegrationTest3");
  }

  public void notCovered() {
    System.out.println("notCovered");
  }
  public void notCovered2() {
    if(1==1){
      if(2==2)
        if(3==3)
          if(4==4)
      System.out.println("notCovered method 2");
    }
  }

}
