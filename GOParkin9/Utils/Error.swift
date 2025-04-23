//
//  Error.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 23/04/25.
//

import Foundation

enum RepositoryError: Error {
    case saveFailed
    case fetchFailed
    case deleteFailed
    case invalidData
    case contextNotFound
    case createFailed
    case updateFailed
    case queryFailed
}
