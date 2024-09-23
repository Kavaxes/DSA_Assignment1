import ballerina/http;
import ballerina/time;
import ballerina/io;

type Course record {
    string CourseName;
    string CourseCode;
    int nqflevel;
    string[] courseinfo = []; // Add information about the course
};


type Program record {|
   readonly string Programme_Code;
    int NQF_Level;
    string Faculty;
    string Programme;
    time:Date Registration_Date;
    string Department;
    string[] Programme_Courses;
|};

table<Program> key(Programme_Code) Programs = table [
    {Programme_Code: "CS101",NQF_Level: 7,Faculty: "Faculty of Science and Technology", Programme: "Bachelor of Science in Computer Science", Registration_Date: ({year: 2024, month: 10, day: 15}), Department: "Department of Computer Science", Programme_Courses:["CSC101 - Introduction to Computer Science","MAT101 - Calculus I", "PHY101 - Physics I", "ENG101 - Academic Writing", "CSC102 - Discrete Mathematics \n"]},
    
    {Programme_Code: "DSF12",NQF_Level: 7,Faculty: "Faculty of Science and Technology", Programme: "Bachelor of Water in H2O", Registration_Date: ({year: 2018, month: 10, day: 15}), Department: "Department of Computer Science", Programme_Courses:["DSA101 - Distribute Water","POS101 - Drink I", "CHE101 - Chemistry I", "JET210 - Jump Eat Tea", "GGH - Good God Hallelujah\n"]},

    {Programme_Code: "ENG542",NQF_Level: 7,Faculty: "Faculty of Physical Activity", Programme: "Bachelor of Movement at Own Risk ", Registration_Date: ({year: 2014, month: 10, day: 15}), Department: "Department of Movement", Programme_Courses:["MVE - Movement 101","KUT - Kick Up 101\n"]}
];

service /TheManagementProgramme on new http:Listener(9090) {

    // Retrieve all programs or a specific program based on query parameters
    resource function get Programs(http:Request req) returns Program[]|Program|error {
    // Get the query parameter `Programme_Code`
    string? progCode = req.getQueryParamValue("Programme_Code");

    if (progCode is string) {
        // Return the specific program if found
        foreach var program in Programs {
            if (program.Programme_Code == progCode) {
                return program;
            }
        }
        // Return an error if the program is not found
        return error("Program with Programme_Code '" + progCode + "' not found");
    } 
    // If no Programme_Code is provided, return all programs
    return Programs.toArray();
}

resource function get reviewPrograms() returns Program[]|error {
    // Get the current time and convert it to a Date object
    time:Utc currentUtcTime = time:utcNow();
    time:Civil currentDate = time:utcToCivil(currentUtcTime);

    // Initialize an empty array to store programs due for review
    Program[] programsDueForReview = [];

    // Iterate over all programs in the table
    foreach var program in Programs {
        // Calculate the number of years between the current date and the program's registration date
        int yearDifference = currentDate.year - program.Registration_Date.year;

        // If the program has been registered for more than 5 years, add it to the list
        if (yearDifference > 5 || (yearDifference == 5 && isDatePassed(program.Registration_Date, currentDate))) {
            programsDueForReview.push(program);
        }
    }

    // Return the programs due for review
    return programsDueForReview;
}

// Helper function to check if the current date is past the program's registration date within the same year
function isDatePassed(time:Date registrationDate, time:Date currentDate) returns boolean {
    if (currentDate.month > registrationDate.month) {
        return true;
    } else if (currentDate.month == registrationDate.month && currentDate.day >= registrationDate.day) {
        return true;
    }
    return false;
}
    //adding new program
   resource function post Programs(Program program) returns Program {
        Programs.add(program);
        string response = 
                          "The programme added";
        io:println("🎊 " + response);
        return program;  
   }
   
   // PUT: Update a program by Programme_Code
    resource function put Programs/[string Programme_Code](Program updatedProgram) returns string|error {
        Program? program = Programs[Programme_Code];

        if program is Program {
            // Update the program details
            program.NQF_Level = updatedProgram.NQF_Level;
            program.Faculty = updatedProgram.Faculty;
            program.Programme = updatedProgram.Programme;
            program.Registration_Date = updatedProgram.Registration_Date;
            program.Department = updatedProgram.Department;
            program.Programme_Courses = updatedProgram.Programme_Courses;

            return "Program with Programme_Code '" + Programme_Code + "' updated successfully.";
        } else {
            return "Program with Programme_Code '" + Programme_Code + "' not found.";
        }    
    }

    resource function delete Programs/[string progCode]() returns string|error {
        //check if program exists in the table using the table's key
        Program? program = Programs[progCode];

        if (program is Program) {
            Program _ = Programs.remove(progCode);
            return "Program with Programme_Code '" + progCode + "' deleted successfully.";
        }
        
        return error("Program with Programme_Code '" + progCode + "' not found");
    }
}

function isDatePassed(time:Date program, time:Civil currentDate) returns boolean {
    return false;
}