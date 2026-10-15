import java.util.Scanner;
import model.QueueUser;
import service.QueueManager;

public class Main {

    public static void main(String[] args) {

        Scanner scanner = new Scanner(System.in);
        QueueManager queueManager = new QueueManager();

        boolean running = true;

        while (running) {

            System.out.println("\n===== VIRTUAL QUEUE SYSTEM =====");
            System.out.println("1. Join Queue");
            System.out.println("2. Check Position");
            System.out.println("3. Call Next");
            System.out.println("4. Serve Current User");
            System.out.println("5. Skip User");
            System.out.println("6. Display Queue");
            System.out.println("7. Exit");

            System.out.print("\nEnter your choice: ");

            int choice = scanner.nextInt();
            scanner.nextLine();

            switch (choice) {

                case 1:

                    System.out.print("Enter your name: ");
                    String name = scanner.nextLine();

                    QueueUser newUser =
                            queueManager.joinQueue(name);

                    System.out.println(
                            "\nToken generated: "
                            + newUser.getTokenNumber()
                    );

                    System.out.println(
                            "You joined the queue successfully!"
                    );

                    break;

                case 2:

                    System.out.print("Enter token number: ");
                    int token = scanner.nextInt();

                    int position =
                            queueManager.getPosition(token);

                    if (position != -1) {

                        System.out.println(
                                "Your current position: "
                                + position
                        );

                    } else {

                        System.out.println(
                                "Token not found in the queue."
                        );
                    }

                    break;

                case 3:

                    QueueUser calledUser =
                            queueManager.callNext();

                    if (calledUser != null) {

                        System.out.println(
                                "\nCalling Token: "
                                + calledUser.getTokenNumber()
                        );

                        System.out.println(
                                "User: "
                                + calledUser.getUserName()
                        );

                        System.out.println(
                                "Status: "
                                + calledUser.getStatus()
                        );

                    } else {

                        System.out.println(
                                "Queue is empty."
                        );
                    }

                    break;

                case 4:

                    QueueUser servedUser =
                            queueManager.serveNext();

                    if (servedUser != null) {

                        System.out.println(
                                "\nServed Token: "
                                + servedUser.getTokenNumber()
                        );

                        System.out.println(
                                "User: "
                                + servedUser.getUserName()
                        );

                        System.out.println(
                                "Status: "
                                + servedUser.getStatus()
                        );

                    } else {

                        System.out.println(
                                "Queue is empty."
                        );
                    }

                    break;

                case 5:

                    System.out.print(
                            "Enter token number to skip: "
                    );

                    int skipToken = scanner.nextInt();

                    QueueUser skippedUser =
                            queueManager.skipUser(skipToken);

                    if (skippedUser != null) {

                        System.out.println(
                                "\nSkipped Token: "
                                + skippedUser.getTokenNumber()
                        );

                        System.out.println(
                                "User: "
                                + skippedUser.getUserName()
                        );

                        System.out.println(
                                "Status: "
                                + skippedUser.getStatus()
                        );

                    } else {

                        System.out.println(
                                "Token not found."
                        );
                    }

                    break;

                case 6:

                    queueManager.displayQueue();

                    break;

                case 7:

                    running = false;

                    System.out.println(
                            "\nThank you for using Virtual Queue System!"
                    );

                    break;

                default:

                    System.out.println(
                            "Invalid choice. Please try again."
                    );
            }
        }

        scanner.close();
    }
}