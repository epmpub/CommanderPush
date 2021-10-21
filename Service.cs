using System;
using System.ComponentModel;
using System.ServiceProcess;
using System.Configuration;
using System.Threading;
using System.IO;
using YamlDotNet.Serialization;
using YamlDotNet.Serialization.NamingConventions;

namespace Commander
{
    [RunInstaller(true)]
    public partial class Service : ServiceBase
    {
        int ScheduleTime = Convert.ToInt32(ConfigurationSettings.AppSettings["ThreadTime"]);

        public Thread Worker = null;

        public Service()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            try
            {
                ThreadStart start = new ThreadStart(Working);
                Worker = new Thread(start);
                Worker.Start();
            }
            catch 
            {

            }


        }

        public void Working()
        {
            while (true)
            {
                //var util = new Util();
                //Util.DoJob();

                //Service EntryPoint  // 混乱 :::::

                //Helper.DownloadFile("https://it2u.oss-cn-shenzhen.aliyuncs.com/yaml/conf.yaml", "c:\\windows\\temp\\", "conf.yaml");
                //var pullServ = new PullServ();
                //pullServ.DoTest();

                //var deserializer = new DeserializerBuilder()
                //.WithNamingConvention(UnderscoredNamingConvention.Instance)  // see height_in_inches in sample yml 
                //.Build();


                //var conf = deserializer.Deserialize<Config>(File.ReadAllText("c:\\Windows\\Temp\\conf.yaml"));

                //var interval = conf.Interval;

                Thread.Sleep(5 * 60*1000);
            }
        }

        protected override void OnStop()
        {
            try
            {
                if ((Worker != null) && Worker.IsAlive)
                {
                    Worker.Abort();
                }
            }
            catch (Exception)
            {

                throw;
            }
        }
    }
}
