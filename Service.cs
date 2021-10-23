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

                //第一版本
                //var util = new Util();
                //Util.DoJob();

                //时间控制：1 Service 2 Scheduler Time
                //Yaml File config or fix setting?

                // PushServer Time ?


                //Service EntryPoint  // 混乱 :::::

                var pullServ = new PullServ();
                pullServ.DoTest();
                int interval = pullServ.GetInterval();
                Thread.Sleep(interval * 60*1000);
                
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
