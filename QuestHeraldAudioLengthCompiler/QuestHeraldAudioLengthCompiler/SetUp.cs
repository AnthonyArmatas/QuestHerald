using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuestHeraldAudioLengthCompiler
{
    static class SetUp
    {
        public static void InitializeFile(string fileName)
        {
            //Run Time is so small, just recreate the file every time.
            //if (File.Exists(fileName))
            //{
            //    Console.WriteLine("NO FILE " + fileName + " EXISTS");
            //    Console.WriteLine("Creating one");
            //    // Create a new file
            //    using (StreamWriter sw = File.CreateText(fileName))
            //    {
            //        sw.WriteLine("Author: Anthony Armatas");
            //        sw.WriteLine("questTable = {}");
            //    }
            //}
            //Run Time is so small, just recreate the file every time.
            using (StreamWriter sw = File.CreateText(fileName))
            {
                sw.WriteLine("Author: Anthony Armatas");
                sw.WriteLine("questTable = {}");
            }
        }
    }
}
