package atm;

import java.sql.*;

public class Account {
	
	private String account;
	private String aHolder;
	private String pin;
	private String balance;
	private boolean login = false;
	
	private Connection iConn;
	
	public Account(String account, String aHolder, String pin) throws ClassNotFoundException, SQLException {
		this.account = account;
		this.aHolder = aHolder;
		this.pin = pin;
		setupDatabaseConnection();
		setdb();
		login();
	}

	public String getBalance() {
		return balance;
	}
	/**
	 * pulls the balance value from account
	 * @throws SQLException 
	 */
	public void setBalance() throws SQLException {
		//CREATE PROCEDURE returnBalance @Aid int, @return int OUTPUT
		CallableStatement cs = null;
		cs = iConn.prepareCall("returnBalance ? , ? OUTPUT");
		cs.setInt(1, Integer.parseInt(account));
		cs.registerOutParameter(2, Types.INTEGER);
		cs.execute();
		int bala = cs.getInt(2);
		this.balance = Integer.toString(bala);
		System.out.println("got bala: "+ bala);
		cs.close();
	}

	public String getAccount() {
		return account;
	}

	public String getaHolder() {
		return aHolder;
	}

	public String getPin() {
		return pin;
	}
	
	
	public boolean isLogin() {
		return login;
	}

	/**
	 * connect to server
	 * @throws ClassNotFoundException -driver fail
	 * @throws SQLException - fail to connect
	 */
	private void setupDatabaseConnection() throws ClassNotFoundException, SQLException {
			Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
			String URL = "jdbc:odbc:dv1454_ht13_5";
			String User = "dv1454_ht13_5";
			String Password = "pvdqVUv9";
			this.iConn = DriverManager.getConnection(URL, User, Password);
			System.out.println("coonected");
	}
	
	/**
	 * Change database
	 * USE dv1454_ht13_5
	 * @throws SQLException
	 */
	
	private void setdb() throws SQLException{
		Statement stmt = iConn.createStatement();
		stmt.execute("USE dv1454_ht13_5 ");
		stmt.close();
		//System.out.println("blb");
	}
	/**
	 * 
	 * @throws SQLException
	 */
	private void login() throws SQLException{
		//DECLARE @@r int = 0 EXEC confirmLoginAccess aHolder, PIN, account, ret OUTPUT //pin 1:3123
		System.out.println("LOGIN...");	//debug
		CallableStatement cs = null;
		cs = iConn.prepareCall("EXEC confirmLoginAccess ?, ?, ?, ? OUTPUT");
		cs.setInt(1, Integer.parseInt(aHolder));
		cs.setInt(2, Integer.parseInt(pin));
		cs.setInt(3, Integer.parseInt(account));
		cs.registerOutParameter(4, Types.INTEGER);
		cs.execute();
		//System.out.println(cs.getInt(4));	//debug
		int ret = cs.getInt(4);
		if (ret == 1 ){	//login successful
			this.login = true;
			setBalance();
		}else{			//login fail
			this.login = false;
			System.out.println("login Failed");
		}
		cs.close();
		System.out.println("login done!");	//debug
	}
	/**
	 * 
	 * @param sAmount
	 * @throws SQLException 
	 */
	public boolean withDraw(String sAmount) throws SQLException{
		int amount = Integer.parseInt(sAmount);
		if(amount == 0){
			return true;
		}else{
			CallableStatement cs = iConn.prepareCall("EXEC takeOutMoney ? , ? , ? OUTPUT");
			cs.setInt(1, Integer.parseInt(account));
			cs.setInt(2, amount);
			cs.registerOutParameter(3, Types.INTEGER);
			cs.execute();
			int ret = cs.getInt(3);
			if(ret == 0){
				return false;
			}else if (ret>0){
				return true;
			}else{
				System.out.println("ret < 0");
				return false;
			}
		}
	}
		
}
