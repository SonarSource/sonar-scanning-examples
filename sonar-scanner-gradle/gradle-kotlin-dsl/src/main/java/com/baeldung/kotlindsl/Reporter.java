package com.baeldung.kotlindsl;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.Objects;

public final class Reporter {

    private final Repository repository;
    private final Sorter sorter;

    public Reporter(Repository repository, Sorter sorter) {
        this.repository = repository;
        this.sorter = sorter;
    }

    public List<StockPrice> getStockPrice(StockSymbol stockSymbol) {
        return sorter.sort(repository.getStockPrice(stockSymbol));
    }

    static final class StockPrice {

        public final BigDecimal price;
        public final Instant timestamp;

        private StockPrice(BigDecimal price, Instant timestamp) {
            this.price = price;
            this.timestamp = timestamp;
        }

        public static StockPrice stockPrice(BigDecimal price, Instant timestamp) {
            return new StockPrice(price, timestamp);
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            StockPrice that = (StockPrice) o;
            return Objects.equals(price, that.price) && Objects.equals(timestamp, that.timestamp);
        }

        @Override
        public int hashCode() {
            return Objects.hash(price, timestamp);
        }
    }

    static class StockSymbol {

        public final String symbol;

        private StockSymbol(String symbol) {
            this.symbol = symbol;
        }

        public static StockSymbol stockSymbol(String symbol) {
            return new StockSymbol(symbol);
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            StockSymbol that = (StockSymbol) o;
            return Objects.equals(symbol, that.symbol);
        }

        @Override
        public int hashCode() {
            return Objects.hash(symbol);
        }
    }
}
