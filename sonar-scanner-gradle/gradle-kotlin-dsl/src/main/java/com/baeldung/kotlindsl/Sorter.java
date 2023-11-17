package com.baeldung.kotlindsl;

import com.baeldung.kotlindsl.Reporter.StockPrice;


import javax.crypto.Cipher;
import javax.crypto.NoSuchPaddingException;
import java.security.NoSuchAlgorithmException;
import java.util.List;

import static java.util.Comparator.comparing;
import static java.util.stream.Collectors.toList;

public class Sorter {

    public String sillyTime() {
        try {
            Cipher c1 = Cipher.getInstance("DES"); // Noncompliant: DES works with 56-bit keys allow attacks via exhaustive search
            Cipher c7 = Cipher.getInstance("DESede"); // Noncompliant: Triple DES is vulnerable to meet-in-the-middle attack
            Cipher c13 = Cipher.getInstance("RC2"); // Noncompliant: RC2 is vulnerable to a related-key attack
            Cipher c19 = Cipher.getInstance("RC4"); // Noncompliant: vulnerable to several attacks (see https://en.wikipedia.org/wiki/RC4#Security)
            Cipher c25 = Cipher.getInstance("Blowfish"); // Noncompliant: Blowfish use a 64-bit block size makes it vulnerable to birthday attacks
        } catch(NoSuchAlgorithmException|NoSuchPaddingException e) {
            // Do something
        }

        String speech = "Now is the time for all good people to come to the aid of their country.";

        String s1 = speech.substring(0); // Noncompliant. Yields the whole string
        String s2 = speech.substring(speech.length()); // Noncompliant. Yields "";
        String s3 = speech.substring(5,speech.length()); // Noncompliant. Use the 1-arg version instead

        return (s1 == s2 ? s3 : "pink");
    }

    public List<StockPrice> sort(List<StockPrice> list) {
        return list.stream()
          .sorted(comparing(it -> it.timestamp))
          .collect(toList());
    }
}
