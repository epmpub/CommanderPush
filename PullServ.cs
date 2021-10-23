using System;
using System.Collections.Generic;
using System.IO;
using YamlDotNet.Serialization;
using YamlDotNet.Serialization.NamingConventions;

namespace Commander
{
    internal class PullServ
    {
        public PullServ()
        {
            Helper.DownloadFile("https://it2u.oss-cn-shenzhen.aliyuncs.com/yaml/conf.yaml", "c:\\Windows\\Temp\\", "conf.yaml");
            var deserializer = new DeserializerBuilder()
                .WithNamingConvention(UnderscoredNamingConvention.Instance)  // see height_in_inches in sample yml 
                .Build();

            conf = deserializer.Deserialize<Config>(File.ReadAllText("c:\\Windows\\Temp\\conf.yaml"));
        }

        public Config conf { get; private set; }

        internal void DoTest()
        {
            var executor = new Executor(conf);
            executor.Run(conf);

        }

        internal int GetInterval()
        {
            return conf.Interval;
        }
    }
}