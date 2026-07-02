using CSharpProject;

var calculator = new Calculator();

Console.WriteLine($"3 + 4 = {calculator.Add(3, 4)}");
Console.WriteLine($"5! = {calculator.Factorial(5)}");
Console.WriteLine($"Is 17 prime? {calculator.IsPrime(17)}");
