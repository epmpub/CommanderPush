using System;
using System.ComponentModel;
using System.ServiceProcess;
using System.Configuration;
using System.Threading;
using System.IO;
namespace MyService
{
    [RunInstaller(true)]
    public partial class Service1 : ServiceBase
    {
        int ScheduleTime = Convert.ToInt32(ConfigurationSettings.AppSettings["ThreadTime"]);

        public Thread Worker = null;

        public Service1()
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
                var util = new Util();
                Util.DoJob();
                Thread.Sleep(5*60*1000);
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
