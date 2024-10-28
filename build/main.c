#include <gb/gb.h>
#include <stdio.h>
#include <rand.h>
#include <gbdk/font.h>
#include "C:\gameboyGame\application\assets\sprites\windowHeroMetric100.c"
#include "C:\gameboyGame\application\assets\sprites\windowHeroMetric75.c"
#include "C:\gameboyGame\application\assets\sprites\windowHeroMetric50.c"
#include "C:\gameboyGame\application\assets\sprites\windowHeroMetric25.c"
#include "C:\gameboyGame\application\assets\sprites\hero.c"
#include "C:\gameboyGame\application\assets\sprites\hero2.c"
#include "C:\gameboyGame\application\assets\sprites\enemy.c"
#include "C:\gameboyGame\application\assets\sprites\enemy2.c"
#include "C:\gameboyGame\application\assets\sprites\bullet.c"
#include "C:\gameboyGame\application\assets\sprites\bullet2.c"

#define MAX_BULLETS 10 // Maximum energy bullets

UINT8 enemy_x = 120;
UINT8 enemy_y = 78;
UINT8 enemySpriteIndex = 0;
UINT8 enemySpeed = 1;
UINT8 enemyAnimationCounter = 0;

UINT8 hero_x = 10;
UINT8 hero_y = 10;
UINT8 heroSpriteIndex = 0;

// Health states
UINT8 heroHealth = 100; // Health starts at 100%
UINT8 display_win = 1;  // 1 to show window, 0 to hide

void interruptLCD() {
    if (display_win) {
        SHOW_WIN;
    }
}

// Bullet structure
struct Bullet {
    UINT8 x;
    UINT8 y;
    INT8 directionX;
    INT8 directionY;
    UINT8 active;
    UINT8 animationCounter;
    UINT8 spriteIndex;
};

struct Bullet bullets[MAX_BULLETS];

void initialize_bullets() {
    for (UINT8 i = 0; i < MAX_BULLETS; i++) {
        bullets[i].x = 0;
        bullets[i].y = 0;
        bullets[i].directionX = 0;
        bullets[i].directionY = 0;
        bullets[i].active = 0;
        bullets[i].animationCounter = 0;
        bullets[i].spriteIndex = 0;
    }
}

// Fire bullets
void fire_bullets() {
    for (UINT8 i = 0; i < MAX_BULLETS; i += 2) {
        if (!bullets[i].active && !bullets[i + 1].active) {
            bullets[i].x = hero_x;
            bullets[i].y = hero_y;
            bullets[i].directionX = -1;
            bullets[i].directionY = -1;
            bullets[i].active = 1;

            bullets[i + 1].x = hero_x;
            bullets[i + 1].y = hero_y;
            bullets[i + 1].directionX = 1;
            bullets[i + 1].directionY = 1;
            bullets[i + 1].active = 1;

            set_sprite_tile(8 + i, 16);
            set_sprite_tile(8 + i + 1, 17);

            move_sprite(8 + i, bullets[i].x, bullets[i].y);
            move_sprite(8 + i + 1, bullets[i + 1].x, bullets[i + 1].y);
            return;
        }
    }
}

// Update bullet positions
void update_bullets() {
    for (UINT8 i = 0; i < MAX_BULLETS; i++) {
        if (bullets[i].active) {
            bullets[i].x += bullets[i].directionX * 4;
            bullets[i].y += bullets[i].directionY * 4;
            move_sprite(8 + i, bullets[i].x, bullets[i].y);

            bullets[i].animationCounter++;
            if (bullets[i].animationCounter > 1) {
                bullets[i].spriteIndex = bullets[i].spriteIndex == 0 ? 1 : 0;
                set_sprite_tile(8 + i, 16 + bullets[i].spriteIndex);
                bullets[i].animationCounter = 0;
            }

            if (bullets[i].x > 160 || bullets[i].x < 0 ||
                bullets[i].y > 160 || bullets[i].y < 0 ||
                (bullets[i].x > enemy_x - 8 && bullets[i].x < enemy_x + 8 &&
                 bullets[i].y > enemy_y - 8 && bullets[i].y < enemy_y + 8)) {
                bullets[i].active = 0;
                move_sprite(8 + i, 0, 0);
            }
        }
    }
}

// Update enemy movement and animation
void update_enemy_sprite() {
    int move_x = 0;
    int move_y = 0;

    if (enemy_x < hero_x) move_x = 1;
    else if (enemy_x > hero_x) move_x = -1;
    if (enemy_y < hero_y) move_y = 1;
    else if (enemy_y > hero_y) move_y = -1;

    enemy_x += move_x * 4 * enemySpeed;
    enemy_y += move_y * 4 * enemySpeed;

    move_sprite(4, enemy_x, enemy_y);
    move_sprite(5, enemy_x + 8, enemy_y);
    move_sprite(6, enemy_x, enemy_y + 8);
    move_sprite(7, enemy_x + 8, enemy_y + 8);

    enemyAnimationCounter++;
    if (enemyAnimationCounter > 1) {
        enemySpriteIndex = 1 - enemySpriteIndex;
        set_sprite_tile(4, enemySpriteIndex ? 8 : 12);
        set_sprite_tile(5, enemySpriteIndex ? 9 : 13);
        set_sprite_tile(6, enemySpriteIndex ? 10 : 14);
        set_sprite_tile(7, enemySpriteIndex ? 11 : 15);
        enemyAnimationCounter = 0;
    }
}

// Met à jour la fenêtre en fonction de la santé du héros
// Met à jour la fenêtre en fonction de la santé du héros
void update_health_display() {
    // Efface toutes les tuiles de la ligne de la fenêtre avant de mettre à jour l'affichage
    UINT8 emptyLine[5] = {0x00, 0x00, 0x00, 0x00, 0x00};  // Ligne de tuiles vides
    set_win_tiles(0, 0, 5, 1, emptyLine);  // Efface la ligne en plaçant 5 tuiles vides

    switch (heroHealth) {
        case 100:
            // Affiche "PV 100" avec 5 tuiles
            set_win_tiles(0, 0, 5, 1, windowHeroMetric100);
            break;
        case 75:
            // Affiche "PV 75" avec 4 tuiles
            set_win_tiles(0, 0, 4, 1, windowHeroMetric75);
            break;
        case 50:
            // Affiche "PV 50" avec 4 tuiles
            set_win_tiles(0, 0, 4, 1, windowHeroMetric50);
            break;
        case 25:
            // Affiche "PV 25" avec 4 tuiles
            set_win_tiles(0, 0, 4, 1, windowHeroMetric25);
            break;
    }
}

// Handle hero health and collisions
void handle_hero_collision() {
    if (enemy_x > hero_x - 16 && enemy_x < hero_x + 16 &&
        enemy_y > hero_y - 16 && enemy_y < hero_y + 16) {
        heroHealth -= 25;
        update_health_display();

        if (heroHealth == 0) {
            printf("Game Over");
            display_win = 0;  // Hide window on game over
            while (1); // Halt game
        }
    }
}

// Hero movement and animation
void update_hero_sprite() {
    UINT8 move_x = 0;
    UINT8 move_y = 0;

    if (joypad() & J_LEFT) move_x = -8;
    if (joypad() & J_RIGHT) move_x = 8;
    if (joypad() & J_UP) move_y = -8;
    if (joypad() & J_DOWN) move_y = 8;

    hero_x += move_x;
    hero_y += move_y;

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
    font_t min_font;
    STAT_REG = 0x45;
    LYC_REG = 0x08;
    disable_interrupts();
    font_init();
    min_font = font_load(font_min);
    font_set(min_font);

    set_win_tiles(0, 0, 5, 1, windowHeroMetric100);
    move_win(7, 130);
    SHOW_WIN;
    DISPLAY_ON;

    add_LCD(interruptLCD);
    enable_interrupts();
    set_interrupts(VBL_IFLAG | LCD_IFLAG);

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

    while (1) {
        update_enemy_sprite();
        update_hero_sprite();
        if (joypad() & J_A) fire_bullets();
        update_bullets();
        handle_hero_collision();
        delay(100);
    }
}