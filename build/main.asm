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
	.globl _update_bullets
	.globl _fire_bullets
	.globl _initialize_bullets
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
	.globl _bullet2
	.globl _bullet
	.globl _enemy2
	.globl _enemy
	.globl _hero2
	.globl _hero
	.globl _bullets
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_bullets::
	.ds 70
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
_bullet::
	.ds 16
_bullet2::
	.ds 16
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
;main.c:37: void initialize_bullets() {
;	---------------------------------
; Function initialize_bullets
; ---------------------------------
_initialize_bullets::
;main.c:38: for (UINT8 i = 0; i < MAX_BULLETS; i++) {
	ld	c, #0x00
00103$:
	ld	a, c
	sub	a, #0x0a
	ret	NC
;main.c:39: bullets[i].x = 0;
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	ld	a, l
	add	a, #<(_bullets)
	ld	e, a
	ld	a, h
	adc	a, #>(_bullets)
	ld	d, a
	xor	a, a
	ld	(de), a
;main.c:40: bullets[i].y = 0;
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, d
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	ld	(hl), #0x00
;main.c:41: bullets[i].directionX = 0; // Initialiser à 0
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, d
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	ld	(hl), #0x00
;main.c:42: bullets[i].directionY = 0; // Initialiser à 0
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, d
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	inc	hl
	ld	(hl), #0x00
;main.c:43: bullets[i].active = 0;
	ld	hl, #0x0004
	add	hl, de
	ld	(hl), #0x00
;main.c:44: bullets[i].animationCounter = 0;
	ld	hl, #0x0005
	add	hl, de
	ld	(hl), #0x00
;main.c:45: bullets[i].spriteIndex = 0;
	ld	hl, #0x0006
	add	hl, de
	ld	(hl), #0x00
;main.c:38: for (UINT8 i = 0; i < MAX_BULLETS; i++) {
	inc	c
;main.c:47: }
	jr	00103$
;main.c:50: void fire_bullets() {
;	---------------------------------
; Function fire_bullets
; ---------------------------------
_fire_bullets::
	add	sp, #-14
;main.c:51: for (UINT8 i = 0; i < MAX_BULLETS; i += 2) {
	ldhl	sp,	#13
	ld	(hl), #0x00
00110$:
	ldhl	sp,	#13
	ld	a, (hl)
	sub	a, #0x0a
	jp	NC, 00112$
;main.c:52: if (!bullets[i].active && !bullets[i + 1].active) {
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	ld	bc,#_bullets
	add	hl,bc
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	hl, #0x0004
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#13
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#12
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	jp	NZ, 00111$
	inc	hl
	ld	c, (hl)
	inc	c
	ld	a, c
	rlca
	sbc	a, a
	ld	b, a
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	ld	bc,#_bullets
	add	hl,bc
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jp	NZ, 00111$
;main.c:53: bullets[i].x = hero_x;
	pop	de
	push	de
	ld	a, (#_hero_x)
	ld	(de), a
;main.c:54: bullets[i].y = hero_y;
	pop	de
	push	de
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (#_hero_y)
	ld	(de), a
;main.c:55: bullets[i].directionX = -1; // Gauche
	pop	hl
	push	hl
	inc	hl
	inc	hl
	ld	(hl), #0xff
;main.c:56: bullets[i].directionY = -1; // Haut
	pop	hl
	push	hl
	inc	hl
	inc	hl
	inc	hl
	ld	(hl), #0xff
;main.c:57: bullets[i].active = 1;
	ldhl	sp,	#11
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
;main.c:59: bullets[i + 1].x = hero_x;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (#_hero_x)
	ld	(de), a
;main.c:60: bullets[i + 1].y = hero_y;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (#_hero_y)
	ld	(de), a
;main.c:61: bullets[i + 1].directionX = 1; // Droite
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	ld	(hl), #0x01
;main.c:62: bullets[i + 1].directionY = 1; // Bas
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	inc	hl
	ld	(hl), #0x01
;main.c:63: bullets[i + 1].active = 1;
	ld	a, #0x01
	ld	(bc), a
;main.c:66: set_sprite_tile(8 + i, 16);      // Première frame (bullet) pour la gauche
	ldhl	sp,	#13
	ld	a, (hl)
	add	a, #0x08
	ldhl	sp,	#8
	ld	(hl), a
	ld	c, (hl)
;c:\gbdk\include\gb\gb.h:1875: shadow_OAM[nb].tile=tile;
	xor	a, a
	sla	c
	adc	a, a
	sla	c
	adc	a, a
	ldhl	sp,	#11
	ld	(hl), c
	inc	hl
	ld	(hl), a
	ld	de, #_shadow_OAM
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#11
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#10
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#13
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#12
	ld	(hl-), a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x10
;main.c:67: set_sprite_tile(8 + i + 1, 17);  // Deuxième frame (bullet2) pour la droite
	ldhl	sp,	#13
	ld	a, (hl)
	add	a, #0x09
	ldhl	sp,	#9
	ld	(hl), a
	ld	c, (hl)
;c:\gbdk\include\gb\gb.h:1875: shadow_OAM[nb].tile=tile;
	ldhl	sp,	#12
	ld	a, c
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00143$:
	ldhl	sp,	#12
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00143$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_shadow_OAM
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#14
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#13
	ld	(hl-), a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x11
;main.c:69: move_sprite(8 + i, bullets[i].x, bullets[i].y);
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#13
	ld	(hl-), a
	pop	de
	push	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#11
	ld	(hl), a
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	a, (hl-)
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00144$:
	ldhl	sp,	#10
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00144$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_shadow_OAM
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#10
	ld	(hl), a
	ldhl	sp,	#5
	ld	a, (hl)
	ldhl	sp,	#11
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	inc	hl
	ld	d, a
	ld	a, (hl-)
	dec	hl
	dec	hl
	ld	(de), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#12
	ld	a, (hl)
	ld	(de), a
;main.c:70: move_sprite(8 + i + 1, bullets[i + 1].x, bullets[i + 1].y);
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#13
	ld	(hl), a
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#12
	ld	(hl), a
	ldhl	sp,	#9
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	a, (hl-)
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00145$:
	ldhl	sp,	#10
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00145$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_shadow_OAM
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	inc	hl
	ld	d, a
	ld	a, (hl-)
	dec	hl
	dec	hl
	ld	(de), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#12
	ld	a, (hl)
	ld	(de), a
;main.c:71: return;
	jr	00112$
00111$:
;main.c:51: for (UINT8 i = 0; i < MAX_BULLETS; i += 2) {
	ldhl	sp,	#13
	inc	(hl)
	inc	(hl)
	jp	00110$
00112$:
;main.c:74: }
	add	sp, #14
	ret
;main.c:77: void update_bullets() {
;	---------------------------------
; Function update_bullets
; ---------------------------------
_update_bullets::
	add	sp, #-9
;main.c:78: for (UINT8 i = 0; i < MAX_BULLETS; i++) {
	ldhl	sp,	#8
	ld	(hl), #0x00
00119$:
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x0a
	jp	NC, 00121$
;main.c:79: if (bullets[i].active) {
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	ld	bc,#_bullets
	add	hl,bc
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jp	Z, 00120$
;main.c:80: bullets[i].x += bullets[i].directionX * 4; // Mise à jour de la position X
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	ld	c, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	de
	inc	de
	ld	a, (de)
	add	a, a
	add	a, a
	add	a, c
	ld	c, a
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	(hl), c
;main.c:81: bullets[i].y += bullets[i].directionY * 4; // Mise à jour de la position Y
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	ld	a, (bc)
	ld	e, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	inc	hl
	ld	a, (hl)
	add	a, a
	add	a, a
	add	a, e
	ld	(bc), a
;main.c:83: move_sprite(8 + i, bullets[i].x, bullets[i].y);
	ld	a, (bc)
	ld	c, a
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	inc	hl
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	ld	a, (hl)
	add	a, #0x08
	ldhl	sp,	#0
	ld	(hl), a
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	xor	a, a
	ld	h, a
	add	hl, hl
	add	hl, hl
	ld	de, #_shadow_OAM
	add	hl, de
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, c
	ld	(hl+), a
	ld	c, l
	ld	b, h
	ldhl	sp,	#7
;main.c:86: bullets[i].animationCounter++;
	ld	a, (hl-)
	dec	hl
	dec	hl
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	inc	a
	ld	e, a
	ld	(bc), a
;main.c:87: if (bullets[i].animationCounter > 1) {
	ld	a, #0x01
	sub	a, e
	jr	NC, 00102$
;main.c:88: bullets[i].spriteIndex = bullets[i].spriteIndex == 0 ? 1 : 0;
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	ld	c, #0x01
	jr	Z, 00124$
	ld	c, #0x00
00124$:
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
;main.c:89: set_sprite_tile(8 + i, 16 + bullets[i].spriteIndex);
	ldhl	sp,	#8
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	ld	a, #<(_bullets)
	add	a, l
	ld	c, a
	ld	a, #>(_bullets)
	adc	a, h
	ld	b, a
	ld	hl, #0x0006
	add	hl, bc
	ld	a, (hl)
	add	a, #0x10
	ldhl	sp,	#7
	ld	(hl), a
	ldhl	sp,	#0
;c:\gbdk\include\gb\gb.h:1875: shadow_OAM[nb].tile=tile;
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	ld	de, #_shadow_OAM
	add	hl, de
	inc	hl
	inc	hl
	ld	e, l
	ld	d, h
	ldhl	sp,	#7
	ld	a, (hl)
	ld	(de), a
;main.c:90: bullets[i].animationCounter = 0;
	ld	hl, #0x0005
	add	hl, bc
	ld	(hl), #0x00
00102$:
;main.c:94: if (bullets[i].x > 160 || bullets[i].x < 0 ||
	ldhl	sp,	#8
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	ld	bc,#_bullets
	add	hl,bc
	push	hl
	ld	a, l
	ldhl	sp,	#3
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#2
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#7
	ld	(hl), a
	ld	a, #0xa0
	sub	a, (hl)
	jp	C, 00103$
;main.c:95: bullets[i].y > 160 || bullets[i].y < 0 || // Vérification de la limite Y
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	inc	bc
	ld	a, (bc)
	ld	(hl), a
	ld	a, #0xa0
	sub	a, (hl)
	jp	C, 00103$
;main.c:96: (bullets[i].x > enemy_x - 8 && bullets[i].x < enemy_x + 8 &&
	ld	hl, #_enemy_x
	ld	c, (hl)
	ld	b, #0x00
	ld	de, #0x0008
	ld	a, c
	sub	a, e
	ld	e, a
	ld	a, b
	sbc	a, d
	ldhl	sp,	#5
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,	#7
	ld	a, (hl-)
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#4
	ld	e, l
	ld	d, h
	ldhl	sp,	#6
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	ld	a, (de)
	ld	d, a
	bit	7, (hl)
	jr	Z, 00196$
	bit	7, d
	jr	NZ, 00197$
	cp	a, a
	jr	00197$
00196$:
	bit	7, d
	jr	Z, 00197$
	scf
00197$:
	jp	NC, 00120$
	ld	hl, #0x0008
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#6
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 00198$
	bit	7, d
	jr	NZ, 00199$
	cp	a, a
	jr	00199$
00198$:
	bit	7, d
	jr	Z, 00199$
	scf
00199$:
	jr	NC, 00120$
;main.c:97: bullets[i].y > enemy_y - 8 && bullets[i].y < enemy_y + 8)) {
	ld	hl, #_enemy_y
	ld	c, (hl)
	ld	b, #0x00
	ld	de, #0x0008
	ld	a, c
	sub	a, e
	ld	e, a
	ld	a, b
	sbc	a, d
	ldhl	sp,	#5
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#4
	ld	e, l
	ld	d, h
	ldhl	sp,	#6
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	ld	a, (de)
	ld	d, a
	bit	7, (hl)
	jr	Z, 00200$
	bit	7, d
	jr	NZ, 00201$
	cp	a, a
	jr	00201$
00200$:
	bit	7, d
	jr	Z, 00201$
	scf
00201$:
	jr	NC, 00120$
	ld	hl, #0x0008
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#6
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 00202$
	bit	7, d
	jr	NZ, 00203$
	cp	a, a
	jr	00203$
00202$:
	bit	7, d
	jr	Z, 00203$
	scf
00203$:
	jr	NC, 00120$
00103$:
;main.c:98: bullets[i].active = 0;
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
;main.c:99: move_sprite(8 + i, 0, 0); // Déplace le sprite hors écran
	ldhl	sp,	#0
	ld	c, (hl)
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	xor	a, a
	ld	l, c
	ld	h, a
	add	hl, hl
	add	hl, hl
	ld	de, #_shadow_OAM
	add	hl, de
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;main.c:99: move_sprite(8 + i, 0, 0); // Déplace le sprite hors écran
00120$:
;main.c:78: for (UINT8 i = 0; i < MAX_BULLETS; i++) {
	ldhl	sp,	#8
	inc	(hl)
	jp	00119$
00121$:
;main.c:103: }
	add	sp, #9
	ret
;main.c:106: void update_enemy_sprite() {
;	---------------------------------
; Function update_enemy_sprite
; ---------------------------------
_update_enemy_sprite::
;main.c:107: int move_x = 0;
;main.c:108: int move_y = 0;
	ld	c, #0x00
	ld	d, c
;main.c:110: if (enemy_x < hero_x) move_x = 1;
	ld	a, (#_enemy_x)
	ld	hl, #_hero_x
	sub	a, (hl)
	jr	NC, 00104$
	ld	c, #0x01
	jr	00105$
00104$:
;main.c:111: else if (enemy_x > hero_x) move_x = -1;
	ld	a, (#_hero_x)
	ld	hl, #_enemy_x
	sub	a, (hl)
	jr	NC, 00105$
	ld	c, #0xff
00105$:
;main.c:113: if (enemy_y < hero_y) move_y = 1;
	ld	a, (#_enemy_y)
	ld	hl, #_hero_y
	sub	a, (hl)
	jr	NC, 00109$
	ld	d, #0x01
	jr	00110$
00109$:
;main.c:114: else if (enemy_y > hero_y) move_y = -1;
	ld	a, (#_hero_y)
	ld	hl, #_enemy_y
	sub	a, (hl)
	jr	NC, 00110$
	ld	d, #0xff
00110$:
;main.c:116: enemy_x += move_x * 2 * enemySpeed;
	sla	c
	push	de
	ld	hl, #_enemySpeed
	ld	e, (hl)
	ld	a, c
	call	__muluschar
	pop	de
	ld	hl, #_enemy_x
	ld	a, (hl)
	add	a, c
	ld	(hl), a
;main.c:117: enemy_y += move_y * 2 * enemySpeed;
	sla	d
	ld	hl, #_enemySpeed
	ld	e, (hl)
	ld	a, d
	call	__muluschar
	ld	hl, #_enemy_y
	ld	a, (hl)
	add	a, c
	ld	(hl), a
;main.c:119: if (enemy_x > 150) enemy_x = 150;
	ld	a, #0x96
	ld	hl, #_enemy_x
	sub	a, (hl)
	jr	NC, 00112$
	ld	(hl), #0x96
00112$:
;main.c:120: if (enemy_x < 10) enemy_x = 10;
	ld	hl, #_enemy_x
	ld	a, (hl)
	sub	a, #0x0a
	jr	NC, 00114$
	ld	(hl), #0x0a
00114$:
;main.c:121: if (enemy_y > 140) enemy_y = 140;
	ld	a, #0x8c
	ld	hl, #_enemy_y
	sub	a, (hl)
	jr	NC, 00116$
	ld	(hl), #0x8c
00116$:
;main.c:122: if (enemy_y < 10) enemy_y = 10;
	ld	hl, #_enemy_y
	ld	a, (hl)
	sub	a, #0x0a
	jr	NC, 00118$
	ld	(hl), #0x0a
00118$:
;main.c:124: move_sprite(4, enemy_x, enemy_y);
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
;main.c:125: move_sprite(5, enemy_x + 8, enemy_y);
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
;main.c:126: move_sprite(6, enemy_x, enemy_y + 8);
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
;main.c:127: move_sprite(7, enemy_x + 8, enemy_y + 8);
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
;main.c:129: enemyAnimationCounter++;
	ld	hl, #_enemyAnimationCounter
	inc	(hl)
;main.c:131: if (enemyAnimationCounter > 1) {
	ld	a, #0x01
	sub	a, (hl)
	ret	NC
;main.c:132: if (enemySpriteIndex == 0) {
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
;main.c:137: enemySpriteIndex = 1;
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
;main.c:143: enemySpriteIndex = 0;
	ld	hl, #_enemySpriteIndex
	ld	(hl), #0x00
00121$:
;main.c:145: enemyAnimationCounter = 0;
	ld	hl, #_enemyAnimationCounter
	ld	(hl), #0x00
;main.c:147: }
	ret
;main.c:150: void update_hero_sprite() {
;	---------------------------------
; Function update_hero_sprite
; ---------------------------------
_update_hero_sprite::
;main.c:151: UINT8 move_x = 0;
;main.c:152: UINT8 move_y = 0;
	ld	bc, #0x0
;main.c:154: if (joypad() & J_LEFT) move_x = -8;
	call	_joypad
	bit	1, a
	jr	Z, 00102$
	ld	b, #0xf8
00102$:
;main.c:155: if (joypad() & J_RIGHT) move_x = 8;
	call	_joypad
	rrca
	jr	NC, 00104$
	ld	b, #0x08
00104$:
;main.c:156: if (joypad() & J_UP) move_y = -8;
	call	_joypad
	bit	2, a
	jr	Z, 00106$
	ld	c, #0xf8
00106$:
;main.c:157: if (joypad() & J_DOWN) move_y = 8;
	call	_joypad
	bit	3, a
	jr	Z, 00108$
	ld	c, #0x08
00108$:
;main.c:159: hero_x += move_x;
	ld	hl, #_hero_x
	ld	a, (hl)
	add	a, b
	ld	(hl), a
;main.c:160: hero_y += move_y;
	ld	hl, #_hero_y
	ld	a, (hl)
	add	a, c
	ld	(hl), a
;main.c:162: if (hero_x > 152) hero_x = 154;
	ld	a, #0x98
	ld	hl, #_hero_x
	sub	a, (hl)
	jr	NC, 00110$
	ld	(hl), #0x9a
00110$:
;main.c:163: if (hero_x < 10) hero_x = 8;
	ld	hl, #_hero_x
	ld	a, (hl)
	sub	a, #0x0a
	jr	NC, 00112$
	ld	(hl), #0x08
00112$:
;main.c:164: if (hero_y > 144) hero_y = 144;
	ld	a, #0x90
	ld	hl, #_hero_y
	sub	a, (hl)
	jr	NC, 00114$
	ld	(hl), #0x90
00114$:
;main.c:165: if (hero_y < 16) hero_y = 16;
	ld	hl, #_hero_y
	ld	a, (hl)
	sub	a, #0x10
	jr	NC, 00116$
	ld	(hl), #0x10
00116$:
;main.c:167: move_sprite(0, hero_x, hero_y);
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
;main.c:168: move_sprite(1, hero_x + 8, hero_y);
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
;main.c:169: move_sprite(2, hero_x, hero_y + 8);
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
;main.c:170: move_sprite(3, hero_x + 8, hero_y + 8);
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
;main.c:172: if (heroSpriteIndex == 0) {
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
;main.c:177: heroSpriteIndex = 1;
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
;main.c:183: heroSpriteIndex = 0;
	ld	hl, #_heroSpriteIndex
	ld	(hl), #0x00
;main.c:185: }
	ret
;main.c:187: void main(void) {
;	---------------------------------
; Function main
; ---------------------------------
_main::
;main.c:188: set_sprite_data(0, 8, hero);
	ld	de, #_hero
	push	de
	ld	hl, #0x800
	push	hl
	call	_set_sprite_data
	add	sp, #4
;main.c:189: set_sprite_data(8, 8, enemy);
	ld	de, #_enemy
	push	de
	ld	hl, #0x808
	push	hl
	call	_set_sprite_data
	add	sp, #4
;main.c:190: set_sprite_data(16, 2, bullet);
	ld	de, #_bullet
	push	de
	ld	a, #0x02
	push	af
	inc	sp
	ld	a, #0x10
	push	af
	inc	sp
	call	_set_sprite_data
	add	sp, #4
;main.c:192: initialize_bullets();
	call	_initialize_bullets
;c:\gbdk\include\gb\gb.h:1875: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 18)
	ld	(hl), #0x08
	ld	hl, #(_shadow_OAM + 22)
	ld	(hl), #0x09
	ld	hl, #(_shadow_OAM + 26)
	ld	(hl), #0x0a
	ld	hl, #(_shadow_OAM + 30)
	ld	(hl), #0x0b
;main.c:198: move_sprite(4, enemy_x, enemy_y);
	ld	hl, #_enemy_y
	ld	c, (hl)
	ld	hl, #_enemy_x
	ld	b, (hl)
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 16)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;main.c:199: move_sprite(5, enemy_x + 8, enemy_y);
	ld	hl, #_enemy_y
	ld	c, (hl)
	ld	a, (#_enemy_x)
	add	a, #0x08
	ld	b, a
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 20)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;main.c:200: move_sprite(6, enemy_x, enemy_y + 8);
	ld	a, (#_enemy_y)
	add	a, #0x08
	ld	c, a
	ld	hl, #_enemy_x
	ld	b, (hl)
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 24)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;main.c:201: move_sprite(7, enemy_x + 8, enemy_y + 8);
	ld	a, (#_enemy_y)
	add	a, #0x08
	ld	c, a
	ld	a, (#_enemy_x)
	add	a, #0x08
	ld	b, a
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 28)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;main.c:203: move_sprite(0, hero_x, hero_y);
	ld	hl, #_hero_y
	ld	c, (hl)
	ld	hl, #_hero_x
	ld	b, (hl)
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #_shadow_OAM
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;main.c:204: move_sprite(1, hero_x + 8, hero_y);
	ld	hl, #_hero_y
	ld	c, (hl)
	ld	a, (#_hero_x)
	add	a, #0x08
	ld	b, a
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 4)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;main.c:205: move_sprite(2, hero_x, hero_y + 8);
	ld	a, (#_hero_y)
	add	a, #0x08
	ld	c, a
	ld	hl, #_hero_x
	ld	b, (hl)
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 8)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;main.c:206: move_sprite(3, hero_x + 8, hero_y + 8);
	ld	a, (#_hero_y)
	add	a, #0x08
	ld	c, a
	ld	a, (#_hero_x)
	add	a, #0x08
	ld	b, a
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 12)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;main.c:208: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;main.c:210: while(1) {
00104$:
;main.c:211: update_enemy_sprite();
	call	_update_enemy_sprite
;main.c:212: update_hero_sprite();
	call	_update_hero_sprite
;main.c:214: if (joypad() & J_A) fire_bullets();
	call	_joypad
	bit	4, a
	jr	Z, 00102$
	call	_fire_bullets
00102$:
;main.c:215: update_bullets();
	call	_update_bullets
;main.c:217: delay(100);
	ld	de, #0x0064
	call	_delay
;main.c:219: }
	jr	00104$
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
__xinit__bullet:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
__xinit__bullet2:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x00	; 0
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
	.db #0x0a	; 10
__xinit__hero_y:
	.db #0x0a	; 10
__xinit__heroSpriteIndex:
	.db #0x00	; 0
	.area _CABS (ABS)
