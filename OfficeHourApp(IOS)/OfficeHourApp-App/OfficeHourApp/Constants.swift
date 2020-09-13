//
//  Constants.swift
//  OfficeHourApp
//
//  Created by Kai Chen on 6/24/20.
//  Copyright © 2020 Kai Chen. All rights reserved.
//

// Name: Kaiwne Chen
// ID: 111968628

import Foundation

struct DBConstants{
    static let userAccount = "UserAccount"
    static let studentInfo = "StudentsInfo"
    static let adminInfo = "AdminsInfo"
    static let adminClassTitle = "classTitle"
    static let adminName = "name"
    static let adminNumberOfStudents = "numberOfStudents"
    static let adminUserName = "userName"
    static let studentName = "name"
    static let studentPosition = "position"
    static let studentProfessor = "professor"
    static let studentReady = "ready"
    static let studentRegisterTime = "registerTime"
    static let studentUserName = "userName"
    static let userAccountType = "accountType"
    static let userUserName = "userName"
    static let userPassword = "password"
    static let userFirstName = "firstName"
    static let userLastName = "lastName"
    static let studentAppointmentTime = "appointmentTime"
    static let studentAppointedClass = "appointedClass"
    static let studentProfessorName = "professorName"
}

struct accountType{
    static let student = "student"
    static let admin = "admin"
}

struct SortField{
    static let sortByField = "sortbyfield"
    static let sortByAscending = "sortbyacending"
    static let sortByFieldProfessor = "sortbyfieldprofessor"
    static let sortByAscendingProfessor = "sortbyacendingprofessor"
}
