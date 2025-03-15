//
//  Array+FirstInstanceAfter.swift
//  ATmospherics
//
//  Created by Joseph Wardell on 3/15/25.
//

import Foundation

extension Array where Element: Equatable {

    // TODO: need tests for this
    func itemAfterFirstInstance(of precedingElement: Element) -> Element? {
        guard let precedingIndex = firstIndex(of: precedingElement),
              count > precedingIndex + 1
        else { return nil }
        return self[precedingIndex + 1]
    }
}
