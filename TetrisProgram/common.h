#ifndef COMMON_H
#define COMMON_H

//Procesor ima samo lw/sw, pa svi tipovi moraju biti 32-bitni
typedef unsigned int   byte_t;
typedef unsigned int   word_t;
typedef unsigned int   dword_t;
typedef signed int     sbyte_t;
typedef signed int     sdword_t;
typedef unsigned int   bool_t;

#define TRUE  1
#define FALSE 0
//Pocetna adresa registra + pomeraj
#define MMIO_BASE 0x08000000u

#define REG_STATUS      (MMIO_BASE + 0x00)
#define REG_VGA_CTRL    (MMIO_BASE + 0x04)
#define REG_GFX_X0      (MMIO_BASE + 0x08)
#define REG_GFX_Y0      (MMIO_BASE + 0x0C)
#define REG_GFX_X1      (MMIO_BASE + 0x10)
#define REG_GFX_Y1      (MMIO_BASE + 0x14)
#define REG_GFX_COLOR   (MMIO_BASE + 0x18)
#define REG_GFX_CMD     (MMIO_BASE + 0x1C)
#define REG_PS2_LO      (MMIO_BASE + 0x20)
#define REG_PS2_HI      (MMIO_BASE + 0x24)
#define REG_IRQ_STATUS  (MMIO_BASE + 0x28)
#define REG_IRQ_CLEAR   (MMIO_BASE + 0x2C)
#define REG_SEG7        (MMIO_BASE + 0x30)
#define REG_TIMER       (MMIO_BASE + 0x34)

//Registar za mis i PS2_HI su isti
#define REG_MOUSE_STATUS REG_PS2_HI

#define MOUSE_BTN_LEFT     0x1u
#define MOUSE_BTN_RIGHT    0x2u
#define MOUSE_BTN_MIDDLE   0x4u
#define MOUSE_BTN_MASK     0x7u
#define MOUSE_DX_SHIFT     3
#define MOUSE_DY_SHIFT     11
#define MOUSE_MOVE_MASK    0xFFu
#define MOUSE_PKT_MASK     (1u << 19)

#define STATUS_VSYNC_MASK    0x1u
#define STATUS_GFX_BUSY_MASK 0x2u


#define GFX_CMD_POINT     1
#define GFX_CMD_LINE      2
#define GFX_CMD_FILLRECT  3

// prekidi 
#define IRQ_KEYBOARD 0x1u
#define IRQ_VSYNC    0x2u

// VGA_CTRL: bit 0 zamenjuje bafere, bit 1 crta u bafer koji se prikazuje 
#define VGA_CTRL_SWAP       0x1u
#define VGA_CTRL_DRAW_FRONT 0x2u

// Memorija dovlaci vrstu od 640 piksela, pa se toliko i brise. 
#define FB_ROW_W 640

// Slika u memoriji je 400x300; VGA blok je uvecava dvostruko na 800x600.
#define SCREEN_W 400
#define SCREEN_H 300

// Velicina table za igru
#define BOARD_COLS 10
#define BOARD_ROWS 20
#define CELL_SIZE  12

// Granice  table centrirane
#define BOARD_ORIGIN_X ((SCREEN_W - BOARD_COLS * CELL_SIZE) / 2)
#define BOARD_ORIGIN_Y ((SCREEN_H - BOARD_ROWS * CELL_SIZE) / 2)

#define COLOR_BG     0x000
#define COLOR_BORDER 0x888
#define COLOR_EMPTY  0x111

   
//Figure
#define PIECE_I 0
#define PIECE_O 1
#define PIECE_T 2
#define PIECE_S 3
#define PIECE_Z 4
#define PIECE_J 5
#define PIECE_L 6
#define PIECE_COUNT 7

#endif
