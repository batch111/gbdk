#include <gb/gb.h>
#include <stdio.h>
#include <rand.h>
#include "C:\gameboyGame\application\assets\sprites\hero.c"  // Première frame du premier personnage
#include "C:\gameboyGame\application\assets\sprites\hero2.c"  // Deuxième frame du premier personnage
#include "C:\gameboyGame\application\assets\sprites\enemy.c"  // Première frame du second personnage
#include "C:\gameboyGame\application\assets\sprites\enemy2.c"  // Deuxième frame du second personnage

UINT8 enemy_x = 120; // Position X initiale de l'ennemi
UINT8 enemy_y = 78;  // Position Y de l'ennemi
UINT8 enemySpriteIndex = 0; // Index pour alterner entre les frames de l'ennemi
UINT8 enemySpeed = 1;  // Vitesse de déplacement de l'ennemi (modifiable)
UINT8 enemyAnimationCounter = 0; // Compteur pour ralentir l'animation

UINT8 hero_x = 88; // Position X initiale du héros
UINT8 hero_y = 78; // Position Y initiale du héros
UINT8 heroSpriteIndex = 0; // Index pour alterner entre les frames du héros

// Fonction pour déplacer et animer le sprite enemy
void update_enemy_sprite() {
    // Calculer la direction de déplacement de l'ennemi vers le héros
    int move_x = 0;
    int move_y = 0;

    // Vérifier la position relative de l'ennemi et du héros pour ajuster le déplacement
    if (enemy_x < hero_x) {
        move_x = 1;  // Aller vers la droite
    } else if (enemy_x > hero_x) {
        move_x = -1; // Aller vers la gauche
    }

    if (enemy_y < hero_y) {
        move_y = 1;  // Aller vers le bas
    } else if (enemy_y > hero_y) {
        move_y = -1; // Aller vers le haut
    }

    // Appliquer le mouvement vers le héros
    enemy_x += move_x * 5 * enemySpeed;
    enemy_y += move_y * 5 * enemySpeed;

    // Limiter les déplacements de l'ennemi à l'écran
    if (enemy_x > 150) enemy_x = 150;
    if (enemy_x < 10) enemy_x = 10;
    if (enemy_y > 140) enemy_y = 140;
    if (enemy_y < 10) enemy_y = 10;

    // Déplace le sprite de l'ennemi
    move_sprite(4, enemy_x, enemy_y); // Sprite 4 (en haut à gauche de l'ennemi)
    move_sprite(5, enemy_x + 8, enemy_y); // Sprite 5 (en haut à droite)
    move_sprite(6, enemy_x, enemy_y + 8); // Sprite 6 (en bas à gauche)
    move_sprite(7, enemy_x + 8, enemy_y + 8); // Sprite 7 (en bas à droite)

    // Animation de l'ennemi
    enemyAnimationCounter++;  // Incrémenter le compteur d'animation

    // Limiter l'animation à une fois tous les 10 cycles (ajuste cette valeur pour ajuster la vitesse d'animation)
    if (enemyAnimationCounter > 1) {
        if (enemySpriteIndex == 0) {
            set_sprite_tile(4, 8);  // Première frame de l'ennemi
            set_sprite_tile(5, 9);
            set_sprite_tile(6, 10);
            set_sprite_tile(7, 11);
            enemySpriteIndex = 1;
        } else {
            set_sprite_tile(4, 12); // Deuxième frame de l'ennemi
            set_sprite_tile(5, 13);
            set_sprite_tile(6, 14);
            set_sprite_tile(7, 15);
            enemySpriteIndex = 0;
        }
        enemyAnimationCounter = 0; // Réinitialiser le compteur
    }
}

// Fonction pour déplacer et animer le sprite du héros
void update_hero_sprite() {
    // Réinitialiser les déplacements
    UINT8 move_x = 0;
    UINT8 move_y = 0;

    // Vérifier les entrées de l'utilisateur
    if (joypad() & J_LEFT) {
        move_x = -8;
    }
    if (joypad() & J_RIGHT) {
        move_x = 8;
    }
    if (joypad() & J_UP) {
        move_y = -8;
    }
    if (joypad() & J_DOWN) {
        move_y = 8;
    }

    // Appliquer les mouvements
    hero_x += move_x;
    hero_y += move_y;

    // Limiter le mouvement du héros à l'écran
    if (hero_x > 152) hero_x = 154; // Pour éviter de sortir à droite
    if (hero_x < 10) hero_x = 8;     // Pour éviter de sortir à gauche
    if (hero_y > 144) hero_y = 144; // Pour éviter de sortir en bas
    if (hero_y < 16) hero_y = 16;     // Pour éviter de sortir en haut

    // Déplacement du sprite du héros
    move_sprite(0, hero_x, hero_y); // Sprite 0 (en haut à gauche)
    move_sprite(1, hero_x + 8, hero_y); // Sprite 1 (en haut à droite)
    move_sprite(2, hero_x, hero_y + 8); // Sprite 2 (en bas à gauche)
    move_sprite(3, hero_x + 8, hero_y + 8); // Sprite 3 (en bas à droite)

    // Animation du héros
    if (heroSpriteIndex == 0) {
        set_sprite_tile(0, 0); // Première frame du héros
        set_sprite_tile(1, 1);
        set_sprite_tile(2, 2);
        set_sprite_tile(3, 3);
        heroSpriteIndex = 1;
    } else {
        set_sprite_tile(0, 4); // Deuxième frame du héros
        set_sprite_tile(1, 5);
        set_sprite_tile(2, 6);
        set_sprite_tile(3, 7);
        heroSpriteIndex = 0;
    }
}

void main(void) {
    // Charger les tuiles pour le personnage et l'ennemi
    set_sprite_data(0, 8, hero);  // 8 tuiles pour le premier personnage
    set_sprite_data(8, 8, enemy);  // 8 tuiles pour le second personnage

    // Associer les tuiles de l'ennemi
    set_sprite_tile(4, 8);  // Sprite 4 - Tuile 8 (en haut à gauche de l'ennemi)
    set_sprite_tile(5, 9);  // Sprite 5 - Tuile 9 (en haut à droite)
    set_sprite_tile(6, 10); // Sprite 6 - Tuile 10 (en bas à gauche)
    set_sprite_tile(7, 11); // Sprite 7 - Tuile 11 (en bas à droite)

    // Positionner l'ennemi
    move_sprite(4, enemy_x, enemy_y); // Sprite 4 (en haut à gauche de l'ennemi)
    move_sprite(5, enemy_x + 8, enemy_y); // Sprite 5 (en haut à droite)
    move_sprite(6, enemy_x, enemy_y + 8); // Sprite 6 (en bas à gauche)
    move_sprite(7, enemy_x + 8, enemy_y + 8); // Sprite 7 (en bas à droite)

    // Positionner le héros
    move_sprite(0, hero_x, hero_y); // Sprite 0 (en haut à gauche)
    move_sprite(1, hero_x + 8, hero_y); // Sprite 1 (en haut à droite)
    move_sprite(2, hero_x, hero_y + 8); // Sprite 2 (en bas à gauche)
    move_sprite(3, hero_x + 8, hero_y + 8); // Sprite 3 (en bas à droite)

    SHOW_SPRITES;

    // Boucle principale d'animation
    while(1) {
        // Appel de la fonction pour mettre à jour le sprite de l'ennemi (déplacement + animation)
        update_enemy_sprite(); // Déplace et anime l'ennemi
        
        // Appel de la fonction pour mettre à jour le sprite du héros (déplacement + animation)
        update_hero_sprite(); // Déplace et anime le héros

        delay(100); // Délai pour l'animation globale
    }
}