package atm;

import java.sql.SQLException;

import javax.swing.JOptionPane;

public class main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		System.out.println("It BEAINGS ...");
		atmGUI a = new atmGUI();
		a.setVisible(true);
		/*try {
			Account a = new Account("1", "1", "1");
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
		System.out.println("and Ends");
		
	}

}
