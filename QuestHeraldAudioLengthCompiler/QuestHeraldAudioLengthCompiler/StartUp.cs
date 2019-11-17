using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuestHeraldAudioLengthCompiler
{
    class StartUp
    {
        static void Main(string[] args)
        {
            string filePathName = Directory.GetCurrentDirectory() + "\\..\\..\\..\\..\\AudioLengthLibrary.lua";
            int audioAdded = 0;
            //Run Time is so small, just recreate the file every time.
            using (StreamWriter sw = File.CreateText(filePathName))
            {
                sw.WriteLine("--Author: Anthony Armatas");
                sw.WriteLine("questTable = ");
                sw.WriteLine("	{");

                string auidoPath = Directory.GetCurrentDirectory() + "\\..\\..\\..\\..\\QuestAudio";
                string[] questObjectiveFiles =
                Directory.GetFiles(auidoPath, "*_Description.mp3", SearchOption.AllDirectories);
                foreach (string objFile in questObjectiveFiles)
                {
                    string fileName = Path.GetFileName(objFile);
                    TagLib.File tagFile = TagLib.File.Create(objFile);
                    double length = tagFile.Properties.Duration.TotalSeconds;
                    sw.WriteLine("	[\"{0}\"] =  {1},", fileName, length);
                    audioAdded++;
                }
                sw.WriteLine("	}");
            }
            Console.WriteLine("Finsihed writing Audio Length Library.");
            Console.WriteLine(audioAdded + " AudioFiles were added to the Library.");
            Console.Read();
        }
    }
}
