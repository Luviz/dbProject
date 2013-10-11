package atm;

import java.awt.Panel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.SQLException;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.JTextField;


public class atmGUI extends JFrame {

	private class Action implements ActionListener{
		@Override
		public void actionPerformed(ActionEvent e) {
			//System.out.println(lUsername.getText().contains("@"));
			if (e.getActionCommand().equals("Login")){
				if(lUsername.getText().contains("@")||!(lUsername.getText().equals("accountHolderID@accountID"))){
					//System.out.println("@ ok");	//debug
					if(!(lPassword.getPassword().length == 0)){
						//System.out.println(lPassword.getPassword());	//debug
						String uId , aId;
						uId = lUsername.getText().substring(0,lUsername.getText().indexOf('@'));
						//System.out.println(uId);						//debug
						aId = lUsername.getText().substring(lUsername.getText().indexOf('@')+1);
						//System.out.println(aId);						//debug
						try {
							acc = new Account(aId, uId, new String(lPassword.getPassword()));
							//System.out.println(acc.getBalance());		//debug
						} catch (ClassNotFoundException | SQLException e1) {
							
							e1.printStackTrace();
							JOptionPane.showMessageDialog(getParent(), "Error System failer att login or connection or db-failer"+
									e1.getMessage(),"ERROR!",JOptionPane.ERROR_MESSAGE);
						}
						if(acc.isLogin()){
							//System.out.println("acc.getBalance() == "+acc.getBalance());	//debug
							System.out.println("logedin!");
							terminateLogin();
							launchWithDraw();
						}else {
							JOptionPane.showMessageDialog(getParent(), "Incorrect LOGIN information Pleas try agen!"
									,"FALSE LOGIN!",JOptionPane.WARNING_MESSAGE);
						}
					
					}
				}
			}
			if (e.getActionCommand().equals("With Draw")){
				//TODO add whitdarw function!
				boolean isSuccessful = false; 
				//Successful 
				try {
					isSuccessful = acc.withDraw(wAmount.getText());
				} catch (SQLException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
					JOptionPane.showMessageDialog(getParent(), "Error att account withdraw!\n"+e1.getMessage(),"ERROR!",JOptionPane.ERROR_MESSAGE);
				}
				if (isSuccessful){
					terminateWithdraw();
					launchLogin();
				}else{
					JOptionPane.showMessageDialog(getParent(),"You have NOT enough minerals", "WARING!",JOptionPane.WARNING_MESSAGE);
					
				}
			}
		}

	}
	
	//account
	Account acc; 
	
	//login
	private JPanel login = new JPanel(null);
	private JTextField lUsername = new JTextField("accountHolderID@accountID");
	private JPasswordField lPassword = new JPasswordField();
	private JButton lLogin = new JButton("Login");
	//------------
	//withDraw
	private JPanel withDraw = new JPanel(null);
	private JTextField wAmount = new JTextField("100");
	private JLabel wBalance = new JLabel();
	private JButton wWithDraw = new JButton("With Draw");
	//-----------
	
	atmGUI(){
		
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		config();
		init();
		render(1);
	}
	
	private void config(){
		//JFrame
		setSize(800, 600);
		setLocationRelativeTo(null);
		
	}
	
	private void init() {
		
	}
	
	private void login() { 	//login == 1
		lUsername.setLocation(250, 230);
		lUsername.setSize(300, 26);
		lUsername.setHorizontalAlignment(JTextField.CENTER);
		
		lPassword.setLocation(250, 260);
		lPassword.setSize(300,26);
		lPassword.setHorizontalAlignment(JTextField.CENTER);
		
		//jLabel
		JLabel u = new JLabel("User Name:");
		JLabel p = new JLabel("Password:");
		u.setSize(u.getPreferredSize());
		p.setSize(p.getPreferredSize());
		
		u.setLocation(lUsername.getLocation().x-u.getPreferredSize().width-4, lUsername.getLocation().y+4);
		p.setLocation(lPassword.getLocation().x-p.getPreferredSize().width-4, lPassword.getLocation().y+4);
		
		lLogin.addActionListener(new Action());
		lLogin.setLocation(367, 300);
		lLogin.setSize(lLogin.getPreferredSize());
		//System.out.println(lLogin.getPreferredSize());	//debug
		login.add(lUsername);
		login.add(lPassword);
		login.add(u);
		login.add(p);
		login.add(lLogin);
	}
	
	private void withDraw(){
		//System.out.println("withdraw");		//debug
		//System.out.println(acc.getBalance());	//debug
		wBalance.setText(acc.getBalance());
		wBalance.setHorizontalAlignment(JLabel.CENTER);
		wBalance.setSize(150,26);
		wBalance.setLocation((getSize().width/2)-(wBalance.getSize().width/2), 230);
		
		//wAmount.setText("");
		wAmount.setHorizontalAlignment(JTextField.CENTER);
		wAmount.setSize(150, 26);
		wAmount.setLocation((getSize().width/2)-(wBalance.getSize().width/2), 260);
		
		wWithDraw.addActionListener(new Action());
		wWithDraw.setSize(wWithDraw.getPreferredSize());
		wWithDraw.setLocation((getSize().width/2)-(wWithDraw.getSize().width/2),300);
		
		withDraw.add(wBalance);
		withDraw.add(wAmount);
		withDraw.add(wWithDraw);
		
	}
	
	private void launchLogin(){
		login();
		add(login);
		revalidate();
		repaint();
	}
	private void terminateLogin(){
		remove(login);
	}
	
	private void launchWithDraw(){
		withDraw();
		add(withDraw);
		revalidate();
		repaint();
	}
	private void terminateWithdraw(){
		remove (withDraw);
	}
	
	private void render(int choose){
		launchLogin();
		/*withDraw();
		add(withDraw);*/
	}

}
