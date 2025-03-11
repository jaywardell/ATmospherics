import Testing
@testable import ATmospherics

@Suite("Atmosphere")
struct AtmosephereTests {
    
    @Test("Behavior of uncredentialed Atmosphere")
    func example() async throws {
        
        let sut = Atmosphere.uncredentialed
        
        let proto = try #require(try await sut.atProto())
        
        #expect(nil == proto.session)
    }

    @Test("Behavior of credentialed Atmosphere")
    func example2() async throws {
        let sut = Atmosphere(credential: .testingAccount)
        
        do {
            let proto = try await sut.atProto()
            #expect(nil != proto.session)
            #expect(false == proto.session?.accessToken.isEmpty)
            #expect(proto.session?.handle == "atmosphericstests.bsky.social")
        }
        catch {
            print(error.localizedDescription)
            print()
            print(error)
            #expect(1 + 1 == 3)
        }
    }
}

extension Atmosphere.Credential {
    // an account that can be used for testing purposes
    // yes, I'm releasing this on the web
    // please don't abuse
    static let testingAccount = Atmosphere.Credential(handle: "jay+bluesky_testing@jaywardell.me", appPassword: "vokdib-koxBo4-huczyz")
}
