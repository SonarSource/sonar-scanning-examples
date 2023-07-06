package com.baeldung.kotlindsl;

import com.baeldung.kotlindsl.Reporter.StockPrice;
import com.baeldung.kotlindsl.Reporter.StockSymbol;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.Map;

import static com.baeldung.kotlindsl.Reporter.StockPrice.stockPrice;
import static com.baeldung.kotlindsl.Reporter.StockSymbol.stockSymbol;

public class Repository {

    private static final Map<StockSymbol, List<StockPrice>> priceBySymbol = Map.of(
      stockSymbol("TSL"), List.of(
        stockPrice(new BigDecimal("1.32"), Instant.parse("2021-01-01T15:00:00Z")),
        stockPrice(new BigDecimal("1.57"), Instant.parse("2021-05-05T15:00:00Z")),
        stockPrice(new BigDecimal("1.89"), Instant.parse("2021-02-03T15:00:00Z"))
      ),
      stockSymbol("FFB"), List.of(
        stockPrice(new BigDecimal("5.32"), Instant.parse("2021-05-01T15:00:00Z")),
        stockPrice(new BigDecimal("4.57"), Instant.parse("2021-02-05T15:00:00Z")),
        stockPrice(new BigDecimal("9.89"), Instant.parse("2021-09-03T15:00:00Z"))
      )
    );

    public List<StockPrice> getStockPrice(StockSymbol stockSymbol) {
        if (!priceBySymbol.containsKey(stockSymbol)) {
            throw new RuntimeException("Invalid stock symbol " + stockSymbol);
        }
        return priceBySymbol.get(stockSymbol);
    }
}
