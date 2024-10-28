;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler 
; Version 4.4.1 #14650 (MINGW64)
;--------------------------------------------------------
	.module main
	.optsdcc -msm83
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _update_hero_sprite
	.globl _update_enemy_sprite
	.globl _set_sprite_data
	.globl _joypad
	.globl _delay
	.globl _heroSpriteIndex
	.globl _hero_y
	.globl _hero_x
	.globl _enemyAnimationCounter
	.globl _enemySpeed
	.globl _enemySpriteIndex
	.globl _enemy_y
	.globl _enemy_x
	.globl _enemy2
	.globl _enemy
	.globl _hero2
	.globl _hero
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_hero::
	.ds 64
_hero2::
	.ds 64
_enemy::
	.ds 64
_enemy2::
	.ds 64
_enemy_x::
	.ds 1
_enemy_y::
	.ds 1
_enemySpriteIndex::
	.ds 1
_enemySpeed::
	.ds 1
_enemyAnimationCounter::
	.ds 1
_hero_x::
	.ds 1
_hero_y::
	.ds 1
_heroSpriteIndex::
	.ds 1
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;main.c:20: void update_enemy_sprite() {
;	---------------------------------
; Function update_enemy_sprite
; ---------------------------------
_update_enemy_sprite::
;main.c:22: int move_x = 0;
;main.c:23: int move_y = 0;
	ld	bc, #0x0
;main.c:26: if (enemy_x < hero_x) {
	ld	a, (#_enemy_x)
	ld	hl, #_hero_x
	sub	a, (hl)
	jr	NC, 00104$
;main.c:27: move_x = 1;  // Aller vers la droite
	ld	c, #0x01
	jr	00105$
00104$:
;main.c:28: } else if (enemy_x > hero_x) {
	ld	a, (#_hero_x)
	ld	hl, #_enemy_x
	sub	a, (hl)
	jr	NC, 00105$
;main.c:29: move_x = -1; // Aller vers la gauche
	ld	c, #0xff
00105$:
;main.c:32: if (enemy_y < hero_y) {
	ld	a, (#_enemy_y)
	ld	hl, #_hero_y
	sub	a, (hl)
	jr	NC, 00109$
;main.c:33: move_y = 1;  // Aller vers le bas
	ld	b, #0x01
	jr	00110$
00109$:
;main.c:34: } else if (enemy_y > hero_y) {
	ld	a, (#_hero_y)
	ld	hl, #_enemy_y
	sub	a, (hl)
	jr	NC, 00110$
;main.c:35: move_y = -1; // Aller vers le haut
	ld	b, #0xff
00110$:
;main.c:39: enemy_x += move_x * 5 * enemySpeed;
	ld	a, c
	add	a, a
	add	a, a
	add	a, c
	ld	c, a
	push	bc
	ld	hl, #_enemySpeed
	ld	e, (hl)
	ld	a, c
	call	__muluschar
	ld	a, c
	pop	bc
	ld	hl, #_enemy_x
	ld	c, (hl)
	add	a, c
	ld	(hl), a
;main.c:40: enemy_y += move_y * 5 * enemySpeed;
	ld	a, b
	ld	c, a
	add	a, a
	add	a, a
	add	a, c
	ld	c, a
	ld	hl, #_enemySpeed
	ld	e, (hl)
	ld	a, c
	call	__muluschar
	ld	hl, #_enemy_y
	ld	a, (hl)
	add	a, c
	ld	(hl), a
;main.c:43: if (enemy_x > 150) enemy_x = 150;
	ld	a, #0x96
	ld	hl, #_enemy_x
	sub	a, (hl)
	jr	NC, 00112$
	ld	(hl), #0x96
00112$:
;main.c:44: if (enemy_x < 10) enemy_x = 10;
	ld	hl, #_enemy_x
	ld	a, (hl)
	sub	a, #0x0a
	jr	NC, 00114$
	ld	(hl), #0x0a
00114$:
;main.c:45: if (enemy_y > 140) enemy_y = 140;
	ld	a, #0x8c
	ld	hl, #_enemy_y
	sub	a, (hl)
	jr	NC, 00116$
	ld	(hl), #0x8c
00116$:
;main.c:46: if (enemy_y < 10) enemy_y = 10;
	ld	hl, #_enemy_y
	ld	a, (hl)
	sub	a, #0x0a
	jr	NC, 00118$
	ld	(hl), #0x0a
00118$:
;main.c:49: move_sprite(4, enemy_x, enemy_y); // Sprite 4 (en haut à gauche de l'ennemi)
	ld	hl, #_enemy_y
	ld	b, (hl)
	ld	hl, #_enemy_x
	ld	c, (hl)
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 16)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;main.c:50: move_sprite(5, enemy_x + 8, enemy_y); // Sprite 5 (en haut à droite)
	ld	hl, #_enemy_y
	ld	b, (hl)
	ld	a, (#_enemy_x)
	add	a, #0x08
	ld	c, a
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 20)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;main.c:51: move_sprite(6, enemy_x, enemy_y + 8); // Sprite 6 (en bas à gauche)
	ld	a, (#_enemy_y)
	add	a, #0x08
	ld	b, a
	ld	hl, #_enemy_x
	ld	c, (hl)
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 24)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;main.c:52: move_sprite(7, enemy_x + 8, enemy_y + 8); // Sprite 7 (en bas à droite)
	ld	a, (#_enemy_y)
	add	a, #0x08
	ld	b, a
	ld	a, (#_enemy_x)
	add	a, #0x08
	ld	c, a
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 28)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;main.c:55: enemyAnimationCounter++;  // Incrémenter le compteur d'animation
	ld	hl, #_enemyAnimationCounter
	inc	(hl)
;main.c:58: if (enemyAnimationCounter > 1) {
	ld	a, #0x01
	sub	a, (hl)
	ret	NC
;main.c:59: if (enemySpriteIndex == 0) {
	ld	a, (#_enemySpriteIndex)
	or	a, a
	jr	NZ, 00120$
;c:\gbdk\include\gb\gb.h:1875: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 18)
	ld	(hl), #0x08
	ld	hl, #(_shadow_OAM + 22)
	ld	(hl), #0x09
	ld	hl, #(_shadow_OAM + 26)
	ld	(hl), #0x0a
	ld	hl, #(_shadow_OAM + 30)
	ld	(hl), #0x0b
;main.c:64: enemySpriteIndex = 1;
	ld	hl, #_enemySpriteIndex
	ld	(hl), #0x01
	jr	00121$
00120$:
;c:\gbdk\include\gb\gb.h:1875: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 18)
	ld	(hl), #0x0c
	ld	hl, #(_shadow_OAM + 22)
	ld	(hl), #0x0d
	ld	hl, #(_shadow_OAM + 26)
	ld	(hl), #0x0e
	ld	hl, #(_shadow_OAM + 30)
	ld	(hl), #0x0f
;main.c:70: enemySpriteIndex = 0;
	ld	hl, #_enemySpriteIndex
	ld	(hl), #0x00
00121$:
;main.c:72: enemyAnimationCounter = 0; // Réinitialiser le compteur
	ld	hl, #_enemyAnimationCounter
	ld	(hl), #0x00
;main.c:74: }
	ret
;main.c:77: void update_hero_sprite() {
;	---------------------------------
; Function update_hero_sprite
; ---------------------------------
_update_hero_sprite::
;main.c:79: UINT8 move_x = 0;
;main.c:80: UINT8 move_y = 0;
	ld	bc, #0x0
;main.c:83: if (joypad() & J_LEFT) {
	call	_joypad
	bit	1, a
	jr	Z, 00102$
;main.c:84: move_x = -8;
	ld	b, #0xf8
00102$:
;main.c:86: if (joypad() & J_RIGHT) {
	call	_joypad
	rrca
	jr	NC, 00104$
;main.c:87: move_x = 8;
	ld	b, #0x08
00104$:
;main.c:89: if (joypad() & J_UP) {
	call	_joypad
	bit	2, a
	jr	Z, 00106$
;main.c:90: move_y = -8;
	ld	c, #0xf8
00106$:
;main.c:92: if (joypad() & J_DOWN) {
	call	_joypad
	bit	3, a
	jr	Z, 00108$
;main.c:93: move_y = 8;
	ld	c, #0x08
00108$:
;main.c:97: hero_x += move_x;
	ld	hl, #_hero_x
	ld	a, (hl)
	add	a, b
	ld	(hl), a
;main.c:98: hero_y += move_y;
	ld	hl, #_hero_y
	ld	a, (hl)
	add	a, c
	ld	(hl), a
;main.c:101: if (hero_x > 152) hero_x = 154; // Pour éviter de sortir à droite
	ld	a, #0x98
	ld	hl, #_hero_x
	sub	a, (hl)
	jr	NC, 00110$
	ld	(hl), #0x9a
00110$:
;main.c:102: if (hero_x < 10) hero_x = 8;     // Pour éviter de sortir à gauche
	ld	hl, #_hero_x
	ld	a, (hl)
	sub	a, #0x0a
	jr	NC, 00112$
	ld	(hl), #0x08
00112$:
;main.c:103: if (hero_y > 144) hero_y = 144; // Pour éviter de sortir en bas
	ld	a, #0x90
	ld	hl, #_hero_y
	sub	a, (hl)
	jr	NC, 00114$
	ld	(hl), #0x90
00114$:
;main.c:104: if (hero_y < 16) hero_y = 16;     // Pour éviter de sortir en haut
	ld	hl, #_hero_y
	ld	a, (hl)
	sub	a, #0x10
	jr	NC, 00116$
	ld	(hl), #0x10
00116$:
;main.c:107: move_sprite(0, hero_x, hero_y); // Sprite 0 (en haut à gauche)
	ld	hl, #_hero_y
	ld	b, (hl)
	ld	hl, #_hero_x
	ld	c, (hl)
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #_shadow_OAM
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;main.c:108: move_sprite(1, hero_x + 8, hero_y); // Sprite 1 (en haut à droite)
	ld	hl, #_hero_y
	ld	b, (hl)
	ld	a, (#_hero_x)
	add	a, #0x08
	ld	c, a
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 4)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;main.c:109: move_sprite(2, hero_x, hero_y + 8); // Sprite 2 (en bas à gauche)
	ld	a, (#_hero_y)
	add	a, #0x08
	ld	b, a
	ld	hl, #_hero_x
	ld	c, (hl)
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 8)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;main.c:110: move_sprite(3, hero_x + 8, hero_y + 8); // Sprite 3 (en bas à droite)
	ld	a, (#_hero_y)
	add	a, #0x08
	ld	b, a
	ld	a, (#_hero_x)
	add	a, #0x08
	ld	c, a
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 12)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;main.c:113: if (heroSpriteIndex == 0) {
	ld	a, (#_heroSpriteIndex)
	or	a, a
	jr	NZ, 00118$
;c:\gbdk\include\gb\gb.h:1875: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 2)
	ld	(hl), #0x00
	ld	hl, #(_shadow_OAM + 6)
	ld	(hl), #0x01
	ld	hl, #(_shadow_OAM + 10)
	ld	(hl), #0x02
	ld	hl, #(_shadow_OAM + 14)
	ld	(hl), #0x03
;main.c:118: heroSpriteIndex = 1;
	ld	hl, #_heroSpriteIndex
	ld	(hl), #0x01
	ret
00118$:
;c:\gbdk\include\gb\gb.h:1875: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 2)
	ld	(hl), #0x04
	ld	hl, #(_shadow_OAM + 6)
	ld	(hl), #0x05
	ld	hl, #(_shadow_OAM + 10)
	ld	(hl), #0x06
	ld	hl, #(_shadow_OAM + 14)
	ld	(hl), #0x07
;main.c:124: heroSpriteIndex = 0;
	ld	hl, #_heroSpriteIndex
	ld	(hl), #0x00
;main.c:126: }
	ret
;main.c:128: void main(void) {
;	---------------------------------
; Function main
; ---------------------------------
_main::
;main.c:130: set_sprite_data(0, 8, hero);  // 8 tuiles pour le premier personnage
	ld	de, #_hero
	push	de
	ld	hl, #0x800
	push	hl
	call	_set_sprite_data
	add	sp, #4
;main.c:131: set_sprite_data(8, 8, enemy);  // 8 tuiles pour le second personnage
	ld	de, #_enemy
	push	de
	ld	a, #0x08
	push	af
	inc	sp
	ld	a, #0x08
	push	af
	inc	sp
	call	_set_sprite_data
	add	sp, #4
;c:\gbdk\include\gb\gb.h:1875: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 18)
	ld	(hl), #0x08
	ld	hl, #(_shadow_OAM + 22)
	ld	(hl), #0x09
	ld	hl, #(_shadow_OAM + 26)
	ld	(hl), #0x0a
	ld	hl, #(_shadow_OAM + 30)
	ld	(hl), #0x0b
;main.c:140: move_sprite(4, enemy_x, enemy_y); // Sprite 4 (en haut à gauche de l'ennemi)
	ld	hl, #_enemy_y
	ld	b, (hl)
	ld	hl, #_enemy_x
	ld	c, (hl)
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 16)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;main.c:141: move_sprite(5, enemy_x + 8, enemy_y); // Sprite 5 (en haut à droite)
	ld	hl, #_enemy_y
	ld	b, (hl)
	ld	a, (#_enemy_x)
	add	a, #0x08
	ld	c, a
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 20)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;main.c:142: move_sprite(6, enemy_x, enemy_y + 8); // Sprite 6 (en bas à gauche)
	ld	a, (#_enemy_y)
	add	a, #0x08
	ld	b, a
	ld	hl, #_enemy_x
	ld	c, (hl)
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 24)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;main.c:143: move_sprite(7, enemy_x + 8, enemy_y + 8); // Sprite 7 (en bas à droite)
	ld	a, (#_enemy_y)
	add	a, #0x08
	ld	b, a
	ld	a, (#_enemy_x)
	add	a, #0x08
	ld	c, a
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 28)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;main.c:146: move_sprite(0, hero_x, hero_y); // Sprite 0 (en haut à gauche)
	ld	hl, #_hero_y
	ld	b, (hl)
	ld	hl, #_hero_x
	ld	c, (hl)
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #_shadow_OAM
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;main.c:147: move_sprite(1, hero_x + 8, hero_y); // Sprite 1 (en haut à droite)
	ld	hl, #_hero_y
	ld	b, (hl)
	ld	a, (#_hero_x)
	add	a, #0x08
	ld	c, a
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 4)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;main.c:148: move_sprite(2, hero_x, hero_y + 8); // Sprite 2 (en bas à gauche)
	ld	a, (#_hero_y)
	add	a, #0x08
	ld	b, a
	ld	hl, #_hero_x
	ld	c, (hl)
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 8)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;main.c:149: move_sprite(3, hero_x + 8, hero_y + 8); // Sprite 3 (en bas à droite)
	ld	a, (#_hero_y)
	add	a, #0x08
	ld	b, a
	ld	a, (#_hero_x)
	add	a, #0x08
	ld	c, a
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 12)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;main.c:151: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;main.c:154: while(1) {
00102$:
;main.c:156: update_enemy_sprite(); // Déplace et anime l'ennemi
	call	_update_enemy_sprite
;main.c:159: update_hero_sprite(); // Déplace et anime le héros
	call	_update_hero_sprite
;main.c:161: delay(100); // Délai pour l'animation globale
	ld	de, #0x0064
	call	_delay
;main.c:163: }
	jr	00102$
	.area _CODE
	.area _INITIALIZER
__xinit__hero:
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x0c	; 12
	.db #0x0c	; 12
	.db #0x0b	; 11
	.db #0x0f	; 15
	.db #0x08	; 8
	.db #0x0f	; 15
	.db #0x16	; 22
	.db #0x1f	; 31
	.db #0x14	; 20
	.db #0x1f	; 31
	.db #0x16	; 22
	.db #0x1f	; 31
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0xe8	; 232
	.db #0xf8	; 248
	.db #0x08	; 8
	.db #0xf8	; 248
	.db #0x34	; 52	'4'
	.db #0xfc	; 252
	.db #0x24	; 36
	.db #0xfc	; 252
	.db #0xb4	; 180
	.db #0xfc	; 252
	.db #0x04	; 4
	.db #0x04	; 4
	.db #0x1e	; 30
	.db #0x1e	; 30
	.db #0xd7	; 215
	.db #0xd7	; 215
	.db #0xae	; 174
	.db #0xbe	; 190
	.db #0x92	; 146
	.db #0xbe	; 190
	.db #0x92	; 146
	.db #0xbe	; 190
	.db #0x4f	; 79	'O'
	.db #0x7f	; 127
	.db #0x29	; 41
	.db #0x3f	; 63
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0xbc	; 188
	.db #0xbc	; 188
	.db #0x70	; 112	'p'
	.db #0x70	; 112	'p'
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x24	; 36
	.db #0x3c	; 60
	.db #0x24	; 36
	.db #0x3c	; 60
	.db #0x78	; 120	'x'
	.db #0x78	; 120	'x'
	.db #0xc8	; 200
	.db #0xf8	; 248
	.db #0xf8	; 248
	.db #0xf8	; 248
__xinit__hero2:
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x0c	; 12
	.db #0x0c	; 12
	.db #0x0b	; 11
	.db #0x0f	; 15
	.db #0x08	; 8
	.db #0x0f	; 15
	.db #0x16	; 22
	.db #0x1f	; 31
	.db #0x14	; 20
	.db #0x1f	; 31
	.db #0x16	; 22
	.db #0x1f	; 31
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0xe8	; 232
	.db #0xf8	; 248
	.db #0x08	; 8
	.db #0xf8	; 248
	.db #0x34	; 52	'4'
	.db #0xfc	; 252
	.db #0x24	; 36
	.db #0xfc	; 252
	.db #0xb4	; 180
	.db #0xfc	; 252
	.db #0x04	; 4
	.db #0x04	; 4
	.db #0x1e	; 30
	.db #0x1e	; 30
	.db #0x2f	; 47
	.db #0x2f	; 47
	.db #0x4e	; 78	'N'
	.db #0x4e	; 78	'N'
	.db #0x52	; 82	'R'
	.db #0x7e	; 126
	.db #0x52	; 82	'R'
	.db #0x7e	; 126
	.db #0x4f	; 79	'O'
	.db #0x7f	; 127
	.db #0x29	; 41
	.db #0x3f	; 63
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0xbc	; 188
	.db #0xbc	; 188
	.db #0x70	; 112	'p'
	.db #0x70	; 112	'p'
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x24	; 36
	.db #0x3c	; 60
	.db #0x24	; 36
	.db #0x3c	; 60
	.db #0x78	; 120	'x'
	.db #0x78	; 120	'x'
	.db #0xc8	; 200
	.db #0xf8	; 248
	.db #0xf8	; 248
	.db #0xf8	; 248
__xinit__enemy:
	.db #0x1e	; 30
	.db #0x1e	; 30
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xcf	; 207
	.db #0xff	; 255
	.db #0xcc	; 204
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xf3	; 243
	.db #0xff	; 255
	.db #0xf3	; 243
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x9f	; 159
	.db #0x9f	; 159
	.db #0x9e	; 158
	.db #0x9e	; 158
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0x12	; 18
	.db #0x12	; 18
	.db #0x12	; 18
	.db #0x12	; 18
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
__xinit__enemy2:
	.db #0x1e	; 30
	.db #0x1e	; 30
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0xc9	; 201
	.db #0xc9	; 201
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0xc8	; 200
	.db #0xc8	; 200
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xe1	; 225
	.db #0xe1	; 225
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x9f	; 159
	.db #0x9f	; 159
	.db #0x9e	; 158
	.db #0x9e	; 158
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0x12	; 18
	.db #0x12	; 18
	.db #0x12	; 18
	.db #0x12	; 18
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
__xinit__enemy_x:
	.db #0x78	; 120	'x'
__xinit__enemy_y:
	.db #0x4e	; 78	'N'
__xinit__enemySpriteIndex:
	.db #0x00	; 0
__xinit__enemySpeed:
	.db #0x01	; 1
__xinit__enemyAnimationCounter:
	.db #0x00	; 0
__xinit__hero_x:
	.db #0x58	; 88	'X'
__xinit__hero_y:
	.db #0x4e	; 78	'N'
__xinit__heroSpriteIndex:
	.db #0x00	; 0
	.area _CABS (ABS)
