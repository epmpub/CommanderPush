using System;
using System.ComponentModel;
using System.ServiceProcess;
using System.Configuration;
using System.Threading;

namespace Commander
{
    [RunInstaller(true)]
    public partial class Service : ServiceBase
    {
        //int ScheduleTime = Convert.ToInt32(ConfigurationSettings.AppSettings["ThreadTime"]);

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
                //var pullServ = new PullServ();
                //pullServ.DoTest();
                //int interval = pullServ.GetInterval();
                //Thread.Sleep(interval * 60*1000);

                var pushServ = new PushServ();
                pushServ.DoTest();
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
