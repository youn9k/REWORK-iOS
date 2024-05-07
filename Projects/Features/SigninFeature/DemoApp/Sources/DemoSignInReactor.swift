import UIKit
import ReactorKit
import RxSwift

public final class DemoSignInReactor: Reactor {
    public var initialState: State
    
    public enum Action {
        case viewDidLoad
        case keyboardWillShow(CGFloat)
        case keyboardWillHide
        case setEmail(String?)
        case loginButtonDidTap
    }
    
    public enum Mutation {
        case viewDidLoaded
        case setKeyboardHeight(CGFloat)
        case setEmailInfo((email: String, validationResult: ValidationResult))
        case isLoggedIn(Bool)
    }
    
    public struct State {
        var keyboardHeight: CGFloat
        var email: String
        var viewDidLoaded: Bool
        var validationResult: ValidationResult?
        var loggedIn: Bool
    }
    
    public init() {
        self.initialState = .init(
            keyboardHeight: 0,
            email: "",
            viewDidLoaded: false,
            loggedIn: false
        )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        print("✅ mutate 호출됨", action)
        switch action {
        case .viewDidLoad:
            return .just(.viewDidLoaded)
            
        case .keyboardWillShow(let height):
            return .just(.setKeyboardHeight(height))
            
        case .keyboardWillHide:
            return .just(.setKeyboardHeight(0))
            
        case .setEmail(let email):
            guard let email else { return .empty() }
            return .just(.setEmailInfo((email, email.validEmail)))
            
            
        case .loginButtonDidTap:
            return fetchUserInfo()
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        print("🚀 reduce 호출됨", mutation)
        var newState = state
        switch mutation {
        case .viewDidLoaded:
            newState.viewDidLoaded = true
            
        case .setKeyboardHeight(let height):
            newState.keyboardHeight = height
            
        case .setEmailInfo(let info):
            newState.email = info.email
            newState.validationResult = info.validationResult
            
        case .isLoggedIn(let isLoggedIn):
            newState.loggedIn = isLoggedIn
        }
        return newState
    }
    
}

private extension DemoSignInReactor {
    func fetchUserInfo() -> Observable<Mutation> {
        return .just(Mutation.isLoggedIn(true))
    }
}