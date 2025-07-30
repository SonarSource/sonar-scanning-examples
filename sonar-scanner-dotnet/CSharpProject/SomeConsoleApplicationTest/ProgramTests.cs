using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SomeConsoleApplication;

namespace SomeConsoleApplicationTest
{
    [TestClass]
    public class ProgramTests
    {
        [TestMethod]
        public void AlwaysReturnsTrue_ReturnsTrue()
        {
            // Arrange & Act
            var actual = Program.AlwaysReturnsTrue();

            // Assert
            Assert.IsTrue(actual);
        }

        [TestMethod]
        public void Passthrough_ReturnsTheGivenValue()
        {
            // Arrange
            var value = 42;

            // Act
            var actual = Program.Passthrough(value);

            // Assert
            Assert.AreEqual(actual, value);
        }
    }
}
