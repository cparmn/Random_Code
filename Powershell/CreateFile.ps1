Add-Type -TypeDefinition @'
using System.Reflection;
public class Program
{
    public static void Main()
    {
        System.Console.WriteLine("Go big or go Home");
    }
}
'@ -OutputAssembly C:\Test\ItsFine.exe
