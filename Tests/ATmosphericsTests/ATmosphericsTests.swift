import Testing
@testable import ATmospherics
import ATProtoKit

@Suite("Atmosphere")
struct AtmosephereTests {
    
    @Test("Behavior of uncredentialed Atmosphere")
    func uncredentialed() async throws {
        
        let sut = Atmosphere.uncredentialed
        
        let proto = try #require(try await sut.atProto())
        
        #expect(nil == proto.session)
    }
    
    @preconcurrency
    @Test("Behavior of Atmosphere with empty credentials")
    func empty_credentials() async throws {
        let sut = Atmosphere(credential: .init(handle: "", appPassword: ""))
                
        do {
            _ = try await sut.atProto()
        }
        catch {
            let error = try #require(error as? ATAPIError)
            switch error {
                
            // the error we expect
            case .unauthorized: break
            
            // this can sometimes happen when we're doing lots of tests
            case .tooManyRequests: break
                
            // any other error is not expected
            default: Issue.record("received an unexpected error \(error)")
            }
        }
    }


    @Test("Behavior of credentialed Atmosphere")
    func credentialed() async throws {
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
