package service;

import database.DatabaseManager;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.Queue;
import model.QueueUser;

public class QueueManager {

    // Actual Queue data structure
    private Queue<QueueUser> queue = new LinkedList<>();

    // Starting token number
    private int nextToken;

public QueueManager() {
    nextToken = DatabaseManager.getNextToken();
}


    // ==========================================
    // 1. JOIN QUEUE
    // ==========================================

    public QueueUser joinQueue(String userName) {

        QueueUser user = new QueueUser(nextToken, userName);

        queue.add(user);

        DatabaseManager.saveUser(
        user.getTokenNumber(),
        user.getUserName(),
        user.getStatus()
    );

        nextToken++;

        return user;
    }


    // ==========================================
    // 2. GET CURRENT USER
    // ==========================================

    public QueueUser getCurrentUser() {

        return queue.peek();
    }


    // ==========================================
    // 3. GET USER POSITION
    // ==========================================

    public int getPosition(int tokenNumber) {

        int position = 1;

        for (QueueUser user : queue) {

            if (user.getTokenNumber() == tokenNumber) {
                return position;
            }

            position++;
        }

        return -1;
    }


    // ==========================================
    // 4. CALL CURRENT USER
    // ==========================================

    public QueueUser callNext() {

    QueueUser user = queue.peek();

    if (user != null) {

        user.setStatus("CALLED");

        DatabaseManager.updateStatus(
            user.getTokenNumber(),
            "CALLED"
        );
    }

    return user;
}


    // ==========================================
    // 5. SERVE CURRENT USER
    // ==========================================

    public QueueUser serveNext() {

    QueueUser user = queue.poll();

    if (user != null) {

        user.setStatus("SERVED");

        DatabaseManager.updateStatus(
            user.getTokenNumber(),
            "SERVED"
        );
    }

    return user;
}


    // ==========================================
    // 6. SKIP USER
    // ==========================================

    public QueueUser skipUser(int tokenNumber) {

    Iterator<QueueUser> iterator = queue.iterator();

    while (iterator.hasNext()) {

        QueueUser user = iterator.next();

        if (user.getTokenNumber() == tokenNumber) {

            iterator.remove();

            user.setStatus("SKIPPED");

            DatabaseManager.updateStatus(
                user.getTokenNumber(),
                "SKIPPED"
            );

            return user;
        }
    }

    return null;
}


    // ==========================================
    // 7. GET QUEUE SIZE
    // ==========================================

    public int getQueueSize() {

        return queue.size();
    }


    // ==========================================
    // 8. CHECK IF QUEUE IS EMPTY
    // ==========================================

    public boolean isEmpty() {

        return queue.isEmpty();
    }


    // ==========================================
    // 9. DISPLAY QUEUE
    // ==========================================

    public void displayQueue() {

        System.out.println("\n----- CURRENT QUEUE -----");

        if (queue.isEmpty()) {

            System.out.println("Queue is empty.");

            return;
        }

        for (QueueUser user : queue) {

            System.out.println(
                "Token: " + user.getTokenNumber()
                + " | Name: " + user.getUserName()
                + " | Status: " + user.getStatus()
            );
        }

        System.out.println("-------------------------");
    }
}