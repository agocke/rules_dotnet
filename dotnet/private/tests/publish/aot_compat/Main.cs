using System;
using System.Text.Json;

namespace AotCompatTest
{
    public class MyData
    {
        public string Name { get; set; }
        public int Value { get; set; }
    }

    public static class Program
    {
        public static int Main()
        {
            // When is_aot_compatible=True, the runtimeconfig.json sets:
            //   System.Text.Json.JsonSerializer.IsReflectionEnabledByDefault = false
            // This means reflection-based JSON serialization should throw at runtime.
            try
            {
                var data = new MyData { Name = "test", Value = 42 };
                string json = JsonSerializer.Serialize(data);
                Console.Error.WriteLine("FAIL: Expected reflection-based JSON to be disabled but got: " + json);
                return 1;
            }
            catch (NotSupportedException)
            {
                Console.WriteLine("OK: Reflection-based JSON correctly disabled for AOT compatibility");
            }
            catch (InvalidOperationException)
            {
                Console.WriteLine("OK: Reflection-based JSON correctly disabled for AOT compatibility");
            }

            Console.WriteLine("PASS: AOT compatibility feature switches are active");
            return 0;
        }
    }
}
