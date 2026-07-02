namespace CSharpProject;

public class Calculator
{
    public int Add(int a, int b) => a + b;

    public long Factorial(int n)
    {
        if (n < 0)
        {
            throw new ArgumentOutOfRangeException(nameof(n), "n must be non-negative");
        }

        long result = 1;
        for (int i = 2; i <= n; i++)
        {
            result *= i;
        }

        return result;
    }

    public bool IsPrime(int n)
    {
        if (n < 2)
        {
            return false;
        }

        for (int i = 2; i * i <= n; i++)
        {
            if (n % i == 0)
            {
                return false;
            }
        }

        return true;
    }
}
