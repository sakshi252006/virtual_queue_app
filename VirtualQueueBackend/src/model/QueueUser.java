package model;

public class QueueUser {

    private int tokenNumber;
    private String userName;
    private String status;

    public QueueUser(int tokenNumber, String userName) {
        this.tokenNumber = tokenNumber;
        this.userName = userName;
        this.status = "WAITING";
    }

    public int getTokenNumber() {
        return tokenNumber;
    }

    public String getUserName() {
        return userName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}