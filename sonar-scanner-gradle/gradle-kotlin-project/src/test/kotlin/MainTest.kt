import org.junit.jupiter.api.Assertions.assertNotNull
import org.junit.jupiter.api.Test
import org.example.main

class MainTest {
    @Test
    fun testMainReturnsNotNull() {
        val result = main()
        assertNotNull(result)
    }
}