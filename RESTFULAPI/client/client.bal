import ballerina/io;
import ballerina/http;

type Course record {
    string CourseName;
    string CourseCode;
    int nqflevel;
    string[] courseinfo;
};

type Programme record {|
    readonly string Code;
    string Faculty;
    string QualificationTitle;
    string RegistrationDate;
    string Department;
    Course[] courses;
    string Avater;
|};

// Student information placeholders
string StudentName = "Name";
string StudentNumber = "Student Number";
string[] systemDescription = [
    "Welcome to the Medellin Cartel Programme System!",
    "This system will allow you to manage university programmes and courses as you see fit.",
    "You can add, view, update, and delete programmes."
];


public function main() returns error? {
    http:Client programmeClient = check new ("http://localhost:7500/programmeManagament");
   // Define the HTTP client to communicate with the service running on localhost:9090
    http:Client _ = check new ("localhost:9090");

    io:println("programme management system");
    io:println("Student: " + StudentName);
    io:println("Student Number: " + StudentNumber);
    io:println("System Description:");
    foreach var line in systemDescription {
        io:println("  " + line);
    }

    while true {
        io:println("Pick one of the options below");
        io:println("1. View all programmes");
        io:println("2. Add a new programme");
        io:println("3. Update a programme");
        io:println("4. Delete a programme");
        io:println("5. INFO");
        io:println("6. Exit");

        string choice = io:readln("OPTIONS. CHOOSE OPTION (1-6): ");

        match choice {
            "1" => {
                Programme[] programmes = check programmeClient->/all();
                io:println("All Programmes:");
                foreach var prog in programmes {
                    io:println(string `${prog.Code}: ${prog.QualificationTitle} (${prog.Faculty}) - Mascot: ${prog.Avater}`);
                }
            }
             "2" => {
                Programme newProg = {
                    Code: io:readln("Enter programme code: "),
                    Faculty: io:readln("Enter faculty: "),
                    QualificationTitle: io:readln("Enter qualification title: "),
                    RegistrationDate: io:readln("Enter registration date: "),
                    courses: [],
                    Avater: io:readln("Enter programme AVATER: "),
                    Department: io:readln("Enter DEPARTMENT: ")
                    };
                string result = check programmeClient->/add_new_programme.post(newProg);
                io:println(result);
            }
            "3" => {
                string code = io:readln("Enter programme code to update: ");
                Programme updateProg = {
                    Code: code,
                    Faculty: io:readln("Enter new faculty: "),
                    QualificationTitle: io:readln("Enter new qualification title: "),
                    RegistrationDate: io:readln("Enter new registration date: "),
                    courses: [],
                    Department: io:readln("Enter programme DEPARTMENT: "),
                    Avater: io:readln("Enter new programme AVATER: ")
                };
                string result = check programmeClient->/update_programme/[code].put(updateProg);
                io:println(result);
            }
            "4" => {
                string code = io:readln("Enter programme code to delete: ");
                string result = check programmeClient->/delete_programme/[code].delete();
                io:println(result);
            }
            "5" => {
                string code = io:readln("Enter programme code for a random INFO about the program/course: ");
                string result = check programmeClient->/random_fun_fact/[code];
                io:println(result);
            }
            "6" => {
                io:println("have an amazing day, thanks for the visit");
                return;
            }
            _ => {
                io:println("Invalid choice. Please try again.");
            }
        }
    }
}

       