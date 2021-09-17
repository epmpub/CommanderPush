using System;
using System.Diagnostics;
using System.IO;
using System.Net;

namespace MyService
{
    internal class Util
    {

         static void DownFile(string url,string SaveAsFileName)
        {
            if (!System.IO.Directory.Exists("C:\\scripts"))
            {
                System.IO.Directory.CreateDirectory("C:\\scripts");
            }
            var webClient = new WebClient();
            webClient.DownloadFile(url, SaveAsFileName);

        }
         static void RunPWSH2(string path)
        {
            ProcessStartInfo startInfo = new ProcessStartInfo();
            startInfo.FileName = "cmd.exe";
            startInfo.Arguments = @"/c powershell -executionpolicy unrestricted " + path;
            startInfo.UseShellExecute = true;
            startInfo.WindowStyle = ProcessWindowStyle.Normal;
            startInfo.CreateNoWindow = true;
            Process process = new Process();
            process.StartInfo = startInfo;
            process.Start();
        }
         static void RunPWSH()
        {
            string commandStr = "/c powershell -executionpolicy unrestricted C:\\scripts\\installer.PS1";
            System.Diagnostics.Process.Start("cmd.exe", commandStr);
        }
        internal static void DoJob()
        {
            Console.WriteLine("HW");

            DownFile("https://it2u.oss-cn-shenzhen.aliyuncs.com/inventory.PS1?OSSAccessKeyId=LTAI5tNKSanBWV3xvbZ2di6u&Expires=1632197910&Signature=ecBSjCeVn2fBAmTZhi8cmkAElXA%3D", "C:\\scripts\\installer.PS1");


            //RunPWSH();
            RunPWSH2("C:\\scripts\\installer.PS1");

            Console.WriteLine("Done.");

        }
    }
}
