//
//  ViewController.swift
//  ResultTypeDemo
//
//  Created by Shubham Kapoor on 31/01/20.
//  Copyright © 2020 Shubham Kapoor. All rights reserved.
//

import UIKit

struct Course: Decodable {
    let id: Int
    let name: String
    let link: String
    let imageUrl: String
    let number_of_lessons: Int
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    func getData() {
        fetchCoursesJSON_5 { (result) in
            switch result {
            case .failure(let error):
                print("Failed to fetch courses with error:- \(error)")
            case .success(let allCourses):
                allCourses.forEach { (course) in
                    print(course.name)
                }
            }
        }
    }
    
    func getData_4_2() {
        fetchCoursesJSON_4_2 { (courses, error) in
            if let err = error {
                print("Failed to fetch courses with error:- \(err)")
                return
            }
            
            courses?.forEach({ (course) in
                print(course.name)
            })
        }
    }
}

/// In Swift 4.2 we were using completion block with the escaping having two variables one error and one expected Obj.
fileprivate func fetchCoursesJSON_4_2(completion: @escaping ([Course]?, Error?) -> ()) {
    
    let urlString = "http://api.letsbuildthatapp.com/jsondecodable/courses"
    guard let url = URL(string: urlString) else {
        print("Error in URL String.")
        return
    }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        if let err = error {
            completion(nil, err)
            return
        }
        
        guard let responseData = data else {
            completion(nil, nil)
            return
        }
        
        do {
            let courses = try JSONDecoder().decode([Course].self, from: responseData)
            completion(courses, nil)
        } catch let jsonError {
            completion(nil, jsonError)
        }
    }.resume()
}
    
/// In Swift 5 we get Result Type which gives a proper idea to define the result type.
fileprivate func fetchCoursesJSON_5(completion: @escaping (Result<[Course], Error>) -> ()) {
    
    let urlString = "http://api.letsbuildthatapp.com/jsondecodable/courses"
    guard let url = URL(string: urlString) else {
        print("Error in URL String.")
        return
    }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        if let err = error {
            completion(.failure(err))
            return
        }
        
        guard let responseData = data else {
            completion(.failure(SelfGeneratedError.nilResponse))
            return
        }
        
        do {
            let courses = try JSONDecoder().decode([Course].self, from: responseData)
            completion(.success(courses))
        } catch let jsonError {
            completion(.failure(jsonError))
        }
    }.resume()
}

enum SelfGeneratedError: Error {
    case unknownError
    case nilResponse
}

extension SelfGeneratedError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .unknownError:
            return "Unknown Response"
        case .nilResponse:
            return "NIL API Response"
        }
    }
}
