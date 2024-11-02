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
	.globl _handle_hero_collision
	.globl _update_health_display_enemy
	.globl _update_health_display_hero
	.globl _update_enemy_sprite
	.globl _update_bullets
	.globl _fire_bullets
	.globl _initialize_bullets
	.globl _checkRestart
	.globl _interruptLCD
	.globl _font_set
	.globl _font_load
	.globl _font_init
	.globl _printf
	.globl _set_sprite_data
	.globl _set_win_tiles
	.globl _reset
	.globl _set_interrupts
	.globl _joypad
	.globl _delay
	.globl _add_LCD
	.globl _display_win
	.globl _heroHealth
	.globl _hitCooldown
	.globl _heroSpriteIndex
	.globl _hero_y
	.globl _hero_x
	.globl _gameOver
	.globl _enemyAlive
	.globl _enemyHealth
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
	.globl _windowEnemyMetric25
	.globl _windowEnemyMetric50
	.globl _windowEnemyMetric75
	.globl _windowEnemyMetric100
	.globl _windowHeroMetric25
	.globl _windowHeroMetric50
	.globl _windowHeroMetric75
	.globl _windowHeroMetric100
	.globl _bullets
	.globl _HIT_COOLDOWN_DURATION
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
_windowHeroMetric100::
	.ds 5
_windowHeroMetric75::
	.ds 4
_windowHeroMetric50::
	.ds 4
_windowHeroMetric25::
	.ds 4
_windowEnemyMetric100::
	.ds 5
_windowEnemyMetric75::
	.ds 6
_windowEnemyMetric50::
	.ds 4
_windowEnemyMetric25::
	.ds 4
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
_enemyHealth::
	.ds 2
_enemyAlive::
	.ds 1
_gameOver::
	.ds 1
_hero_x::
	.ds 1
_hero_y::
	.ds 1
_heroSpriteIndex::
	.ds 1
_hitCooldown::
	.ds 1
_heroHealth::
	.ds 1
_display_win::
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
;main.c:48: void interruptLCD() {
;	---------------------------------
; Function interruptLCD
; ---------------------------------
_interruptLCD::
;main.c:49: if (display_win) {
	ld	a, (#_display_win)
	or	a, a
	ret	Z
;main.c:50: SHOW_WIN;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x20
	ldh	(_LCDC_REG + 0), a
;main.c:52: }
	ret
_HIT_COOLDOWN_DURATION:
	.db #0x05	; 5
;main.c:55: void checkRestart() {
;	---------------------------------
; Function checkRestart
; ---------------------------------
_checkRestart::
;main.c:56: if (gameOver > 0) { // Si le jeu est terminé
	ld	a, (#_gameOver)
	or	a, a
	ret	Z
;main.c:57: if (joypad() & J_B) { // Si le bouton B est pressé
	call	_joypad
	bit	5, a
;main.c:58: reset(); // Redémarre le jeu
	jp	NZ,_reset
;main.c:61: }
	ret
;main.c:78: void initialize_bullets() {
;	---------------------------------
; Function initialize_bullets
; ---------------------------------
_initialize_bullets::
;main.c:79: for (UINT8 i = 0; i < MAX_BULLETS; i++) {
	ld	c, #0x00
00103$:
	ld	a, c
	sub	a, #0x0a
	ret	NC
;main.c:80: bullets[i].x = 0;
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
;main.c:81: bullets[i].y = 0;
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, d
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	ld	(hl), #0x00
;main.c:82: bullets[i].directionX = 0;
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, d
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	ld	(hl), #0x00
;main.c:83: bullets[i].directionY = 0;
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
;main.c:84: bullets[i].active = 0; // Inactive par défaut
	ld	hl, #0x0004
	add	hl, de
	ld	(hl), #0x00
;main.c:85: bullets[i].animationCounter = 0;
	ld	hl, #0x0005
	add	hl, de
	ld	(hl), #0x00
;main.c:86: bullets[i].spriteIndex = 0;
	ld	hl, #0x0006
	add	hl, de
	ld	(hl), #0x00
;main.c:79: for (UINT8 i = 0; i < MAX_BULLETS; i++) {
	inc	c
;main.c:88: }
	jr	00103$
;main.c:91: void fire_bullets() {
;	---------------------------------
; Function fire_bullets
; ---------------------------------
_fire_bullets::
	add	sp, #-14
;main.c:93: for (UINT8 i = 0; i < MAX_BULLETS; i += 2) {
	ldhl	sp,	#13
	ld	(hl), #0x00
00110$:
	ldhl	sp,	#13
	ld	a, (hl)
	sub	a, #0x0a
	jp	NC, 00112$
;main.c:94: if (!bullets[i].active && !bullets[i + 1].active) {
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
;main.c:95: bullets[i].x = hero_x;
	pop	de
	push	de
	ld	a, (#_hero_x)
	ld	(de), a
;main.c:96: bullets[i].y = hero_y;
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
;main.c:97: bullets[i].directionX = -2; // Gauche
	pop	hl
	push	hl
	inc	hl
	inc	hl
	ld	(hl), #0xfe
;main.c:98: bullets[i].directionY = -2; // Haut
	pop	hl
	push	hl
	inc	hl
	inc	hl
	inc	hl
	ld	(hl), #0xfe
;main.c:99: bullets[i].active = 1;
	ldhl	sp,	#11
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
;main.c:101: bullets[i + 1].x = hero_x;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (#_hero_x)
	ld	(de), a
;main.c:102: bullets[i + 1].y = hero_y;
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
;main.c:103: bullets[i + 1].directionX = 2; // Droite
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
	ld	(hl), #0x02
;main.c:104: bullets[i + 1].directionY = 2; // Bas
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
	ld	(hl), #0x02
;main.c:105: bullets[i + 1].active = 3;
	ld	a, #0x03
	ld	(bc), a
;main.c:108: set_sprite_tile(8 + i, 16);
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
;main.c:109: set_sprite_tile(8 + i + 1, 17);
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
;main.c:112: move_sprite(8 + i, bullets[i].x, bullets[i].y);
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
;main.c:113: move_sprite(8 + i + 1, bullets[i + 1].x, bullets[i + 1].y);
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
;main.c:114: return;
	jr	00112$
00111$:
;main.c:93: for (UINT8 i = 0; i < MAX_BULLETS; i += 2) {
	ldhl	sp,	#13
	inc	(hl)
	inc	(hl)
	jp	00110$
00112$:
;main.c:117: }
	add	sp, #14
	ret
;main.c:120: void update_bullets() {
;	---------------------------------
; Function update_bullets
; ---------------------------------
_update_bullets::
	add	sp, #-10
;main.c:121: for (UINT8 i = 0; i < MAX_BULLETS; i++) {
	ldhl	sp,	#9
	ld	(hl), #0x00
00130$:
	ldhl	sp,	#9
	ld	a, (hl)
	sub	a, #0x0a
	jp	NC, 00132$
;main.c:122: if (bullets[i].active) {
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
	ldhl	sp,	#8
	ld	(hl), a
	ld	a, (hl)
	or	a, a
	jp	Z, 00131$
;main.c:124: bullets[i].x += bullets[i].directionX * 4;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#8
	ld	(hl), a
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
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
	ld	(hl), a
	sla	(hl)
	sla	(hl)
	inc	hl
	ld	a, (hl-)
	add	a, (hl)
	ld	c, a
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
;main.c:125: bullets[i].y += bullets[i].directionY * 4;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#5
	ld	(hl), a
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	inc	bc
	inc	bc
	ld	a, (bc)
	ldhl	sp,	#6
	ld	(hl), a
	sla	(hl)
	sla	(hl)
	dec	hl
	ld	a, (hl+)
	add	a, (hl)
	inc	hl
	ld	c, a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
;main.c:126: move_sprite(8 + i, bullets[i].x, bullets[i].y);
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#4
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	inc	hl
	ld	d, a
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#9
	ld	a, (hl-)
	ld	(hl), a
	ld	a, (hl-)
	dec	hl
	add	a, #0x08
	ld	(hl), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	a, (hl-)
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	ld	a, #0x02
00237$:
	ldhl	sp,	#0
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00237$
	pop	de
	push	de
	ld	hl, #_shadow_OAM
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#4
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	ldhl	sp,	#5
;main.c:129: bullets[i].animationCounter++;
	ld	a, (hl-)
	dec	hl
	dec	hl
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	inc	a
	ld	c, a
	ld	(de), a
;main.c:130: if (bullets[i].animationCounter > 1) {
	ld	a, #0x01
	sub	a, c
	jr	NC, 00102$
;main.c:131: bullets[i].spriteIndex = bullets[i].spriteIndex == 0 ? 1 : 0;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	jr	NZ, 00134$
	ldhl	sp,	#5
	ld	(hl), #0x01
	jr	00135$
00134$:
	ldhl	sp,	#5
	ld	(hl), #0x00
00135$:
	ldhl	sp,	#5
	ld	a, (hl+)
	inc	hl
	ld	c, a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
;main.c:132: set_sprite_tile(8 + i, 16 + bullets[i].spriteIndex);
	ldhl	sp,	#9
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	ld	a, l
	add	a, #<(_bullets)
	ld	c, a
	ld	a, h
	adc	a, #>(_bullets)
	ld	b, a
	ld	hl, #0x0006
	add	hl, bc
	ld	a, (hl)
	add	a, #0x10
	ld	e, a
	ldhl	sp,	#6
	ld	d, (hl)
;c:\gbdk\include\gb\gb.h:1875: shadow_OAM[nb].tile=tile;
	ld	l, d
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	push	de
	ld	de, #_shadow_OAM
	add	hl, de
	inc	hl
	inc	hl
	pop	de
	ld	(hl), e
;main.c:133: bullets[i].animationCounter = 0;
	ld	hl, #0x0005
	add	hl, bc
	ld	(hl), #0x00
00102$:
;main.c:137: if (enemyAlive && bullets[i].x > enemy_x - 8 && bullets[i].x < enemy_x + 8 &&
	ld	a, (#_enemyAlive)
	or	a, a
	jp	Z, 00108$
	ldhl	sp,	#9
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
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#8
	ld	(hl), a
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
	ldhl	sp,	#8
	ld	a, (hl-)
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#4
	ld	e, l
	ld	d, h
	ldhl	sp,	#7
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	ld	a, (de)
	ld	d, a
	bit	7, (hl)
	jr	Z, 00238$
	bit	7, d
	jr	NZ, 00239$
	cp	a, a
	jr	00239$
00238$:
	bit	7, d
	jr	Z, 00239$
	scf
00239$:
	jp	NC, 00108$
	ld	hl, #0x0008
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#7
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 00240$
	bit	7, d
	jr	NZ, 00241$
	cp	a, a
	jr	00241$
00240$:
	bit	7, d
	jr	Z, 00241$
	scf
00241$:
	jp	NC, 00108$
;main.c:138: bullets[i].y > enemy_y - 8 && bullets[i].y < enemy_y + 8) {
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	ld	a, (bc)
	ldhl	sp,	#8
	ld	(hl), a
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
	ld	(hl), e
	ldhl	sp,	#8
	ld	a, (hl-)
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#4
	ld	e, l
	ld	d, h
	ldhl	sp,	#7
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	ld	a, (de)
	ld	d, a
	bit	7, (hl)
	jr	Z, 00242$
	bit	7, d
	jr	NZ, 00243$
	cp	a, a
	jr	00243$
00242$:
	bit	7, d
	jr	Z, 00243$
	scf
00243$:
	jp	NC, 00108$
	ld	hl, #0x0008
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#7
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 00244$
	bit	7, d
	jr	NZ, 00245$
	cp	a, a
	jr	00245$
00244$:
	bit	7, d
	jr	Z, 00245$
	scf
00245$:
	jr	NC, 00108$
;main.c:139: bullets[i].active = 0; // Désactive la balle
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
;main.c:140: move_sprite(8 + i, 0, 0); // Retire la balle de l'écran
	ldhl	sp,	#6
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
;main.c:143: if (enemyHealth > 0) { // Permet une mise à jour même à 0 de vie
	ld	hl, #_enemyHealth + 1
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00104$
;main.c:144: enemyHealth = enemyHealth > 25 ? enemyHealth - 25 : 0;
	ld	a, #0x19
	sub	a, (hl)
	inc	hl
	ld	a, #0x00
	sbc	a, (hl)
	jr	NC, 00136$
	ld	hl, #_enemyHealth
	ld	a, (hl+)
	add	a, #0xe7
	ld	c, a
	ld	a, (hl)
	adc	a, #0xff
	ld	b, a
	jr	00137$
00136$:
	ld	bc, #0x0000
00137$:
	ld	hl, #_enemyHealth
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;main.c:145: update_health_display_enemy();
	call	_update_health_display_enemy
00104$:
;main.c:148: if (enemyHealth == 0) { // L'ennemi est mort
	ld	hl, #_enemyHealth + 1
	ld	a, (hl-)
	or	a, (hl)
	jr	NZ, 00108$
;main.c:149: enemyAlive = 0; // Marque l'ennemi comme vaincu
	ld	hl, #_enemyAlive
	ld	(hl), #0x00
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 16)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 20)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 24)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 28)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;main.c:158: printf("Victory ! press B for restart");
	ld	de, #___str_0
	push	de
	call	_printf
	pop	hl
;main.c:159: display_win = 0;
	ld	hl, #_display_win
	ld	(hl), #0x00
;main.c:160: gameOver = 2; // Définit l'état du jeu comme victoire
	ld	hl, #_gameOver
	ld	(hl), #0x02
00108$:
;main.c:165: if (bullets[i].x > 160 || bullets[i].x < 0 ||
	ldhl	sp,	#9
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
	ld	a, (de)
	ld	c, a
	ld	a, #0xa0
	sub	a, c
	jr	C, 00113$
;main.c:166: bullets[i].y > 160 || bullets[i].y < 0) {
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	(hl), a
	ld	a, #0xa0
	sub	a, (hl)
	jr	NC, 00131$
00113$:
;main.c:167: bullets[i].active = 0;
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl-), a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
;main.c:168: move_sprite(8 + i, 0, 0); // Retire la balle de l'écran
	ldhl	sp,	#6
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	a, (hl-)
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00246$:
	ldhl	sp,	#7
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00246$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_shadow_OAM
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#7
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#6
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	(hl-), a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#7
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#6
	ld	(hl-), a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
;main.c:168: move_sprite(8 + i, 0, 0); // Retire la balle de l'écran
00131$:
;main.c:121: for (UINT8 i = 0; i < MAX_BULLETS; i++) {
	ldhl	sp,	#9
	inc	(hl)
	jp	00130$
00132$:
;main.c:172: }
	add	sp, #10
	ret
___str_0:
	.ascii "Victory ! press B for restart"
	.db 0x00
;main.c:175: void update_enemy_sprite() {
;	---------------------------------
; Function update_enemy_sprite
; ---------------------------------
_update_enemy_sprite::
;main.c:176: int move_x = 0;
;main.c:177: int move_y = 0;
	ld	c, #0x00
	ld	d, c
;main.c:180: if (enemy_x < hero_x) move_x = 1;
	ld	a, (#_enemy_x)
	ld	hl, #_hero_x
	sub	a, (hl)
	jr	NC, 00104$
	ld	c, #0x01
	jr	00105$
00104$:
;main.c:181: else if (enemy_x > hero_x) move_x = -1;
	ld	a, (#_hero_x)
	ld	hl, #_enemy_x
	sub	a, (hl)
	jr	NC, 00105$
	ld	c, #0xff
00105$:
;main.c:182: if (enemy_y < hero_y) move_y = 1;
	ld	a, (#_enemy_y)
	ld	hl, #_hero_y
	sub	a, (hl)
	jr	NC, 00109$
	ld	d, #0x01
	jr	00110$
00109$:
;main.c:183: else if (enemy_y > hero_y) move_y = -1;
	ld	a, (#_hero_y)
	ld	hl, #_enemy_y
	sub	a, (hl)
	jr	NC, 00110$
	ld	d, #0xff
00110$:
;main.c:186: enemy_x += move_x * 4 * enemySpeed;
	ld	a, c
	add	a, a
	add	a, a
	ld	c, a
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
;main.c:187: enemy_y += move_y * 4 * enemySpeed;
	ld	a, d
	add	a, a
	add	a, a
	ld	c, a
	ld	hl, #_enemySpeed
	ld	e, (hl)
	ld	a, c
	call	__muluschar
	ld	hl, #_enemy_y
	ld	a, (hl)
	add	a, c
	ld	(hl), a
;main.c:190: move_sprite(4, enemy_x, enemy_y);
	ld	b, (hl)
	ld	hl, #_enemy_x
	ld	c, (hl)
;c:\gbdk\include\gb\gb.h:1961: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 16)
;c:\gbdk\include\gb\gb.h:1962: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;main.c:191: move_sprite(5, enemy_x + 8, enemy_y);
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
;main.c:192: move_sprite(6, enemy_x, enemy_y + 8);
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
;main.c:193: move_sprite(7, enemy_x + 8, enemy_y + 8);
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
;main.c:196: enemyAnimationCounter++;
	ld	hl, #_enemyAnimationCounter
	inc	(hl)
;main.c:197: if (enemyAnimationCounter > 1) {
	ld	a, #0x01
	sub	a, (hl)
	ret	NC
;main.c:198: enemySpriteIndex = 1 - enemySpriteIndex;
	ld	hl, #_enemySpriteIndex
	ld	c, (hl)
	ld	a, #0x01
	sub	a, c
	ld	(hl), a
;main.c:199: set_sprite_tile(4, enemySpriteIndex ? 8 : 12);
	ld	a, (hl)
	or	a, a
	ld	c, #0x08
	jr	NZ, 00124$
	ld	c, #0x0c
00124$:
;c:\gbdk\include\gb\gb.h:1875: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 18)
	ld	(hl), c
;main.c:200: set_sprite_tile(5, enemySpriteIndex ? 9 : 13);
	ld	a, (#_enemySpriteIndex)
	or	a, a
	ld	c, #0x09
	jr	NZ, 00126$
	ld	c, #0x0d
00126$:
;c:\gbdk\include\gb\gb.h:1875: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 22)
	ld	(hl), c
;main.c:201: set_sprite_tile(6, enemySpriteIndex ? 10 : 14);
	ld	a, (#_enemySpriteIndex)
	or	a, a
	ld	c, #0x0a
	jr	NZ, 00128$
	ld	c, #0x0e
00128$:
;c:\gbdk\include\gb\gb.h:1875: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 26)
	ld	(hl), c
;main.c:202: set_sprite_tile(7, enemySpriteIndex ? 11 : 15);
	ld	a, (#_enemySpriteIndex)
	or	a, a
	ld	c, #0x0b
	jr	NZ, 00130$
	ld	c, #0x0f
00130$:
;c:\gbdk\include\gb\gb.h:1875: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 30)
	ld	(hl), c
;main.c:203: enemyAnimationCounter = 0;
	ld	hl, #_enemyAnimationCounter
	ld	(hl), #0x00
;main.c:205: }
	ret
;main.c:208: void update_health_display_hero() {
;	---------------------------------
; Function update_health_display_hero
; ---------------------------------
_update_health_display_hero::
	add	sp, #-5
;main.c:209: UINT8 emptyLine[5] = {0x00, 0x00, 0x00, 0x00, 0x00};
	ldhl	sp,	#0
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
	ldhl	sp,	#1
	xor	a, a
	ld	(hl+), a
	xor	a, a
	ld	(hl+), a
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;main.c:210: set_win_tiles(0, 0, 5, 1, emptyLine);
	push	bc
	ld	hl, #0x105
	push	hl
	xor	a, a
	rrca
	push	af
	call	_set_win_tiles
	add	sp, #6
;main.c:212: switch (heroHealth) {
	ld	a,(#_heroHealth)
	cp	a,#0x19
	jr	Z, 00104$
	cp	a,#0x32
	jr	Z, 00103$
	cp	a,#0x4b
	jr	Z, 00102$
	sub	a, #0x64
	jr	NZ, 00106$
;main.c:214: set_win_tiles(0, 0, 5, 1, windowHeroMetric100);
	ld	de, #_windowHeroMetric100
	push	de
	ld	hl, #0x105
	push	hl
	xor	a, a
	rrca
	push	af
	call	_set_win_tiles
	add	sp, #6
;main.c:215: break;
	jr	00106$
;main.c:216: case 75:
00102$:
;main.c:217: set_win_tiles(0, 0, 4, 1, windowHeroMetric75);
	ld	de, #_windowHeroMetric75
	push	de
	ld	hl, #0x104
	push	hl
	xor	a, a
	rrca
	push	af
	call	_set_win_tiles
	add	sp, #6
;main.c:218: break;
	jr	00106$
;main.c:219: case 50:
00103$:
;main.c:220: set_win_tiles(0, 0, 4, 1, windowHeroMetric50);
	ld	de, #_windowHeroMetric50
	push	de
	ld	hl, #0x104
	push	hl
	xor	a, a
	rrca
	push	af
	call	_set_win_tiles
	add	sp, #6
;main.c:221: break;
	jr	00106$
;main.c:222: case 25:
00104$:
;main.c:223: set_win_tiles(0, 0, 4, 1, windowHeroMetric25);
	ld	de, #_windowHeroMetric25
	push	de
	ld	hl, #0x104
	push	hl
	xor	a, a
	rrca
	push	af
	call	_set_win_tiles
	add	sp, #6
;main.c:225: }
00106$:
;main.c:226: }
	add	sp, #5
	ret
;main.c:229: void update_health_display_enemy() {
;	---------------------------------
; Function update_health_display_enemy
; ---------------------------------
_update_health_display_enemy::
	add	sp, #-5
;main.c:230: UINT8 emptyLine[5] = {0x00, 0x00, 0x00, 0x00, 0x00};
	ldhl	sp,	#0
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
	ldhl	sp,	#1
	xor	a, a
	ld	(hl+), a
	xor	a, a
	ld	(hl+), a
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;main.c:233: set_win_tiles(15, 0, 5, 1, emptyLine);
	push	bc
	ld	hl, #0x105
	push	hl
	ld	hl, #0x0f
	push	hl
	call	_set_win_tiles
	add	sp, #6
;main.c:236: switch (enemyHealth) {
	ld	hl, #_enemyHealth
	ld	a, (hl+)
	sub	a, #0x19
	or	a, (hl)
	jr	Z, 00104$
	ld	hl, #_enemyHealth
	ld	a, (hl+)
	sub	a, #0x32
	or	a, (hl)
	jr	Z, 00103$
	ld	hl, #_enemyHealth
	ld	a, (hl+)
	sub	a, #0x4b
	or	a, (hl)
	jr	Z, 00102$
	ld	hl, #_enemyHealth
	ld	a, (hl+)
	sub	a, #0x64
	or	a, (hl)
	jr	NZ, 00106$
;main.c:238: set_win_tiles(15, 0, 5, 1, windowEnemyMetric100);
	ld	de, #_windowEnemyMetric100
	push	de
	ld	hl, #0x105
	push	hl
	ld	hl, #0x0f
	push	hl
	call	_set_win_tiles
	add	sp, #6
;main.c:239: break;
	jr	00106$
;main.c:240: case 75:
00102$:
;main.c:241: set_win_tiles(15, 0, 4, 1, windowEnemyMetric75);
	ld	de, #_windowEnemyMetric75
	push	de
	ld	hl, #0x104
	push	hl
	ld	hl, #0x0f
	push	hl
	call	_set_win_tiles
	add	sp, #6
;main.c:242: break;
	jr	00106$
;main.c:243: case 50:
00103$:
;main.c:244: set_win_tiles(15, 0, 4, 1, windowEnemyMetric50);
	ld	de, #_windowEnemyMetric50
	push	de
	ld	hl, #0x104
	push	hl
	ld	hl, #0x0f
	push	hl
	call	_set_win_tiles
	add	sp, #6
;main.c:245: break;
	jr	00106$
;main.c:246: case 25:
00104$:
;main.c:247: set_win_tiles(15, 0, 4, 1, windowEnemyMetric25);
	ld	de, #_windowEnemyMetric25
	push	de
	ld	hl, #0x104
	push	hl
	ld	hl, #0x0f
	push	hl
	call	_set_win_tiles
	add	sp, #6
;main.c:249: }
00106$:
;main.c:250: }
	add	sp, #5
	ret
;main.c:253: void handle_hero_collision() {
;	---------------------------------
; Function handle_hero_collision
; ---------------------------------
_handle_hero_collision::
	add	sp, #-4
;main.c:254: if (hitCooldown > 0) {
	ld	hl, #_hitCooldown
	ld	a, (hl)
	or	a, a
	jr	Z, 00102$
;main.c:255: hitCooldown--;
	dec	(hl)
;main.c:256: return;
	jp	00110$
00102$:
;main.c:260: if (enemy_x > hero_x - 10 && enemy_x < hero_x + 10 &&
	ld	hl, #_hero_x
	ld	c, (hl)
	ld	b, #0x00
	ld	de, #0x000a
	ld	a, c
	sub	a, e
	ld	e, a
	ld	a, b
	sbc	a, d
	ldhl	sp,	#1
	ld	(hl-), a
	ld	(hl), e
	ld	a, (#_enemy_x)
	ldhl	sp,	#2
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#0
	ld	e, l
	ld	d, h
	ldhl	sp,	#2
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	ld	a, (de)
	ld	d, a
	bit	7, (hl)
	jr	Z, 00154$
	bit	7, d
	jr	NZ, 00155$
	cp	a, a
	jr	00155$
00154$:
	bit	7, d
	jr	Z, 00155$
	scf
00155$:
	jp	NC, 00110$
	ld	hl, #0x000a
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 00156$
	bit	7, d
	jr	NZ, 00157$
	cp	a, a
	jr	00157$
00156$:
	bit	7, d
	jr	Z, 00157$
	scf
00157$:
	jp	NC, 00110$
;main.c:261: enemy_y > hero_y - 10 && enemy_y < hero_y + 10) {
	ld	hl, #_hero_y
	ld	c, (hl)
	ld	b, #0x00
	ld	de, #0x000a
	ld	a, c
	sub	a, e
	ld	e, a
	ld	a, b
	sbc	a, d
	ldhl	sp,	#1
	ld	(hl-), a
	ld	(hl), e
	ld	a, (#_enemy_y)
	ldhl	sp,	#2
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#0
	ld	e, l
	ld	d, h
	ldhl	sp,	#2
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	ld	a, (de)
	ld	d, a
	bit	7, (hl)
	jr	Z, 00158$
	bit	7, d
	jr	NZ, 00159$
	cp	a, a
	jr	00159$
00158$:
	bit	7, d
	jr	Z, 00159$
	scf
00159$:
	jr	NC, 00110$
	ld	hl, #0x000a
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 00160$
	bit	7, d
	jr	NZ, 00161$
	cp	a, a
	jr	00161$
00160$:
	bit	7, d
	jr	Z, 00161$
	scf
00161$:
	jr	NC, 00110$
;main.c:262: heroHealth -= 25;
	ld	hl, #_heroHealth
	ld	a, (hl)
	add	a, #0xe7
	ld	(hl), a
;main.c:263: update_health_display_hero();
	call	_update_health_display_hero
;main.c:264: hitCooldown = HIT_COOLDOWN_DURATION;
	ld	hl, #_hitCooldown
	ld	(hl), #0x05
;main.c:266: if (heroHealth == 0) {
	ld	a, (#_heroHealth)
	or	a, a
	jr	NZ, 00110$
;main.c:267: printf("Game Over press B for restart");
	ld	de, #___str_1
	push	de
	call	_printf
	pop	hl
;main.c:268: display_win = 0;
	ld	hl, #_display_win
	ld	(hl), #0x00
;main.c:269: gameOver = 1; // Définit l'état du jeu comme défaite
	ld	hl, #_gameOver
	ld	(hl), #0x01
00110$:
;main.c:272: }
	add	sp, #4
	ret
___str_1:
	.ascii "Game Over press B for restart"
	.db 0x00
;main.c:275: void update_hero_sprite() {
;	---------------------------------
; Function update_hero_sprite
; ---------------------------------
_update_hero_sprite::
	dec	sp
	dec	sp
;main.c:276: INT8 move_x = 0;
	ldhl	sp,	#0
	ld	(hl), #0x00
;main.c:277: INT8 move_y = 0;
	inc	hl
	ld	(hl), #0x00
;main.c:280: if (joypad() & J_LEFT) move_x = -8;
	call	_joypad
	bit	1, a
	jr	Z, 00102$
	ldhl	sp,	#0
	ld	(hl), #0xf8
00102$:
;main.c:281: if (joypad() & J_RIGHT) move_x = 8;
	call	_joypad
	rrca
	jr	NC, 00104$
	ldhl	sp,	#0
	ld	(hl), #0x08
00104$:
;main.c:282: if (joypad() & J_UP) move_y = -8;
	call	_joypad
	bit	2, a
	jr	Z, 00106$
	ldhl	sp,	#1
	ld	(hl), #0xf8
00106$:
;main.c:283: if (joypad() & J_DOWN) move_y = 8;
	call	_joypad
	bit	3, a
	jr	Z, 00108$
	ldhl	sp,	#1
	ld	(hl), #0x08
00108$:
;main.c:287: if ((hero_x + move_x) >= 8 && (hero_x + move_x) <= 160) {
	ld	hl, #_hero_x
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#0
	ld	a, (hl)
	ld	e, a
	rlca
	sbc	a, a
	ld	d, a
	ld	a, e
	add	a, c
	ld	c, a
	ld	a, d
	adc	a, b
	ld	b, a
	ld	a, c
	sub	a, #0x08
	ld	a, b
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	C, 00110$
	ld	e, b
	ld	d, #0x00
	ld	a, #0xa0
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	bit	7, e
	jr	Z, 00199$
	bit	7, d
	jr	NZ, 00200$
	cp	a, a
	jr	00200$
00199$:
	bit	7, d
	jr	Z, 00200$
	scf
00200$:
	jr	C, 00110$
;main.c:288: hero_x += move_x;
	ld	a, (#_hero_x)
	ldhl	sp,	#0
	add	a, (hl)
	ld	(#_hero_x),a
00110$:
;main.c:290: if ((hero_y + move_y) >= 12 && (hero_y + move_y) <= 136) {
	ld	hl, #_hero_y
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#1
	ld	a, (hl)
	ld	e, a
	rlca
	sbc	a, a
	ld	d, a
	ld	a, e
	add	a, c
	ld	c, a
	ld	a, d
	adc	a, b
	ld	b, a
	ld	a, c
	sub	a, #0x0c
	ld	a, b
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	C, 00113$
	ld	e, b
	ld	d, #0x00
	ld	a, #0x88
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	bit	7, e
	jr	Z, 00201$
	bit	7, d
	jr	NZ, 00202$
	cp	a, a
	jr	00202$
00201$:
	bit	7, d
	jr	Z, 00202$
	scf
00202$:
	jr	C, 00113$
;main.c:291: hero_y += move_y;
	ld	a, (#_hero_y)
	ldhl	sp,	#1
	add	a, (hl)
	ld	(#_hero_y),a
00113$:
;main.c:295: move_sprite(0, hero_x, hero_y);
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
;main.c:296: move_sprite(1, hero_x + 8, hero_y);
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
;main.c:297: move_sprite(2, hero_x, hero_y + 8);
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
;main.c:298: move_sprite(3, hero_x + 8, hero_y + 8);
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
;main.c:301: if (heroSpriteIndex == 0) {
	ld	a, (#_heroSpriteIndex)
	or	a, a
	jr	NZ, 00116$
;c:\gbdk\include\gb\gb.h:1875: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 2)
	ld	(hl), #0x00
	ld	hl, #(_shadow_OAM + 6)
	ld	(hl), #0x01
	ld	hl, #(_shadow_OAM + 10)
	ld	(hl), #0x02
	ld	hl, #(_shadow_OAM + 14)
	ld	(hl), #0x03
;main.c:306: heroSpriteIndex = 1;
	ld	hl, #_heroSpriteIndex
	ld	(hl), #0x01
	jr	00130$
00116$:
;c:\gbdk\include\gb\gb.h:1875: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 2)
	ld	(hl), #0x04
	ld	hl, #(_shadow_OAM + 6)
	ld	(hl), #0x05
	ld	hl, #(_shadow_OAM + 10)
	ld	(hl), #0x06
	ld	hl, #(_shadow_OAM + 14)
	ld	(hl), #0x07
;main.c:312: heroSpriteIndex = 0;
	ld	hl, #_heroSpriteIndex
	ld	(hl), #0x00
00130$:
;main.c:314: }
	inc	sp
	inc	sp
	ret
;main.c:317: void main(void) {
;	---------------------------------
; Function main
; ---------------------------------
_main::
;main.c:319: STAT_REG = 0x45;
	ld	a, #0x45
	ldh	(_STAT_REG + 0), a
;main.c:320: LYC_REG = 0x08;
	ld	a, #0x08
	ldh	(_LYC_REG + 0), a
;c:\gbdk\include\gb\gb.h:799: __asm__("di");
	di
;main.c:322: font_init();
	call	_font_init
;main.c:323: min_font = font_load(font_min);
	ld	de, #_font_min
	push	de
	call	_font_load
	pop	hl
;main.c:324: font_set(min_font);
	push	de
	call	_font_set
	pop	hl
;main.c:327: set_win_tiles(0, 0, 5, 1, windowHeroMetric100); // Tuiles pour le héros
	ld	de, #_windowHeroMetric100
	push	de
	ld	hl, #0x105
	push	hl
	xor	a, a
	rrca
	push	af
	call	_set_win_tiles
	add	sp, #6
;main.c:329: set_win_tiles(15, 0, 5, 1, windowEnemyMetric100); // Tuiles pour l'ennemi
	ld	de, #_windowEnemyMetric100
	push	de
	ld	hl, #0x105
	push	hl
	ld	hl, #0x0f
	push	hl
	call	_set_win_tiles
	add	sp, #6
;c:\gbdk\include\gb\gb.h:1727: WX_REG=x, WY_REG=y;
	ld	a, #0x07
	ldh	(_WX_REG + 0), a
	ld	a, #0x82
	ldh	(_WY_REG + 0), a
;main.c:332: SHOW_WIN;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x20
	ldh	(_LCDC_REG + 0), a
;main.c:333: DISPLAY_ON;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;main.c:335: add_LCD(interruptLCD);
	ld	de, #_interruptLCD
	call	_add_LCD
;c:\gbdk\include\gb\gb.h:783: __asm__("ei");
	ei
;main.c:337: set_interrupts(VBL_IFLAG | LCD_IFLAG);
	ld	a, #0x03
	call	_set_interrupts
;main.c:339: set_sprite_data(0, 8, hero);
	ld	de, #_hero
	push	de
	ld	hl, #0x800
	push	hl
	call	_set_sprite_data
	add	sp, #4
;main.c:340: set_sprite_data(8, 8, enemy);
	ld	de, #_enemy
	push	de
	ld	hl, #0x808
	push	hl
	call	_set_sprite_data
	add	sp, #4
;main.c:341: set_sprite_data(16, 2, bullet);
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
;main.c:343: initialize_bullets();
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
;main.c:350: move_sprite(4, enemy_x, enemy_y);
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
;main.c:351: move_sprite(5, enemy_x + 8, enemy_y);
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
;main.c:352: move_sprite(6, enemy_x, enemy_y + 8);
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
;main.c:353: move_sprite(7, enemy_x + 8, enemy_y + 8);
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
;main.c:355: move_sprite(0, hero_x, hero_y);
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
;main.c:356: move_sprite(1, hero_x + 8, hero_y);
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
;main.c:357: move_sprite(2, hero_x, hero_y + 8);
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
;main.c:358: move_sprite(3, hero_x + 8, hero_y + 8);
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
;main.c:360: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;main.c:363: while (1) {
00107$:
;main.c:364: if (gameOver == 0) { // Si le jeu est en cours
	ld	a, (#_gameOver)
	or	a, a
	jr	NZ, 00104$
;main.c:365: update_enemy_sprite();
	call	_update_enemy_sprite
;main.c:366: update_hero_sprite();
	call	_update_hero_sprite
;main.c:367: if (joypad() & J_A) fire_bullets();
	call	_joypad
	bit	4, a
	jr	Z, 00102$
	call	_fire_bullets
00102$:
;main.c:368: update_bullets();
	call	_update_bullets
;main.c:369: handle_hero_collision();
	call	_handle_hero_collision
;main.c:370: delay(150);
	ld	de, #0x0096
	call	_delay
	jr	00107$
00104$:
;main.c:372: checkRestart(); // Vérifie si le joueur veut redémarrer
	call	_checkRestart
;main.c:375: }
	jr	00107$
	.area _CODE
	.area _INITIALIZER
__xinit__windowHeroMetric100:
	.db #0x1a	; 26
	.db #0x20	; 32
	.db #0x02	; 2
	.db #0x01	; 1
	.db #0x01	; 1
__xinit__windowHeroMetric75:
	.db #0x1a	; 26
	.db #0x20	; 32
	.db #0x08	; 8
	.db #0x06	; 6
__xinit__windowHeroMetric50:
	.db #0x1a	; 26
	.db #0x20	; 32
	.db #0x06	; 6
	.db #0x01	; 1
__xinit__windowHeroMetric25:
	.db #0x1a	; 26
	.db #0x20	; 32
	.db #0x03	; 3
	.db #0x06	; 6
__xinit__windowEnemyMetric100:
	.db #0x1a	; 26
	.db #0x20	; 32
	.db #0x02	; 2
	.db #0x01	; 1
	.db #0x01	; 1
__xinit__windowEnemyMetric75:
	.db #0x1a	; 26
	.db #0x20	; 32
	.db #0x08	; 8
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x01	; 1
__xinit__windowEnemyMetric50:
	.db #0x1a	; 26
	.db #0x20	; 32
	.db #0x06	; 6
	.db #0x01	; 1
__xinit__windowEnemyMetric25:
	.db #0x1a	; 26
	.db #0x20	; 32
	.db #0x03	; 3
	.db #0x06	; 6
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
__xinit__enemyHealth:
	.dw #0x0064
__xinit__enemyAlive:
	.db #0x01	; 1
__xinit__gameOver:
	.db #0x00	; 0
__xinit__hero_x:
	.db #0x0a	; 10
__xinit__hero_y:
	.db #0x0a	; 10
__xinit__heroSpriteIndex:
	.db #0x00	; 0
__xinit__hitCooldown:
	.db #0x00	; 0
__xinit__heroHealth:
	.db #0x64	; 100	'd'
__xinit__display_win:
	.db #0x01	; 1
	.area _CABS (ABS)
