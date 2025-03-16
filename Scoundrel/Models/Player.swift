//
//  Player.swift
//  Scoundrel
//
//  Created by David Freeman on 2/23/25.
//

import SwiftUI

class Player: ObservableObject, Codable {
    @Published var health: Int
    @Published var weapon: Int?
    @Published var lastAttacked: Int?
    
    let animationDelay: CGFloat = 0.3
    let scaleAmount: CGFloat = 0.1
    @Published var healthIconSize: CGFloat = 1
    @Published var weaponIconSize: CGFloat = 1
    @Published var shieldIconSize: CGFloat = 1
    
    init() {
        health = 20
        weapon = nil
        lastAttacked = nil
    }
    
    func reset() {
        health = 20
        weapon = nil
        lastAttacked = nil
    }
    
    func equipWeapon(weaponStrength: Int) {
        weapon = weaponStrength
        withAnimation {
            lastAttacked = 15
        }
        
        self.weaponIconSize += scaleAmount
        self.shieldIconSize += scaleAmount
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
            self.weaponIconSize = 1
            self.shieldIconSize = 1
        }
    }
    
    func useHealthPotion(potionStrength: Int) {
        withAnimation {
            health = min(health + potionStrength, 20)
        }
        
        self.healthIconSize += scaleAmount
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
            self.healthIconSize = 1
        }
    }
    
    func canAttackWithWeapon(monsterStrength: Int) -> Bool {
        if weapon == nil {
            return false
        }
        
        if lastAttacked != nil && lastAttacked! <= monsterStrength {
            return false
        }
        
        return true
    }
    
    func attack(withWeapon: Bool = false, monsterStrength: Int) {
        let startingHealth: Int = health
        
        if withWeapon {
            withAnimation {
                lastAttacked = monsterStrength
            }
            
            self.weaponIconSize -= scaleAmount
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
                self.weaponIconSize = 1
            }
            
            if monsterStrength > weapon ?? 0 {
                withAnimation {
                    health = max((health - (monsterStrength - (weapon ?? 0))), 0)
                }
            }
            
            if lastAttacked == 2 {
                weapon = nil
                lastAttacked = nil
                self.weaponIconSize -= scaleAmount
                self.shieldIconSize -= scaleAmount
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
                    self.weaponIconSize = 1
                    self.shieldIconSize = 1
                }
            }
            
        } else {
            withAnimation {
                health = max(health - monsterStrength, 0)
            }
        }
        
        if startingHealth != health {
            self.healthIconSize -= scaleAmount
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
                self.healthIconSize = 1
            }
        }
    }
    
    func strongestMonsterThatCanBeAttacked() -> Int {
        return max((lastAttacked ?? 0)-1, 0)
    }
    
    // Required for Codable protocol conformance
    enum CodingKeys: CodingKey {
        case health
        case weapon
        case lastAttacked
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        health = try container.decode(Int.self, forKey: .health)
        weapon = try container.decode(Int?.self, forKey: .weapon)
        lastAttacked = try container.decode(Int?.self, forKey: .lastAttacked)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(health, forKey: .health)
        try container.encode(weapon, forKey: .weapon)
        try container.encode (lastAttacked, forKey: .lastAttacked)
    }
}
