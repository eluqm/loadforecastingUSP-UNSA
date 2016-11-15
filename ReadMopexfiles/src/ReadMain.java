import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;


 

public class ReadMain {
	
	
	//consired 1948 bisc year 
	public static void main(String[] args) throws IOException
	{
		ArrayList<Integer> months= new ArrayList<>();
		months.add(31);
		months.add(28);
		months.add(31);
		months.add(30);
		months.add(31);
		months.add(30);
		months.add(31);
		months.add(31);
		months.add(30);
		months.add(31);
		months.add(30);
		months.add(31);
		int countdays=0;
		int countmonths=0;
		int yearinit=1948;
		// data caracteristic preci=1,evap=2,flow=3,min=4,max=5
		int caract=0;
		BufferedWriter out= new BufferedWriter(new FileWriter("/home/edson/Documents/echo_project/loadforecastingUSP-UNSA/07378500monthly.dly.txt"));
		BufferedReader buf = new BufferedReader(new FileReader("/home/edson/Documents/echo_project/loadforecastingUSP-UNSA/07378500.dly.txt"));
		String line= null;
		String[] wordsLine;
		String[] newwordsline;
		String averagevalues = "";
		
		int year=0;
		line=buf.readLine();
		while(true)
		{
			
			if(line==null)
			{
				break;
			}
			int monttemp=months.get(countmonths%12);
			
			System.out.println(Integer.parseInt((String) line.subSequence(0, 4)));
			
			if(countmonths%12==1 && ((Integer.parseInt((String) line.subSequence(0, 4))-yearinit)%4==0))
			{monttemp=29;}
			//average of tree main data , prec, evap, flow
			float average=0;
			float average1=0;
			float average2=0;
					
			while(countdays<monttemp)
			{
				
				//System.out.println(line);
				line=line.substring(10, line.length());
				
				//System.out.println(line);
				//count++;
				//if(count==4){break;}
				wordsLine= line.split(" ");
				System.out.println(wordsLine);
				//System.out.println(wordsLine.length);
				int countt=0;
				for(String each : wordsLine){
					if(!each.isEmpty()){
					if(countt==1){average1+=Float.parseFloat(each);}
					if(countt==2){average2+=Float.parseFloat(each);}
					if(countt==0){
						System.out.println(each+"empty");
						average+=Float.parseFloat(each);}
			//		
					//System.out.println(wordsLine);
					//System.out.println(wordsLine[3]);
					//System.out.println(wordsLine[4]);
					//System.out.println(each + "qewqe");
					countt++;
					}
				}
				System.out.println();
				countdays++;
				line=buf.readLine();
				if(line==null)
				{
					break;
				}
			}
			String averagebyMonth=Float.toString(average/countdays)+" "+Float.toString(average1/countdays)+" "+Float.toString(average2/countdays)+"\n";
			averagevalues+=averagebyMonth;
			countdays=0;
			countmonths++;
			
			
		}
		out.write(averagevalues);
		out.close();
	}


}
