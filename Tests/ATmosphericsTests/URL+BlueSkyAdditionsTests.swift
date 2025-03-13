//
//  URL+BlueSkyAdditionsTests.swift
//  ATmospherics
//
//  Created by Joseph Wardell on 3/13/25.
//

import Foundation
import Testing

@testable import ATmospherics

@Suite("URL+BlueSkyAdditions")
struct URL_BlueSkyProfileHandle {

    @Test func returns_nil_if_not_http() async throws {
        let sut = URL(string: "file://")!
        #expect(nil == sut.blueSkyProfileHandle)
    }

    @Test func returns_nil_if_host_not_bsky() async throws {
        let sut = URL(string: "http://apple.com/profile/abcde")!
        #expect(nil == sut.blueSkyProfileHandle)
    }

    @Test func returns_nil_if_empty_path() async throws {
        let sut = URL(string: "http://bsky.app")!
        #expect(nil == sut.blueSkyProfileHandle)
    }

    @Test func returns_nil_if_path_does_not_contain_profile_keyword() async throws {
        let sut = URL(string: "https://bsky.app/lists")!
        #expect(nil == sut.blueSkyProfileHandle)
    }

    @Test func returns_nil_if_path_does_not_contain_handle() async throws {
        let sut = URL(string: "https://bsky.app/profile/")!
        #expect(nil == sut.blueSkyProfileHandle)
    }

    @Test func returns_handle() async throws {
        let profile = "jaywardell.bsky.social"
        let sut = URL(string: "https://bsky.app/profile/")!.appendingPathComponent(profile)
        #expect(profile == sut.blueSkyProfileHandle)
    }

    @Test func returns_handle_given_posy_URL() async throws {
        let profile = "jaywardell.bsky.social"
        let sut = URL(string: "https://bsky.app/profile/")!.appendingPathComponent(profile)
            .appending(component: "post")
            .appending(component: "3lces4pe6u22w")
        #expect(profile == sut.blueSkyProfileHandle)
    }

}
