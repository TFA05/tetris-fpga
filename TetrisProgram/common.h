#ifndef COMMON_H
#define COMMON_H

typedef unsigned char  byte_t;
typedef unsigned short word_t;
typedef unsigned int   dword_t;
typedef signed char    sbyte_t;
typedef signed int     sdword_t;
typedef byte_t         bool_t;

#define TRUE  1
#define FALSE 0

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

#define REG_MOUSE_STATUS (MMIO_BASE + 0x38)

#define MOUSE_ACKED_MASK   0x1u
#define MOUSE_BUTTON_MASK  0x6u
#define MOUSE_CHANGED_MASK 0x8u
#define MOUSE_COORD_MASK   0x3FFu

#define STATUS_VSYNC_MASK    0x1u
#define STATUS_GFX_BUSY_MASK 0x2u

#define GFX_CMD_POINT     0
#define GFX_CMD_LINE      1
#define GFX_CMD_RECT      2
#define GFX_CMD_FILLRECT  3

#define SCREEN_W 800
#define SCREEN_H 600

#define BOARD_COLS 10
#define BOARD_ROWS 20
#define CELL_SIZE  20

#define BOARD_ORIGIN_X ((SCREEN_W - BOARD_COLS * CELL_SIZE) / 2)
#define BOARD_ORIGIN_Y ((SCREEN_H - BOARD_ROWS * CELL_SIZE) / 2)

#define COLOR_BG     0x000
#define COLOR_BORDER 0x888
#define COLOR_EMPTY  0x111

#define PIECE_I 0
#define PIECE_O 1
#define PIECE_T 2
#define PIECE_S 3
#define PIECE_Z 4
#define PIECE_J 5
#define PIECE_L 6
#define PIECE_COUNT 7

#endif
