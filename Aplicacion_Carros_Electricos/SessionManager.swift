import Foundation

class SessionManager {
    static let shared = SessionManager()
    
    // Usamos una llave para guardar en UserDefaults
    private let userIdKey = "logged_in_user_id_string"
    
    // Propiedad calculada para obtener y establecer el ID del usuario (String)
    var currentUserID: String? {
        get {
            // Leemos el ID guardado
            return UserDefaults.standard.string(forKey: userIdKey)
        }
        set {
            if let id = newValue {
                // Guardamos el ID
                UserDefaults.standard.set(id, forKey: userIdKey)
            } else {
                // Eliminamos el ID (Cerrar sesión)
                UserDefaults.standard.removeObject(forKey: userIdKey)
            }
        }
    }
    
    func logout() {
        currentUserID = nil
        // Podrías agregar lógica de limpieza de token u otros datos aquí
    }
}
