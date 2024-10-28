#include <gb/gb.h>
#include <stdio.h>
#include <rand.h>
#include "C:\gameboyGame\application\assets\sprites\hero.c"
#include "C:\gameboyGame\application\assets\sprites\hero2.c"
#include "C:\gameboyGame\application\assets\sprites\enemy.c"
#include "C:\gameboyGame\application\assets\sprites\enemy2.c"
#include "C:\gameboyGame\application\assets\sprites\bullet.c"
#include "C:\gameboyGame\application\assets\sprites\bullet2.c"

#define MAX_BULLETS 10 // Maximum de boules d'énergie actives

UINT8 enemy_x = 120;
UINT8 enemy_y = 78;
UINT8 enemySpriteIndex = 0;
UINT8 enemySpeed = 1;
UINT8 enemyAnimationCounter = 0;

UINT8 hero_x = 10;
UINT8 hero_y = 10;
UINT8 heroSpriteIndex = 0;

// Structure pour gérer les boules d'énergie
struct Bullet {
    UINT8 x;
    UINT8 y;
    INT8 direction; // -1 pour la gauche, 1 pour la droite
    UINT8 active;
    UINT8 animationCounter;
    UINT8 spriteIndex;
};

struct Bullet bullets[MAX_BULLETS];

// Fonction d'initialisation des boules
void initialize_bullets() {
    for (UINT8 i = 0; i < MAX_BULLETS; i++) {
        bullets[i].x = 0;
        bullets[i].y = 0;
        bullets[i].direction = 1;
        bullets[i].active = 0;
        bullets[i].animationCounter = 0;
        bullets[i].spriteIndex = 0;
    }
}

// Fonction pour tirer une nouvelle paire de boules d'énergie
void fire_bullets() {
    for (UINT8 i = 0; i < MAX_BULLETS; i += 2) {
        if (!bullets[i].active && !bullets[i + 1].active) {
            bullets[i].x = hero_x;
            bullets[i].y = hero_y;
            bullets[i].direction = 1; // Droite
            bullets[i].active = 1;

            bullets[i + 1].x = hero_x;
            bullets[i + 1].y = hero_y;
            bullets[i + 1].direction = -1; // Gauche
            bullets[i + 1].active = 1;

            // On utilise deux sprites (un pour chaque direction)
            set_sprite_tile(8 + i, 16);      // Première frame (bullet) pour la droite
            set_sprite_tile(8 + i + 1, 17);  // Deuxième frame (bullet2) pour la gauche

            move_sprite(8 + i, bullets[i].x, bullets[i].y);
            move_sprite(8 + i + 1, bullets[i + 1].x, bullets[i + 1].y);
            return;
        }
    }
}

// Fonction pour mettre à jour les boules d'énergie
void update_bullets() {
    for (UINT8 i = 0; i < MAX_BULLETS; i++) {
        if (bullets[i].active) {
            bullets[i].x += bullets[i].direction * 4;

            move_sprite(8 + i, bullets[i].x, bullets[i].y);

            // Animation entre bullet et bullet2
            bullets[i].animationCounter++;
            if (bullets[i].animationCounter > 1) {
                bullets[i].spriteIndex = bullets[i].spriteIndex == 0 ? 1 : 0;
                set_sprite_tile(8 + i, 16 + bullets[i].spriteIndex);
                bullets[i].animationCounter = 0;
            }

            // Désactiver si hors écran ou collision avec l'ennemi
            if (bullets[i].x > 160 || bullets[i].x < 0 ||
                (bullets[i].x > enemy_x - 8 && bullets[i].x < enemy_x + 8 &&
                 bullets[i].y > enemy_y - 8 && bullets[i].y < enemy_y + 8)) {
                bullets[i].active = 0;
                move_sprite(8 + i, 0, 0); // Déplace le sprite hors écran
            }
        }
    }
}

// Fonction pour déplacer et animer le sprite enemy
void update_enemy_sprite() {
    int move_x = 0;
    int move_y = 0;

    if (enemy_x < hero_x) move_x = 1;
    else if (enemy_x > hero_x) move_x = -1;

    if (enemy_y < hero_y) move_y = 1;
    else if (enemy_y > hero_y) move_y = -1;

    enemy_x += move_x * 2 * enemySpeed;
    enemy_y += move_y * 2 * enemySpeed;

    if (enemy_x > 150) enemy_x = 150;
    if (enemy_x < 10) enemy_x = 10;
    if (enemy_y > 140) enemy_y = 140;
    if (enemy_y < 10) enemy_y = 10;

    move_sprite(4, enemy_x, enemy_y);
    move_sprite(5, enemy_x + 8, enemy_y);
    move_sprite(6, enemy_x, enemy_y + 8);
    move_sprite(7, enemy_x + 8, enemy_y + 8);

    enemyAnimationCounter++;

    if (enemyAnimationCounter > 1) {
        if (enemySpriteIndex == 0) {
            set_sprite_tile(4, 8);
            set_sprite_tile(5, 9);
            set_sprite_tile(6, 10);
            set_sprite_tile(7, 11);
            enemySpriteIndex = 1;
        } else {
            set_sprite_tile(4, 12);
            set_sprite_tile(5, 13);
            set_sprite_tile(6, 14);
            set_sprite_tile(7, 15);
            enemySpriteIndex = 0;
        }
        enemyAnimationCounter = 0;
    }
}

// Fonction pour déplacer et animer le sprite du héros
void update_hero_sprite() {
    UINT8 move_x = 0;
    UINT8 move_y = 0;

    if (joypad() & J_LEFT) move_x = -8;
    if (joypad() & J_RIGHT) move_x = 8;
    if (joypad() & J_UP) move_y = -8;
    if (joypad() & J_DOWN) move_y = 8;

    hero_x += move_x;
    hero_y += move_y;

    if (hero_x > 152) hero_x = 154;
    if (hero_x < 10) hero_x = 8;
    if (hero_y > 144) hero_y = 144;
    if (hero_y < 16) hero_y = 16;

    move_sprite(0, hero_x, hero_y);
    move_sprite(1, hero_x + 8, hero_y);
    move_sprite(2, hero_x, hero_y + 8);
    move_sprite(3, hero_x + 8, hero_y + 8);

    if (heroSpriteIndex == 0) {
        set_sprite_tile(0, 0);
        set_sprite_tile(1, 1);
        set_sprite_tile(2, 2);
        set_sprite_tile(3, 3);
        heroSpriteIndex = 1;
    } else {
        set_sprite_tile(0, 4);
        set_sprite_tile(1, 5);
        set_sprite_tile(2, 6);
        set_sprite_tile(3, 7);
        heroSpriteIndex = 0;
    }
}

void main(void) {
    set_sprite_data(0, 8, hero);
    set_sprite_data(8, 8, enemy);
    set_sprite_data(16, 2, bullet);

    initialize_bullets();

    set_sprite_tile(4, 8);
    set_sprite_tile(5, 9);
    set_sprite_tile(6, 10);
    set_sprite_tile(7, 11);
    move_sprite(4, enemy_x, enemy_y);
    move_sprite(5, enemy_x + 8, enemy_y);
    move_sprite(6, enemy_x, enemy_y + 8);
    move_sprite(7, enemy_x + 8, enemy_y + 8);

    move_sprite(0, hero_x, hero_y);
    move_sprite(1, hero_x + 8, hero_y);
    move_sprite(2, hero_x, hero_y + 8);
    move_sprite(3, hero_x + 8, hero_y + 8);

    SHOW_SPRITES;

    while(1) {
        update_enemy_sprite();
        update_hero_sprite();

        if (joypad() & J_A) fire_bullets();
        update_bullets();

        delay(100);
    }
}