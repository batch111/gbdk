#include <gb/gb.h>
#include <stdio.h>
#include <rand.h>
#include <gbdk/font.h>
#include "C:\gameboyGame\application\assets\sprites\windowHeroMetric100.c"
#include "C:\gameboyGame\application\assets\sprites\windowHeroMetric75.c"
#include "C:\gameboyGame\application\assets\sprites\windowHeroMetric50.c"
#include "C:\gameboyGame\application\assets\sprites\windowHeroMetric25.c"
#include "C:\gameboyGame\application\assets\sprites\windowEnemyMetric100.c"
#include "C:\gameboyGame\application\assets\sprites\windowEnemyMetric75.c"
#include "C:\gameboyGame\application\assets\sprites\windowEnemyMetric50.c"
#include "C:\gameboyGame\application\assets\sprites\windowEnemyMetric25.c"
#include "C:\gameboyGame\application\assets\sprites\hero.c"
#include "C:\gameboyGame\application\assets\sprites\hero2.c"
#include "C:\gameboyGame\application\assets\sprites\enemy.c"
#include "C:\gameboyGame\application\assets\sprites\enemy2.c"
#include "C:\gameboyGame\application\assets\sprites\bullet.c"
#include "C:\gameboyGame\application\assets\sprites\bullet2.c"

#define MAX_BULLETS 10 // Nombre maximum de balles

// Variables pour la position et l'animation de l'ennemi
UINT8 enemy_x = 120;
UINT8 enemy_y = 78;
UINT8 enemySpriteIndex = 0;
UINT8 enemySpeed = 1;
UINT8 enemyAnimationCounter = 0;
UINT16 enemyHealth = 100; // Ajout de la vie de l'ennemi
UINT8 enemyAlive = 1; // 1 signifie que l'ennemi est vivant, 0 qu'il est vaincu

// Variable d'état de fin de jeu
UINT8 gameOver = 0; // 0 = jeu en cours, 1 = défaite, 2 = victoire

// Variables pour la position et l'animation du héros
UINT8 hero_x = 10;
UINT8 hero_y = 10;
UINT8 heroSpriteIndex = 0;

// Cooldown pour limiter les coups
UINT8 hitCooldown = 0;
const UINT8 HIT_COOLDOWN_DURATION = 5; // Durée du cooldown en frames

// État de la santé du héros et affichage
UINT8 heroHealth = 100; // Santé initiale du héros
UINT8 display_win = 1;  // Indicateur d'affichage de la fenêtre de santé

// Fonction d'interruption de l'affichage LCD pour gérer l'affichage de la fenêtre
void interruptLCD() {
    if (display_win) {
        SHOW_WIN;
    }
}

// Fonction pour redémarrer le jeu si le joueur appuie sur le bouton B
void checkRestart() {
    if (gameOver > 0) { // Si le jeu est terminé
        if (joypad() & J_B) { // Si le bouton B est pressé
            reset(); // Redémarre le jeu
        }
    }
}

// Structure de données représentant une balle
struct Bullet {
    UINT8 x;
    UINT8 y;
    INT8 directionX;
    INT8 directionY;
    UINT8 active;
    UINT8 animationCounter;
    UINT8 spriteIndex;
};

// Tableau de balles
struct Bullet bullets[MAX_BULLETS];

// Initialisation des balles
void initialize_bullets() {
    for (UINT8 i = 0; i < MAX_BULLETS; i++) {
        bullets[i].x = 0;
        bullets[i].y = 0;
        bullets[i].directionX = 0;
        bullets[i].directionY = 0;
        bullets[i].active = 0; // Inactive par défaut
        bullets[i].animationCounter = 0;
        bullets[i].spriteIndex = 0;
    }
}

// Fonction pour tirer des balles
void fire_bullets() {
    // Parcourt les balles pour en trouver des inactives
    for (UINT8 i = 0; i < MAX_BULLETS; i += 2) {
        if (!bullets[i].active && !bullets[i + 1].active) {
            bullets[i].x = hero_x;
            bullets[i].y = hero_y;
            bullets[i].directionX = -2; // Gauche
            bullets[i].directionY = -2; // Haut
            bullets[i].active = 1;

            bullets[i + 1].x = hero_x;
            bullets[i + 1].y = hero_y;
            bullets[i + 1].directionX = 2; // Droite
            bullets[i + 1].directionY = 2; // Bas
            bullets[i + 1].active = 3;

            // Assigne les tuiles des sprites pour représenter les balles
            set_sprite_tile(8 + i, 16);
            set_sprite_tile(8 + i + 1, 17);

            // Positionne les sprites des balles à l'écran
            move_sprite(8 + i, bullets[i].x, bullets[i].y);
            move_sprite(8 + i + 1, bullets[i + 1].x, bullets[i + 1].y);
            return;
        }
    }
}

// Mise à jour des positions des balles
void update_bullets() {
    for (UINT8 i = 0; i < MAX_BULLETS; i++) {
        if (bullets[i].active) {
            // Met à jour les positions des balles selon leur direction
            bullets[i].x += bullets[i].directionX * 4;
            bullets[i].y += bullets[i].directionY * 4;
            move_sprite(8 + i, bullets[i].x, bullets[i].y);

            // Gère l'animation des balles
            bullets[i].animationCounter++;
            if (bullets[i].animationCounter > 1) {
                bullets[i].spriteIndex = bullets[i].spriteIndex == 0 ? 1 : 0;
                set_sprite_tile(8 + i, 16 + bullets[i].spriteIndex);
                bullets[i].animationCounter = 0;
            }

            // Vérifie si la balle touche l'ennemi
            if (enemyAlive && bullets[i].x > enemy_x - 8 && bullets[i].x < enemy_x + 8 &&
                bullets[i].y > enemy_y - 8 && bullets[i].y < enemy_y + 8) {
                bullets[i].active = 0; // Désactive la balle
                move_sprite(8 + i, 0, 0); // Retire la balle de l'écran

                // Réduit les points de vie de l'ennemi
                if (enemyHealth > 0) { // Permet une mise à jour même à 0 de vie
                    enemyHealth = enemyHealth > 25 ? enemyHealth - 25 : 0;
                    update_health_display_enemy();
                }

                if (enemyHealth == 0) { // L'ennemi est mort
                    enemyAlive = 0; // Marque l'ennemi comme vaincu

                    // Désactive les sprites de l'ennemi
                    move_sprite(4, 0, 0);
                    move_sprite(5, 0, 0);
                    move_sprite(6, 0, 0);
                    move_sprite(7, 0, 0);

                    // Affiche le message de victoire
                    printf("Victory ! press B for restart");
                    display_win = 0;
                    gameOver = 2; // Définit l'état du jeu comme victoire
                }
            }

            // Désactive la balle si elle sort de l'écran
            if (bullets[i].x > 160 || bullets[i].x < 0 ||
                bullets[i].y > 160 || bullets[i].y < 0) {
                bullets[i].active = 0;
                move_sprite(8 + i, 0, 0); // Retire la balle de l'écran
            }
        }
    }
}

// Mise à jour du mouvement et de l'animation de l'ennemi
void update_enemy_sprite() {
    int move_x = 0;
    int move_y = 0;

    // Calcule le mouvement de l'ennemi vers le héros
    if (enemy_x < hero_x) move_x = 1;
    else if (enemy_x > hero_x) move_x = -1;
    if (enemy_y < hero_y) move_y = 1;
    else if (enemy_y > hero_y) move_y = -1;

    // Mise à jour des coordonnées de l'ennemi
    enemy_x += move_x * 4 * enemySpeed;
    enemy_y += move_y * 4 * enemySpeed;

    // Positionne les sprites de l'ennemi à l'écran
    move_sprite(4, enemy_x, enemy_y);
    move_sprite(5, enemy_x + 8, enemy_y);
    move_sprite(6, enemy_x, enemy_y + 8);
    move_sprite(7, enemy_x + 8, enemy_y + 8);

    // Gère l'animation de l'ennemi
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

// Met à jour l'affichage de la santé du héros
void update_health_display_hero() {
    UINT8 emptyLine[5] = {0x00, 0x00, 0x00, 0x00, 0x00};
    set_win_tiles(0, 0, 5, 1, emptyLine);

    switch (heroHealth) {
        case 100:
            set_win_tiles(0, 0, 5, 1, windowHeroMetric100);
            break;
        case 75:
            set_win_tiles(0, 0, 4, 1, windowHeroMetric75);
            break;
        case 50:
            set_win_tiles(0, 0, 4, 1, windowHeroMetric50);
            break;
        case 25:
            set_win_tiles(0, 0, 4, 1, windowHeroMetric25);
            break;
    }
}

// Fonction pour mettre à jour l'affichage de la santé de l'ennemi
void update_health_display_enemy() {
    UINT8 emptyLine[5] = {0x00, 0x00, 0x00, 0x00, 0x00};

    // Efface les anciennes tuiles
    set_win_tiles(15, 0, 5, 1, emptyLine);

    // Affiche la nouvelle santé selon l'état actuel d'enemyHealth
    switch (enemyHealth) {
        case 100:
            set_win_tiles(15, 0, 5, 1, windowEnemyMetric100);
            break;
        case 75:
            set_win_tiles(15, 0, 4, 1, windowEnemyMetric75);
            break;
        case 50:
            set_win_tiles(15, 0, 4, 1, windowEnemyMetric50);
            break;
        case 25:
            set_win_tiles(15, 0, 4, 1, windowEnemyMetric25);
            break;
    }
}

// Gestion des collisions du héros
void handle_hero_collision() {
    if (hitCooldown > 0) {
        hitCooldown--;
        return;
    }

    // Détection de collision avec l'ennemi
    if (enemy_x > hero_x - 10 && enemy_x < hero_x + 10 &&
        enemy_y > hero_y - 10 && enemy_y < hero_y + 10) {
        heroHealth -= 25;
        update_health_display_hero();
        hitCooldown = HIT_COOLDOWN_DURATION;

        if (heroHealth == 0) {
            printf("Game Over press B for restart");
            display_win = 0;
            gameOver = 1; // Définit l'état du jeu comme défaite
        }
    }
}

// Mouvement et animation du héros
void update_hero_sprite() {
    INT8 move_x = 0;
    INT8 move_y = 0;

    // Vérifier les entrées de la manette pour déterminer le mouvement
    if (joypad() & J_LEFT) move_x = -8;
    if (joypad() & J_RIGHT) move_x = 8;
    if (joypad() & J_UP) move_y = -8;
    if (joypad() & J_DOWN) move_y = 8;

    // Limite la position du héros pour qu'il ne dépasse pas les bords de l'écran
    // Les coordonnées maximales de la Game Boy avec un sprite 8x8 sont 152 pour x et 136 pour y
    if ((hero_x + move_x) >= 8 && (hero_x + move_x) <= 160) {
        hero_x += move_x;
    }
    if ((hero_y + move_y) >= 12 && (hero_y + move_y) <= 136) {
        hero_y += move_y;
    }

    // Déplacer le héros à sa nouvelle position
    move_sprite(0, hero_x, hero_y);
    move_sprite(1, hero_x + 8, hero_y);
    move_sprite(2, hero_x, hero_y + 8);
    move_sprite(3, hero_x + 8, hero_y + 8);

    // Gère l'alternance entre les sprites pour animer le héros
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

// Fonction principale du jeu
void main(void) {
    font_t min_font;
    STAT_REG = 0x45;
    LYC_REG = 0x08;
    disable_interrupts();
    font_init();
    min_font = font_load(font_min);
    font_set(min_font);

    // Affiche la santé du héros en bas à gauche
    set_win_tiles(0, 0, 5, 1, windowHeroMetric100); // Tuiles pour le héros
    // Affiche la santé de l'ennemi en bas à droite
    set_win_tiles(15, 0, 5, 1, windowEnemyMetric100); // Tuiles pour l'ennemi

    move_win(7, 130); // Positionne la fenêtre en bas de l'écran
    SHOW_WIN;
    DISPLAY_ON;

    add_LCD(interruptLCD);
    enable_interrupts();
    set_interrupts(VBL_IFLAG | LCD_IFLAG);

    set_sprite_data(0, 8, hero);
    set_sprite_data(8, 8, enemy);
    set_sprite_data(16, 2, bullet);

    initialize_bullets();

    // Position initiale des sprites de l'ennemi et du héros
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

    // Boucle principale du jeu
    while (1) {
        if (gameOver == 0) { // Si le jeu est en cours
            update_enemy_sprite();
            update_hero_sprite();
            if (joypad() & J_A) fire_bullets();
            update_bullets();
            handle_hero_collision();
            delay(150);
        } else {
            checkRestart(); // Vérifie si le joueur veut redémarrer
        }
    }
}