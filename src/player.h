#ifndef PLAYER_H
#define PLAYER_H

#include <Godot.hpp>
#include <KinematicBody2D.hpp>
#include <Input.hpp>
#include "enums.h"

namespace godot {

class Player : public KinematicBody2D {
    GODOT_CLASS(Player, KinematicBody2D);

//private:
//    float example_var;

public:
    // Method to register functions with Godot
    static void _register_methods();

    // Public variables
    //Clearance_Level clearance_level;
    
    // Contructor & Deconstructor
    Player();
    ~Player();

    void _init(); // Initializer called by Godot
    void _process(float delta); // Godot Process function
    //void _physics_process(float delta);

private:
    // Referenced Singletons
    //static Input* input;

    float baseGravity;

    // Player movment variables
    float maxMoveVelocity;
    float moveAcceleration;
    float jumpAccelration;
    float moveFriction;
    //float jumped;

    Vector2 velocity;
    //Vector2 motion;
    //Vector2 floor_speed;

    //Node gui; // Node representing GUI object

    //Array interactables; // Objects in range to interact with
    //Array items; // Items in player inventory
    //Node equiped; // Currently equiped item


    bool is_movement_locked();
    //void check_for_nodes();

    // Death management
    //void handle_death();
    //void death_fade_complete();

    // Inventory
    //void add_item(Node item);
    //void equip_item(Node item);

    // Interaction System
    //void add_interactable(Node interactable);
    //void remove_interactable(Node interactable);
    //void interact();

    //void animation_manager(float motion);
    Vector2 get_movement_input();
    void apply_movement_input(Vector2 &velocity, Vector2 inputVector, float delta);
    //void user_input();
    void apply_gravity(Vector2 &velocity, float delta);
    void apply_friction(Vector2 &velocity);
};

}

#endif