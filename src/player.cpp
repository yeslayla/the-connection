#include "player.h"

using namespace godot;

void Player::_register_methods() {
    register_method("_process", &Player::_process);
}

Player::Player() {

    //==========
    // MOVEMENT
    //==========
    maxMoveVelocity = 100.0;
    moveAcceleration = 50.0;
    jumpAccelration = -80.0;

    baseGravity = 150.0;
    moveFriction = 40.0;

    velocity = Vector2(0,0);
}
Player::~Player() {}

void Player::_init() {
    //input = Input::get_singleton();
    Godot::print("Loaded player object!");
}

void Player::_process(float delta) {

    // Process movement
    if(!is_movement_locked()) {
        apply_gravity(velocity, delta);
        apply_friction(velocity);
        apply_movement_input(velocity, get_movement_input(), delta);
        move_and_slide(velocity, Vector2(0,-1));
    }
}

bool Player::is_movement_locked() {
    return false;
}

Vector2 Player::get_movement_input() {
    Vector2 inputVector = Vector2(0,0);

    
    // Update X input for left and right
    if(Input::get_singleton()->is_action_pressed("move_left")) {
        inputVector.x = -1;
    }
    if(Input::get_singleton()->is_action_pressed("move_right")) {
        inputVector.x = 1;
    }

    // Update Y input for jumping
    if(Input::get_singleton()->is_action_pressed("jump")) {
        inputVector.y = 1;
    }

    return inputVector;
}

void Player::apply_movement_input(Vector2 &velocity, Vector2 inputVector, float delta) {
    velocity.x += inputVector.x * moveAcceleration; // Mutiply speed by input value

    if(inputVector.y > 0 && is_on_floor() and velocity.y >= 0) {
        // Massively increase `y` velocity to send player up into the air
        velocity.y = inputVector.y * jumpAccelration; 
    }
}

void Player::apply_friction(Vector2 &velocity) {
    // Move x velocity towards zero by `moveFriction` value
    if(velocity.x > 0) {
        velocity.x = Math::clamp<float>(velocity.x - moveFriction, 0, maxMoveVelocity);
    } else if (velocity.x < 0) {
        velocity.x = Math::clamp<float>(velocity.x + moveFriction, -maxMoveVelocity, 0);
    }
}

void Player::apply_gravity(Vector2 &velocity, float delta) {

    if(is_on_floor()) {
        // Keep Y velocity static while on the ground
        velocity.y = 0;
    } else {
        // Apply gravity while in the air
        velocity.y += baseGravity * delta;
    }
}