/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'nios2_qsys_0' in SOPC Builder design 'nios_led'
 * SOPC Builder design path: C:/altera/13.0sp1/nios_led/nios_led.sopcinfo
 *
 * Generated: Mon Apr 27 18:37:56 IDT 2020
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_qsys"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x8820
#define ALT_CPU_CPU_FREQ 50000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000000
#define ALT_CPU_CPU_IMPLEMENTATION "tiny"
#define ALT_CPU_DATA_ADDR_WIDTH 0x10
#define ALT_CPU_DCACHE_LINE_SIZE 0
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_DCACHE_SIZE 0
#define ALT_CPU_EXCEPTION_ADDR 0x4020
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 50000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 0
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 0
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_ICACHE_SIZE 0
#define ALT_CPU_INST_ADDR_WIDTH 0x10
#define ALT_CPU_NAME "nios2_qsys_0"
#define ALT_CPU_RESET_ADDR 0x4000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x8820
#define NIOS2_CPU_FREQ 50000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000000
#define NIOS2_CPU_IMPLEMENTATION "tiny"
#define NIOS2_DATA_ADDR_WIDTH 0x10
#define NIOS2_DCACHE_LINE_SIZE 0
#define NIOS2_DCACHE_LINE_SIZE_LOG2 0
#define NIOS2_DCACHE_SIZE 0
#define NIOS2_EXCEPTION_ADDR 0x4020
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 0
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 0
#define NIOS2_ICACHE_LINE_SIZE_LOG2 0
#define NIOS2_ICACHE_SIZE 0
#define NIOS2_INST_ADDR_WIDTH 0x10
#define NIOS2_RESET_ADDR 0x4000


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_ONCHIP_MEMORY2
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_UART
#define __ALTERA_NIOS2_QSYS


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "Cyclone II"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/rs232"
#define ALT_STDERR_BASE 0x9000
#define ALT_STDERR_DEV rs232
#define ALT_STDERR_IS_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_uart"
#define ALT_STDIN "/dev/rs232"
#define ALT_STDIN_BASE 0x9000
#define ALT_STDIN_DEV rs232
#define ALT_STDIN_IS_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_uart"
#define ALT_STDOUT "/dev/rs232"
#define ALT_STDOUT_BASE 0x9000
#define ALT_STDOUT_DEV rs232
#define ALT_STDOUT_IS_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_uart"
#define ALT_SYSTEM_NAME "nios_led"


/*
 * bus1 configuration
 *
 */

#define ALT_MODULE_CLASS_bus1 altera_avalon_pio
#define BUS1_BASE 0x9020
#define BUS1_BIT_CLEARING_EDGE_REGISTER 0
#define BUS1_BIT_MODIFYING_OUTPUT_REGISTER 0
#define BUS1_CAPTURE 0
#define BUS1_DATA_WIDTH 8
#define BUS1_DO_TEST_BENCH_WIRING 0
#define BUS1_DRIVEN_SIM_VALUE 0x0
#define BUS1_EDGE_TYPE "NONE"
#define BUS1_FREQ 50000000u
#define BUS1_HAS_IN 0
#define BUS1_HAS_OUT 1
#define BUS1_HAS_TRI 0
#define BUS1_IRQ -1
#define BUS1_IRQ_INTERRUPT_CONTROLLER_ID -1
#define BUS1_IRQ_TYPE "NONE"
#define BUS1_NAME "/dev/bus1"
#define BUS1_RESET_VALUE 0x0
#define BUS1_SPAN 16
#define BUS1_TYPE "altera_avalon_pio"


/*
 * bus2 configuration
 *
 */

#define ALT_MODULE_CLASS_bus2 altera_avalon_pio
#define BUS2_BASE 0x9030
#define BUS2_BIT_CLEARING_EDGE_REGISTER 0
#define BUS2_BIT_MODIFYING_OUTPUT_REGISTER 0
#define BUS2_CAPTURE 0
#define BUS2_DATA_WIDTH 8
#define BUS2_DO_TEST_BENCH_WIRING 0
#define BUS2_DRIVEN_SIM_VALUE 0x0
#define BUS2_EDGE_TYPE "NONE"
#define BUS2_FREQ 50000000u
#define BUS2_HAS_IN 0
#define BUS2_HAS_OUT 1
#define BUS2_HAS_TRI 0
#define BUS2_IRQ -1
#define BUS2_IRQ_INTERRUPT_CONTROLLER_ID -1
#define BUS2_IRQ_TYPE "NONE"
#define BUS2_NAME "/dev/bus2"
#define BUS2_RESET_VALUE 0x0
#define BUS2_SPAN 16
#define BUS2_TYPE "altera_avalon_pio"


/*
 * bus3 configuration
 *
 */

#define ALT_MODULE_CLASS_bus3 altera_avalon_pio
#define BUS3_BASE 0x9040
#define BUS3_BIT_CLEARING_EDGE_REGISTER 0
#define BUS3_BIT_MODIFYING_OUTPUT_REGISTER 0
#define BUS3_CAPTURE 0
#define BUS3_DATA_WIDTH 8
#define BUS3_DO_TEST_BENCH_WIRING 0
#define BUS3_DRIVEN_SIM_VALUE 0x0
#define BUS3_EDGE_TYPE "NONE"
#define BUS3_FREQ 50000000u
#define BUS3_HAS_IN 0
#define BUS3_HAS_OUT 1
#define BUS3_HAS_TRI 0
#define BUS3_IRQ -1
#define BUS3_IRQ_INTERRUPT_CONTROLLER_ID -1
#define BUS3_IRQ_TYPE "NONE"
#define BUS3_NAME "/dev/bus3"
#define BUS3_RESET_VALUE 0x0
#define BUS3_SPAN 16
#define BUS3_TYPE "altera_avalon_pio"


/*
 * hal configuration
 *
 */

#define ALT_MAX_FD 4
#define ALT_SYS_CLK none
#define ALT_TIMESTAMP_CLK none


/*
 * onchip_memory2_0 configuration
 *
 */

#define ALT_MODULE_CLASS_onchip_memory2_0 altera_avalon_onchip_memory2
#define ONCHIP_MEMORY2_0_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define ONCHIP_MEMORY2_0_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define ONCHIP_MEMORY2_0_BASE 0x4000
#define ONCHIP_MEMORY2_0_CONTENTS_INFO ""
#define ONCHIP_MEMORY2_0_DUAL_PORT 0
#define ONCHIP_MEMORY2_0_GUI_RAM_BLOCK_TYPE "Automatic"
#define ONCHIP_MEMORY2_0_INIT_CONTENTS_FILE "onchip_memory2_0"
#define ONCHIP_MEMORY2_0_INIT_MEM_CONTENT 1
#define ONCHIP_MEMORY2_0_INSTANCE_ID "NONE"
#define ONCHIP_MEMORY2_0_IRQ -1
#define ONCHIP_MEMORY2_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ONCHIP_MEMORY2_0_NAME "/dev/onchip_memory2_0"
#define ONCHIP_MEMORY2_0_NON_DEFAULT_INIT_FILE_ENABLED 0
#define ONCHIP_MEMORY2_0_RAM_BLOCK_TYPE "Auto"
#define ONCHIP_MEMORY2_0_READ_DURING_WRITE_MODE "DONT_CARE"
#define ONCHIP_MEMORY2_0_SINGLE_CLOCK_OP 0
#define ONCHIP_MEMORY2_0_SIZE_MULTIPLE 1
#define ONCHIP_MEMORY2_0_SIZE_VALUE 16384u
#define ONCHIP_MEMORY2_0_SPAN 16384
#define ONCHIP_MEMORY2_0_TYPE "altera_avalon_onchip_memory2"
#define ONCHIP_MEMORY2_0_WRITABLE 1


/*
 * rs232 configuration
 *
 */

#define ALT_MODULE_CLASS_rs232 altera_avalon_uart
#define RS232_BASE 0x9000
#define RS232_BAUD 115200
#define RS232_DATA_BITS 8
#define RS232_FIXED_BAUD 1
#define RS232_FREQ 50000000u
#define RS232_IRQ 0
#define RS232_IRQ_INTERRUPT_CONTROLLER_ID 0
#define RS232_NAME "/dev/rs232"
#define RS232_PARITY 'N'
#define RS232_SIM_CHAR_STREAM ""
#define RS232_SIM_TRUE_BAUD 0
#define RS232_SPAN 32
#define RS232_STOP_BITS 1
#define RS232_SYNC_REG_DEPTH 2
#define RS232_TYPE "altera_avalon_uart"
#define RS232_USE_CTS_RTS 0
#define RS232_USE_EOP_REGISTER 0

#endif /* __SYSTEM_H_ */
