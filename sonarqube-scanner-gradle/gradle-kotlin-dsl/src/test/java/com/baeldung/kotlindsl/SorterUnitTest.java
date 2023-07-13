package com.baeldung.kotlindsl;

import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

import static com.baeldung.kotlindsl.Reporter.StockPrice.stockPrice;
import static org.junit.jupiter.api.Assertions.assertEquals;

class SorterTest {

    Sorter sorter = new Sorter();

    @Test
    void should_sort_stock_prices_descending_order_of_timestamp() {
        // given
        var now = Instant.now();
        var list = List.of(
          stockPrice(new BigDecimal("12.5"), now.minusSeconds(12)),
          stockPrice(new BigDecimal("12.9"), now.minusSeconds(45)),
          stockPrice(new BigDecimal("11.5"), now.minusSeconds(10))
        );

        // when
        var result = sorter.sort(list);

        // then
        assertEquals(stockPrice(new BigDecimal("12.9"), now.minusSeconds(45)), result.get(0));
        assertEquals(stockPrice(new BigDecimal("12.5"), now.minusSeconds(12)), result.get(1));
        assertEquals(stockPrice(new BigDecimal("11.5"), now.minusSeconds(10)), result.get(2));
    }
}