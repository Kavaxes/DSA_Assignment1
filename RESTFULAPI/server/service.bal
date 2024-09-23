import ballerina/http;
import ballerina/io;
import ballerina/time;

const string CONST = "Fetching all programmes!";

type Course record {
    string CourseName;
    string CourseCode;
    int nqflevel;
    string[] courseinfo = []; // Add information about the course
};

type Programme record {|
    readonly string code;
    string faculty;
    string qualification_title;
    string registration_date;
    Course[] courses;
    string Avater = ""; // Adding an avater for each programme
|};

table<Programme> key(code) programme_table = table [];

// Fun phrases to use in responses
string[] phrases = [
    "Plata or Plomo", 
    "amazing", 
    "Holy Grail", 
    "Damn???"
];

// Simple random number generator
function getRandomIndex(int max) returns int {
    time:Utc currentTime = time:utcNow();
    int nanoTime = currentTime[0]; // Get nanoseconds
    return nanoTime % max;
}

service /TheManagementProgramme on new http:Listener(7500) {
    // Retrieve all programs or a specific program
    resource function get all() returns Programme[] {
        io:println(CONST);
        return programme_table.toArray();
    }
// Retrieve the details of a specific programme by their programme code
    resource function get getByCode/[string code]() returns Programme|string {
        Programme? programme = programme_table[code];
        if programme is Programme {
            io:println("programme found");
            return programme;
        }
        return "programme not found";
    }
 //Retrieve all the programmes that belong to the same faculty.
    resource function get faculty/[string faculty]() returns Programme[] {
        io:println("🏫 Searching for programmes.. " + faculty + " in all faculties!");
        Programme[] result = from Programme programme in programme_table
                             where programme.faculty == faculty
                             select programme;
        return result;
    }
    // Add a new programme
    resource function post add_new_programme(Programme programme) returns string {
        programme_table.add(programme);
        string response = 
                          "The programme '" + programme.qualification_title + "programme added";
        io:println("🎊 " + response);
        return response;
    }

//Update an existing programme's information according to the programme code
    resource function put update_programme/[string code](Programme programme) returns string {
        if (programme_table.hasKey(code)) {
            programme_table.put(programme);
            string response = "update successful";
            io:println(" Done " + response);
            return response;
        }
        return "unsuccessful update attempt";
    }

//Delete a programme's record by their programme code
    resource function delete delete_programme/[string code]() returns string {
        if (programme_table.hasKey(code)) {
            Programme result = programme_table.remove(code);
            string response = "oblitirated" + result.qualification_title + "programme successfully deleted";
            io:println("try again" + response);
            return response;
        }
        return "program not found";
    }

    // New fun resource: Get a random fun fact about a course
    resource function get random_fun_fact/[string code]() returns string {
        Programme? programme = programme_table[code];
        if programme is Programme {
            if programme.courses.length() > 0 {
                int randomCourseIndex = getRandomIndex(programme.courses.length());
                Course randomCourse = programme.courses[randomCourseIndex];
                if randomCourse.courseinfo.length() > 0 {
                    int randomFactIndex = getRandomIndex(randomCourse.courseinfo.length());
                    return string `course info ${randomCourse.courseinfo[randomFactIndex]}`;
                }
                return "no info added to this course, sorry!";
            }
            return "This programme doesn't have any courses to share info about!";
        }
        return " Programme not found.";
    }

    //Retrieve all the programme that are due for review
        resource function get programmesDueForReview(http:Caller caller) returns error? {
    map<Programme> dueProgrammes = {};

    foreach var code in dueProgrammes.keys() {
        Programme prog = <Programme>dueProgrammes[code];
        int regYear = check int:fromString(prog.registration_date.substring(0, 4));
        if (2024 - regYear >= 5) { // Assume current year is 2024
            dueProgrammes[code] = prog;
        }
    }
    check caller->respond(dueProgrammes.toJson());
}
}
