package Database;

import javax.naming.*;
import javax.sql.*;
import java.sql.*;

public class DBConnectionInit {
	private Context ctx = null;
	private DataSource ds = null;
	private Connection conn = null;
	private String dataSourceString = "";
	private Statement st = null;
	private PreparedStatement ps = null;
	
	public DBConnectionInit(){
		this.dataSourceString = "java:comp/env/jdbc/database_project";
		this.conn = init(this.dataSourceString);
	}
	
	public DBConnectionInit(String dataSourceString){
		this.dataSourceString = dataSourceString;
		this.conn = init(this.dataSourceString);
	}
	
	public  Context getCtx(){
		if(this.ctx != null)
			return this.ctx;
		else
			return null;
	}
	
	public DataSource getDs(){
		if(this.ds != null)
			return this.ds;
		else
			return null;
	}
	
	public Connection getConn(){
		if(this.conn != null)
			return this.conn;
		else
			return null;
	}
	
	public Statement getSt(){
		if(this.st != null)
			return this.st;
		else
			return null;
	}
	
	public PreparedStatement getPs(){
		if(this.ps != null)
			return this.ps;
		else
			return null;
	}
	
	private Connection init(String dataSourceString){
		try {
			this.ctx = new InitialContext();
			this.ds = (DataSource) ctx.lookup(dataSourceString);
			return ds.getConnection();
		} catch (NamingException e) {
			e.printStackTrace();
		}catch (SQLException e) {
			e.printStackTrace();
		}
		return null;

	}
	
	public void closeConnection(){
		try {
			this.conn.close();
			this.ds = null;
			this.ctx = null;
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	/*public PreparedStatement preStatementUpdate(String sqlString){
		try {
			this.ps = this.conn.prepareStatement(sqlString);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}*/

}


