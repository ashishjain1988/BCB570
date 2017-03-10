import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

public class PrecisionRecallCurveValues {

	public static void main(String[] args) throws IOException{
		for(int f=1;f<=5;f++)
		{
			String filePath = "/home/jain/BCB570/Size_10/Size_10/DREAM4_training_data/insilico_size10_"+f+"/";
			BufferedReader br = new BufferedReader(new FileReader("/home/jain/BCB570/Size_10/Size_10/DREAM4_gold_standards/insilico_size10_"+f+"_goldstandard.tsv"));
			String line = br.readLine();
			Map<String, Integer> goldStandard = new HashMap<>();
			while(line!=null)
			{
				String lineData[] = line.split("\t");
				if(Integer.parseInt(lineData[2]) == 1)
				{
					goldStandard.put(lineData[0]+"-"+lineData[1], Integer.parseInt(lineData[2]));
					goldStandard.put(lineData[1]+"-"+lineData[0], Integer.parseInt(lineData[2]));
				}
				line = br.readLine();
			}
			br.close();
			List<String> toolList = Arrays.asList("WGCNA","GENIE3","ARCANE");
			for(String s:toolList)
			{
				String tool = s;
				Map<String, Float> predictData = new HashMap<>();
				br = new BufferedReader(new FileReader(filePath+tool+"-filterLinks.txt"));
				line = br.readLine();
				while(line!=null)
				{
					String lineData[] = line.split("\t");
					predictData.put(lineData[0]+"-"+lineData[1], Float.parseFloat(lineData[2]));
					line = br.readLine();
				}
				PrintWriter pw = new PrintWriter(filePath+tool+"-PrecisionRecallValues.txt");
				//Sort the map
				int postive = goldStandard.size();
				Map<String, Float> sortedPredictData = sortByComparatorValue(predictData);
				for(int i=1;i<=predictData.size();i++)
				{
					int j=0;
					float TP = 0;
					int FP = 0;
					float FN = 0;
					for(Entry<String, Float> entry : sortedPredictData.entrySet())
					{
						if(j<i)
						{
							if(goldStandard.containsKey(entry.getKey()))
							{
								TP = TP + 1;
							}else
							{
								FP = FP + 1;
							}
							j++;
						}else
						{
							break;
						}
					}
					FN = postive - TP;
					pw.println((TP/(TP+FP))+"\t"+(TP/(TP+FN)));
				}
				pw.close();
			}
		}
	}
	
	public static Map<String, Float> sortByComparatorValue(Map<String, Float> unsortMap) {
		 
		// Convert Map to List
		List<Map.Entry<String, Float>> list = 
			new LinkedList<Map.Entry<String, Float>>(unsortMap.entrySet());
 
		// Sort list with comparator, to compare the Map values
		Collections.sort(list, new Comparator<Map.Entry<String, Float>>() {
			public int compare(Map.Entry<String, Float> o1,
                                           Map.Entry<String, Float> o2) {
				return (o2.getValue()).compareTo(o1.getValue());
			}
		});
 
		// Convert sorted map back to a Map
		Map<String, Float> sortedMap = new LinkedHashMap<String, Float>();
		for (Iterator<Map.Entry<String, Float>> it = list.iterator(); it.hasNext();) {
			Map.Entry<String, Float> entry = it.next();
			sortedMap.put(entry.getKey(), entry.getValue());
		}
		return sortedMap;
	}
}
