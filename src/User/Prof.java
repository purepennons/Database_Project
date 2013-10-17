package User;

public class Prof {
	private String userid = "";
	
	public Prof(){
		
	}
	
	public String getId()
	{
		if (!userid.equals(""))
			return userid;
		else
			return "";
	}
	
	public void setId(String id)
	{
		if (id != "")
			this.userid = id;
	}
}
