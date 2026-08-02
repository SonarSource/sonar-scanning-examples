using System;
namespace SomeConsoleApplication
{
    public static class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("true");

            Console.ReadKey();
        }

        public static bool AlwaysReturnsTrue()
        {
            return true;
        }

        public static object Passthrough(object obj)
        {
            return obj;
        }
    }
}
