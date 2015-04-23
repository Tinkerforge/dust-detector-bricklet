/* dust-detector-bricklet
 * Copyright (C) 2015 Olaf Lüke <olaf@tinkerforge.com>
 *
 * dust-detector.h: Implementation of Dust Detector Bricklet messages
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#ifndef DUST_DETECTOR_H
#define DUST_DETECTOR_H

#include <stdint.h>
#include "bricklib/com/com_common.h"

#define MOVING_AVERAGE_DEFAULT 100
#define MOVING_AVERAGE_MAX 100

#define FID_GET_DUST_DENSITY 1
#define FID_SET_DUST_DENSITY_CALLBACK_PERIOD 2
#define FID_GET_DUST_DENSITY_CALLBACK_PERIOD 3
#define FID_SET_DUST_DENSITY_CALLBACK_THRESHOLD 4
#define FID_GET_DUST_DENSITY_CALLBACK_THRESHOLD 5
#define FID_SET_DEBOUNCE_PERIOD 6
#define FID_GET_DEBOUNCE_PERIOD 7
#define FID_DUST_DENSITY 8
#define FID_DUST_DENSITY_REACHED 9
#define FID_SET_MOVING_AVERAGE 10
#define FID_GET_MOVING_AVERAGE 11

typedef struct {
	MessageHeader header;
} __attribute__((__packed__)) StandardMessage;

typedef struct {
	MessageHeader header;
	uint8_t average;
} __attribute__((__packed__)) SetMovingAverage;

typedef struct {
	MessageHeader header;
} __attribute__((__packed__)) GetMovingAverage;

typedef struct {
	MessageHeader header;
	uint8_t average;
} __attribute__((__packed__)) GetMovingAverageReturn;

void set_moving_average(const ComType com, const SetMovingAverage *data);
void get_moving_average(const ComType com, const GetMovingAverage *data);

void invocation(const ComType com, const uint8_t *data);
void constructor(void);
void destructor(void);
void tick(const uint8_t tick_type);

#endif
