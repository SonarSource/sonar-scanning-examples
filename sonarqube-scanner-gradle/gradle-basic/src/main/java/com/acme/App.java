package com.acme;

public class App {
    public String getGreeting() {
        return "Hello world. Hello!!";
    }

    public static void main(String[] args) {
        System.out.println(new App().getGreeting());
        //Test Log
    }
}
