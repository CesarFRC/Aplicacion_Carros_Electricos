import Foundation

class UserSession {
    static let shared = UserSession()
    
    private let userIdKey = "logged_in_user_id_string"
    
    var userId: String? {
        get {
            return UserDefaults.standard.string(forKey: userIdKey)
        }
        set {
            if let id = newValue {
                UserDefaults.standard.set(id, forKey: userIdKey)
            } else {
                UserDefaults.standard.removeObject(forKey: userIdKey)
            }
        }
    }
    
    var isLoggedIn: Bool {
        return userId != nil
    }
    
    func logout() {
        userId = nil
    }
    
    func printCurrentUser() {
        print("➡️ Estado de Sesión: \(isLoggedIn ? "Logueado" : "Desconectado") - ID: \(userId ?? "N/A")")
    }
}
