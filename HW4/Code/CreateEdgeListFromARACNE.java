import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;

public class CreateEdgeListFromARACNE {

	public static void main(String[] args) throws IOException{
		for(int f=1;f<=5;f++)
		{
			String filePath = "/home/jain/BCB570/Size_10/Size_10/DREAM4_training_data/insilico_size10_"+f+"/";;
			BufferedReader br = new BufferedReader(new FileReader(filePath+"ARCANE-adjMat.txt"));
			String line = br.readLine();
			PrintWriter pw = new PrintWriter(filePath+"ARCANEedge.txt");
			while(line!=null)
			{
				if(!line.startsWith("<"))
				{
					String lineData[] = line.split("\t");
					String gene = lineData[0];
					for(int i=1;i<lineData.length-1;i=i+2)
					{
						pw.println(gene+"\t"+lineData[i]+"\t"+lineData[i+1]);
					}
				}
				line = br.readLine();
			}
			br.close();
			pw.close();
		}
	}
}
