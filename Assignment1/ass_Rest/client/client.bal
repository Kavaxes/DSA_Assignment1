import ballerina/http;
import ballerina/io;
import ballerina/time;

type Program record {|
   readonly string Programme_Code;
    int NQF_Level;
    string Faculty;
    string Programme;
    time:Date Registration_Date;
    string Department;
    string[] Programme_Courses;
|};

public function main() returns error? {

    // Define the HTTP client to communicate with the service running on localhost:9090
    http:Client ProgramsClient = check new ("localhost:9090");

    // Ask the user if they want to retrieve, add, update or delete a program
    string action = io:readln("Welcome to the Program management System\n" +
    "Choose what to do \n" +
        "1.Retrieve a program?\n" +
        "2.Add a program?\n" +
        "3.Update a program?\n" + 
        "4.Delete a program?:\n"
    );
    
    
    
    if(action == "1"){
         // Ask the user if they want to retrieve all programs or a specific one
        string choice = io:readln("Do you want to retrieve " +
            "1.All programs " +
            "2.A Specific program " +
            "3.Programs up for review?: "
        );
    
            if (choice == "2") {
                string choice_2 = io:readln("Do you want to retrieve by " +
                    "1.Program code, " +
                    "2.Faculty" +
                    "3.Department " +
                    "4.Registration date?:"
                );

                    if(choice_2 == "1") {
                        // Prompt the user for the Program Code of the specific program they want
                        string progCode = io:readln("Enter the Program Code to retrieve: ");
                        // Send a GET request with the Programme_Code query parameter
                        Program program = check ProgramsClient->get("/Programs?Programme_Code=" + progCode);
                        io:println("Program details: ", program.toJsonString());
                    }else{
                    if(choice_2 == "2"){
                        string Faculty = io:readln("Enter the faculty to retrieve: ");
                        // Send a GET request with the Programme_Code query parameter
                        Program program = check ProgramsClient->get("/Programs?Faculty=" + Faculty);
                        io:println("Program details: ", program.toJsonString());
                    }else{
                    if(choice_2 == "3"){
                        string Department = io:readln("Enter the Department to retrieve: ");
                        // Send a GET request with the Programme_Code query parameter
                        Program program = check ProgramsClient->get("/Programs?Department=" + Department);
                        io:println("Program details: ", program.toJsonString());
                    }else{
                    if(choice_2 == "4"){
                        string Registration_Date = io:readln("Enter the Registration date: ");
                        // Send a GET request with the Programme_Code query parameter
                        Program program = check ProgramsClient->get("/Programs?Registration_Date=" + Registration_Date);
                        io:println("Program details: ", program.toJsonString());
                    }
                    }
                    }
                }
        
            } else if (choice == "1") {
                // Retrieve all programs
                Program[] Programs = check ProgramsClient->get("/Programs");
                io:println("All programs available: ", Programs.toJsonString());
        
            }
            else if(choice == "3") {
                // Send a GET request to retrieve programs due for review
                Program[] programsForReview = check ProgramsClient->get("/reviewPrograms");

                // Print the programs that need to be reviewed
                if programsForReview.length() == 0 {
                io:println("No programs are due for review.");
                } else {
                io:println("Programs due for review: ", programsForReview.toJsonString());
                }
            }

    }else{
    if(action == "2"){
        //Prompt user to enter new program
        string code = io:readln("Enter Program Code: ");
        int level = check 'int:fromString(io:readln("Enter NQF Level: "));
        string faculty = io:readln("Enter Faculty: ");
        string programme = io:readln("Enter Programme Name: ");
        int year = check 'int:fromString(io:readln("Enter Registration Year: "));
        int month = check 'int:fromString(io:readln("Enter Registration Month (1-12): "));
        int day = check 'int:fromString(io:readln("Enter Registration Day: "));
        string department = io:readln("Enter Department: ");
   
        string[] courses = [];
    while (true) {
        string course = io:readln("Enter Programme Course (type 'done' to finish): ");
        if (course == "done") {
            break;
        }
        courses.push(course);
    }

    // ----------- POST Request (Add a new Program) ------------
    // Define a new Program
    Program newProgram = {
        Programme_Code: code,
        NQF_Level: level, 
        Faculty: faculty, 
        Programme: programme,
        Registration_Date: ({year: year, month: month, day: day}),
        Department: department,
        Programme_Courses: courses
    };

    // Send a POST request to add the new Program to the /Programs endpoint
    Program addedProgram = check ProgramsClient->post("/Programs", newProgram);

    io:println("New Program added: Programme_Code: ", addedProgram.Programme_Code +" " , 
    "NQF_Level: ", addedProgram.NQF_Level  ,
    "Faculty: ", addedProgram.Faculty +" " , 
    "Programme: ", addedProgram.Programme +" " , 
    "Registration_Date: ", addedProgram.Registration_Date  , 
    "Department: ", addedProgram.Department+" " ); 
    //"Programme_Courses: ", addedProgram.Programme_Courses);

    }else{
    if(action == "3"){
        // ----------- Prompt the User for Updated Program Information ------------
        string u_code = io:readln("Enter the Program Code to update: ");
        int u_level = check 'int:fromString(io:readln("Enter updated NQF Level: "));
        string u_faculty = io:readln("Enter updated Faculty: ");
        string u_programme = io:readln("Enter updated Programme Name: ");
        int u_year = check 'int:fromString(io:readln("Enter updated Registration Year: "));
        int u_month = check 'int:fromString(io:readln("Enter updated Registration Month (1-12): "));
        int u_day = check 'int:fromString(io:readln("Enter updated Registration Day: "));
        string u_department = io:readln("Enter updated Department: ");

        // Prompt for multiple course inputs for updated courses
        string[] u_courses = [];
    while (true) {
        string course = io:readln("Enter updated Programme Course (type 'done' to finish): ");
        if (course == "done") {
            break;
        }
        u_courses.push(course);
    }

    // Create the updated Program record
    Program updatedProgram = {
        Programme_Code: u_code,
        NQF_Level: u_level,
        Faculty: u_faculty,
        Programme: u_programme,
        Registration_Date: {year: u_year, month: u_month, day: u_day},
        Department: u_department,
        Programme_Courses: u_courses
    };

    // ----------- PUT Request to Update the Program ------------
    string response = check ProgramsClient->put("/Programs/" + u_code, updatedProgram);

    io:println(response);


    }else{
    if (action == "4") {
        // Prompt the user for the Program Code of the program to delete
        string progCode = io:readln("Enter the Program Code to delete: ");
        
        // Send a DELETE request to delete the program
        string deleteProgram = check ProgramsClient->delete("/Programs/" + progCode);
        io:println(deleteProgram);
        }
    }

    }
    }
}
// Define the Program record type


