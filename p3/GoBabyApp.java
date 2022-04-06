import java.sql.* ;
import java.io.*;
import java.util.*;
import java.text.SimpleDateFormat;

class GoBabyApp {

    // private class AppointmentRecord {
    //     int pregnancyID = null;
    //     String datetime = null;
    //     Boolean isPrimary = null; 
    //     String motherName = null;
    //     String motherRAMQ = null;
    // }

    private static Connection con = null;
    private static Statement statement = null;
    private static int sqlCode=0;      // Variable to hold SQLCODE
    private static String sqlState="00000";  // Variable to hold SQLSTATE

    //REMEMBER to remove your user id and password before submitting your code!!
    private static String your_userid = "swang298";
    private static String your_password = "gPC8ru4J";

    // This is the url you must use for DB2.
    //Note: This url may not valid now ! Check for the correct year and semester and server name.
    private static String url = "jdbc:db2://winter2022-comp421.cs.mcgill.ca:50000/cs421";

    private static HashMap <Integer, String> records = new HashMap <Integer, String>();
    private static ArrayList <Integer> recordsPregnancyIdOrder  = new ArrayList <Integer>();
    private static ArrayList <Integer> recordsAppointmentIdOrder = new ArrayList <Integer>();
    private static int selectedIdx = 0;

    public static void main(String [] args) throws SQLException{

        int sqlCode=0;      // Variable to hold SQLCODE
        String sqlState="00000";  // Variable to hold SQLSTATE

        // Register the driver.  You must register the driver before you can use it.
        try { DriverManager.registerDriver ( new com.ibm.db2.jcc.DB2Driver() ) ; }
        catch (Exception cnfe){ System.out.println("Class not found"); }

        //AS AN ALTERNATIVE, you can just set your password in the shell environment in the Unix (as shown below) and read it from there.
        //$  export SOCSPASSWD=yoursocspasswd 
        if(your_userid == null && (your_userid = System.getenv("SOCSUSER")) == null)
        {
          System.err.println("Error!! do not have a password to connect to the database!");
          System.exit(1);
        }
        if(your_password == null && (your_password = System.getenv("SOCSPASSWD")) == null)
        {
          System.err.println("Error!! do not have a password to connect to the database!");
          System.exit(1);
        }
        con = DriverManager.getConnection (url,your_userid,your_password) ;
        statement = con.createStatement ();

        // Create the console object
        Console console = System.console();
        while (true){
            String practitionerID = console.readLine("Please enter your practitioner id [E] to exit: ");
            if (practitionerID.equals("E")){
                System.out.println("Exiting");
                break;
            } else {
                if (isPractitionerIdValid(practitionerID)){
                    String date = console.readLine("Please enter the date for appointment [format: YYYY-MM-DD ] list [E] to exit: ");
                    if (date.equals("E")){
                        System.out.println("Exiting");
                        break; 
                    } else {
                        Boolean option = listAllAppointments(date, practitionerID);
                        if (!option){
                            break;
                        } else {
                            while (true){
                                Boolean status = listMenuForPregnancy(recordsPregnancyIdOrder.get(selectedIdx), date, practitionerID);
                                if (!status) {
                                    return;
                                }
                            }
                        }
                    }
                } else {
                    System.out.println("Practitioner Id " + practitionerID + " is not valid");
                }
            }
        }

        // Finally but importantly close the statement and connection
        statement.close () ;
        con.close () ;
    }

    // Helpers
    public static Boolean isPractitionerIdValid (String id){

        // checks if the id exits in the database
        try {
            String querySQL = "SELECT * FROM MIDWIFE WHERE practitionerID = " + id;
            java.sql.ResultSet rs = statement.executeQuery (querySQL);
            return rs.next();
        }
        catch (SQLException e)
        {
            sqlCode = e.getErrorCode(); // Get SQLCODE
            sqlState = e.getSQLState(); // Get SQLSTATE
                
            // Your code to handle errors comes here;
            // something more meaningful than a print would be good
            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            System.out.println(e);
            return false;
        }
    }

    public static Boolean listMenuForPregnancy (int pregnancyID, String date, String practID){
        String motherName = getMotherName(String.valueOf(pregnancyID));
        String motherRAMQ = getMotherRAMQ(String.valueOf(pregnancyID));
        if (motherName.equals("") || motherRAMQ.equals("")){
            System.out.println("Invalid pregnancyID");
            return false;
        }

        System.out.println("For " + motherName + " " + motherRAMQ);
        System.out.println("1. Review notes");
        System.out.println("2. Review tests");
        System.out.println("3. Add a note");
        System.out.println("4. Prescribe a test");
        System.out.println("5. Go back to the appointments");

        Console console = System.console();
        String option = console.readLine("Enter your choice: ");

        if (option.equals("1")){
            // review notes
            int appointmentId = recordsAppointmentIdOrder.get(selectedIdx);
            try {
                String querySQL = "SELECT * FROM OBSERVATIONNOTE WHERE appointmentID = " + appointmentId + " ORDER BY notetime DESC";
                java.sql.ResultSet rs = statement.executeQuery (querySQL);
                while (rs.next()){
                    String notetime = rs.getString(3);
                    String note =  rs.getString(4);
                    System.out.println(notetime + ": " + note);
                }  
            }
            catch (SQLException e)
            {
                sqlCode = e.getErrorCode(); // Get SQLCODE
                sqlState = e.getSQLState(); // Get SQLSTATE
                System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                System.out.println(e);
                return false;
            }
            
        } else if (option.equals("2")){
            // review test
            int appointmentId = recordsAppointmentIdOrder.get(selectedIdx);
            try {
                String querySQL = "SELECT * FROM MEDICALTEST WHERE appointmentID = " + appointmentId + " AND forbaby = false AND individualID = " + motherRAMQ + " ORDER BY sampleddate DESC";
                java.sql.ResultSet rs = statement.executeQuery (querySQL);
                while (rs.next()){
                    String sampleddate = rs.getString(6);
                    String testType = rs.getString(10);
                    String testResult = rs.getString(9);
                    System.out.println(sampleddate + " [" + testType + "] " + testResult);
                }  
            }
            catch (SQLException e)
            {
                sqlCode = e.getErrorCode(); // Get SQLCODE
                sqlState = e.getSQLState(); // Get SQLSTATE
                System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                System.out.println(e);
                return false;
            }
        } else if (option.equals("3")){
            // add a note
            String observation = console.readLine("Please type your observation: ");
            int appointmentId = recordsAppointmentIdOrder.get(selectedIdx);
            int newNoteId = 0;
            // check number of records
            try {
                String querySQL = "SELECT COUNT(*) FROM OBSERVATIONNOTE";
                java.sql.ResultSet rs = statement.executeQuery (querySQL);
                while (rs.next()){
                    newNoteId = rs.getInt(1) + 1;
                }  
            }
            catch (SQLException e)
            {
                sqlCode = e.getErrorCode(); // Get SQLCODE
                sqlState = e.getSQLState(); // Get SQLSTATE
                System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                System.out.println(e);
                return false;
            }

            // add a new record
            try {
                java.util.Date currentDate = new java.util.Date();
                SimpleDateFormat formatter = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");

                String querySQL = "INSERT INTO OBSERVATIONNOTE VALUES (" + Integer.toString(newNoteId) + ", " + Integer.toString(appointmentId) + ", \'" + formatter.format(currentDate) + "\', \'" + observation + "\')";
                // System.out.println(querySQL);
                statement.executeUpdate (querySQL);
            }
            catch (SQLException e)
            {
                sqlCode = e.getErrorCode(); // Get SQLCODE
                sqlState = e.getSQLState(); // Get SQLSTATE
                System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                System.out.println(e);
                return false;
            }

            
        } else if (option.equals("4")){
            // prescribe a test
            String testType = console.readLine("Please enter the type of test:");
            int appointmentId = recordsAppointmentIdOrder.get(selectedIdx);
            int newTestId = 0;

            // check number of tests
            try {
                String querySQL = "SELECT COUNT(*) FROM MEDICALTEST";
                java.sql.ResultSet rs = statement.executeQuery (querySQL);
                while (rs.next()){
                    newTestId = rs.getInt(1) + 1;
                }  
            }
            catch (SQLException e)
            {
                sqlCode = e.getErrorCode(); // Get SQLCODE
                sqlState = e.getSQLState(); // Get SQLSTATE
                System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                System.out.println(e);
                return false;
            }


            // add a test
            try {
                java.util.Date currentDate = new java.util.Date();
                SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

                String querySQL = "INSERT INTO MEDICALTEST VALUES (" + Integer.toString(newTestId) + ", " + Integer.toString(appointmentId) + ", false, " + motherRAMQ + ", \'" + formatter.format(currentDate) + "\'" + ", \'" + formatter.format(currentDate) + "\'" + ", \'random address\', " + "\'" + formatter.format(currentDate) + "\'" + ", null, \'" + testType + "\')";
                statement.executeUpdate (querySQL);
            }
            catch (SQLException e)
            {
                sqlCode = e.getErrorCode(); // Get SQLCODE
                sqlState = e.getSQLState(); // Get SQLSTATE
                System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                System.out.println(e);
                return false;
            }
        } else if (option.equals("5")){
            // go back to appointments
            Boolean status = listAllAppointments(date, practID);
            if (!status){
                return false;
            }
        }
        return true;

        
    }

    public static Boolean listAllAppointments (String date, String practId){

        records = new HashMap <Integer, String>();
        recordsPregnancyIdOrder  = new ArrayList <Integer>();
        // TODO: list all the appointments for that date for that midwife, ordered by time. 
        // Error message if there are no appointments for that date, error message and go abck to asking the date. 

        // SELECT appointmenttime FROM APPOINTMENT WHERE midwifeID=practID AND appointmenttime >= date + 00:00:00 AND appointmenttime <= date + 23:59:59
        String currentDate = date;
        while (true){
            try{
                String querySQL = "SELECT * FROM APPOINTMENT WHERE midwifeID=" + practId + " AND appointmenttime>=\'" + currentDate + " 00:00:00\' " + "AND appointmenttime<=\'" + currentDate + " 23:59:59\' ORDER BY appointmenttime";
                recordsPregnancyIdOrder.clear();
                recordsAppointmentIdOrder.clear();
                records.clear();
                java.sql.ResultSet rs = statement.executeQuery (querySQL);
                while (rs.next()){
                    int appointmentID = rs.getInt(1);
                    int pregnancyID = rs.getInt(3);
                    String datetime = rs.getString(4);
                    records.put(pregnancyID, datetime);
                    recordsPregnancyIdOrder.add(pregnancyID);
                    recordsAppointmentIdOrder.add(appointmentID);
                }

                if (recordsPregnancyIdOrder.size() == 0){
                    System.out.println("No appointment found");
                }

                int idx = 1;
                while (idx - 1 < recordsPregnancyIdOrder.size()){
                    int pregnancyID = recordsPregnancyIdOrder.get(idx - 1);
                    Boolean isPrimary = checkIsPrimary(String.valueOf(pregnancyID), practId);
                    String motherName = getMotherName(String.valueOf(pregnancyID));
                    String motherRAMQ = getMotherRAMQ(String.valueOf(pregnancyID));
                    String outputLine = appointmentOutputBuilder(idx, records.get(pregnancyID), isPrimary, motherName, motherRAMQ);
                    System.out.println(outputLine);
                    idx += 1;
                }
                Console console = System.console();
                String option = console.readLine("Enter the appointment number that you would like to work on. [E] to exit [D] to go back to another date :");
                if (option.equals("E")){
                    return false;
                } else if (option.equals("D")){
                    String newDate = console.readLine("Please enter the date for appointment [format: YYYY-MM-DD ] list [E] to exit: ");
		    currentDate = newDate;
                    if (newDate.equals("E")){
                        return false;
                    } else {
                        currentDate = newDate;
                    }
                } else if (Integer.parseInt(option) - 1 < recordsPregnancyIdOrder.size()){
                    selectedIdx = Integer.parseInt(option) - 1;
                    return true;
                }
                
            }
            catch (SQLException e)
            {
                sqlCode = e.getErrorCode(); // Get SQLCODE
                sqlState = e.getSQLState(); // Get SQLSTATE
                
                // Your code to handle errors comes here;
                // something more meaningful than a print would be good
                System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                System.out.println(e);
                return false;
            }
        }
        
    }

    public static String appointmentOutputBuilder(int idx, String datetime, Boolean isPrimary, String motherName, String motherRAMQ){
        String status = isPrimary ? "P" : "B";
        return String.valueOf(idx) + ": " + datetime + " " + status + " " + motherName + " " + motherRAMQ;
    }

    public static Boolean checkIsPrimary (String pregnancyID, String midwifeID){
        try{
            String querySQL = "SELECT * FROM MAINMIDWIFE WHERE midwifeID=" + midwifeID + " AND pregnancyID=" + pregnancyID;
            java.sql.ResultSet rs = statement.executeQuery(querySQL);
            return rs.next();
        }
        catch (SQLException e)
        {
            sqlCode = e.getErrorCode(); // Get SQLCODE
            sqlState = e.getSQLState(); // Get SQLSTATE
                
            // Your code to handle errors comes here;
            // something more meaningful than a print would be good
            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            System.out.println(e);
            return false;
        }
    }

    public static String getMotherName (String pregnancyID){
        try{
            String querySQL = "SELECT * FROM PREGNANCY WHERE pregnancyID=" + pregnancyID;
            java.sql.ResultSet rs = statement.executeQuery (querySQL);
            if (rs.next()){
                int coupleID = rs.getInt(2);
                String ramqID = getMotherRAMQByCouple(String.valueOf(coupleID));
                String motherName = getMotherNameByRAMQ(ramqID);
                return motherName;
            } else {
                return "";
            }
        }
        catch (SQLException e)
        {
            sqlCode = e.getErrorCode(); // Get SQLCODE
            sqlState = e.getSQLState(); // Get SQLSTATE
                
            // Your code to handle errors comes here;
            // something more meaningful than a print would be good
            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            System.out.println(e);
            return "";
        }
    }

    public static String getMotherRAMQ(String pregnancyID){
        try{
            String querySQL = "SELECT * FROM PREGNANCY WHERE pregnancyID=" + pregnancyID;
            java.sql.ResultSet rs = statement.executeQuery (querySQL);
            if (rs.next()){
                int coupleID = rs.getInt(2);
                String ramqID = getMotherRAMQByCouple(String.valueOf(coupleID));
                return ramqID;
            } else {
                return "";
            }
        }
        catch (SQLException e)
        {
            sqlCode = e.getErrorCode(); // Get SQLCODE
            sqlState = e.getSQLState(); // Get SQLSTATE
                
            // Your code to handle errors comes here;
            // something more meaningful than a print would be good
            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            System.out.println(e);
            return "";
        }
    }

    public static String getMotherRAMQByCouple (String coupleID){
        try{
            String querySQL = "SELECT * FROM COUPLE WHERE coupleID=" + coupleID;
            java.sql.ResultSet rs = statement.executeQuery (querySQL);
            if (rs.next()){
                String ramqID = rs.getString(2);
                return ramqID;
            } else {
                return "";
            }
        }
        catch (SQLException e)
        {
            sqlCode = e.getErrorCode(); // Get SQLCODE
            sqlState = e.getSQLState(); // Get SQLSTATE
                
            // Your code to handle errors comes here;
            // something more meaningful than a print would be good
            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            System.out.println(e);
            return "";
        }
    }

    public static String getMotherNameByRAMQ(String ramqID){
        try{
            String querySQL = "SELECT * FROM MOTHER WHERE ramqID=" + ramqID;
            java.sql.ResultSet rs = statement.executeQuery (querySQL);
            if (rs.next()){
                String motherName = rs.getString(8);
                return motherName;
            } else {
                return "";
            }
        }
        catch (SQLException e)
        {
            sqlCode = e.getErrorCode(); // Get SQLCODE
            sqlState = e.getSQLState(); // Get SQLSTATE
                
            // Your code to handle errors comes here;
            // something more meaningful than a print would be good
            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            System.out.println(e);
            return "";
        }
    }
}
