/* dust-detector-bricklet
 * Copyright (C) 2015 Olaf Lüke <olaf@tinkerforge.com>
 *
 * dust-detector.c: Implementation of Dust Detector Bricklet messages
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

#include "dust-detector.h"

#include "bricklib/bricklet/bricklet_communication.h"
#include "bricklib/drivers/adc/adc.h"
#include "bricklib/drivers/board/sam3s/SAM3S.h"
#include "bricklib/utility/util_definitions.h"
#include "brickletlib/bricklet_entry.h"
#include "brickletlib/bricklet_simple.h"
#include "config.h"

#define SIMPLE_UNIT_DUST_DENSITY 0

const SimpleMessageProperty smp[] = {
	{SIMPLE_UNIT_DUST_DENSITY, SIMPLE_TRANSFER_VALUE, SIMPLE_DIRECTION_GET}, // TYPE_GET_DUST
	{SIMPLE_UNIT_DUST_DENSITY, SIMPLE_TRANSFER_PERIOD, SIMPLE_DIRECTION_SET}, // TYPE_SET_DUST_CALLBACK_PERIOD
	{SIMPLE_UNIT_DUST_DENSITY, SIMPLE_TRANSFER_PERIOD, SIMPLE_DIRECTION_GET}, // TYPE_GET_DUST_CALLBACK_PERIOD
	{SIMPLE_UNIT_DUST_DENSITY, SIMPLE_TRANSFER_THRESHOLD, SIMPLE_DIRECTION_SET}, // TYPE_SET_DUST_CALLBACK_THRESHOLD
	{SIMPLE_UNIT_DUST_DENSITY, SIMPLE_TRANSFER_THRESHOLD, SIMPLE_DIRECTION_GET}, // TYPE_GET_DUST_CALLBACK_THRESHOLD
	{0, SIMPLE_TRANSFER_DEBOUNCE, SIMPLE_DIRECTION_SET}, // TYPE_SET_DEBOUNCE_PERIOD
	{0, SIMPLE_TRANSFER_DEBOUNCE, SIMPLE_DIRECTION_GET}, // TYPE_GET_DEBOUNCE_PERIOD
};

const SimpleUnitProperty sup[] = {
	{NULL, SIMPLE_SIGNEDNESS_INT, FID_DUST_DENSITY, FID_DUST_DENSITY_REACHED, SIMPLE_UNIT_DUST_DENSITY}, // dust_density
};

const uint8_t smp_length = sizeof(smp);

void invocation(const ComType com, const uint8_t *data) {
	switch(((MessageHeader*)data)->fid) {
		case FID_GET_DUST_DENSITY:
		case FID_SET_DUST_DENSITY_CALLBACK_PERIOD:
		case FID_GET_DUST_DENSITY_CALLBACK_PERIOD:
		case FID_SET_DUST_DENSITY_CALLBACK_THRESHOLD:
		case FID_GET_DUST_DENSITY_CALLBACK_THRESHOLD:
		case FID_SET_DEBOUNCE_PERIOD:
		case FID_GET_DEBOUNCE_PERIOD: {
			simple_invocation(com, data);
			break;
		}

		case FID_SET_MOVING_AVERAGE: {
			set_moving_average(com, (SetMovingAverage*)data);
			break;
		}

		case FID_GET_MOVING_AVERAGE: {
			get_moving_average(com, (GetMovingAverage*)data);
			break;
		}

		default: {
			BA->com_return_error(data, sizeof(MessageHeader), MESSAGE_ERROR_CODE_NOT_SUPPORTED, com);
			break;
		}
	}
}

void constructor(void) {
	_Static_assert(sizeof(BrickContext) <= BRICKLET_CONTEXT_MAX_SIZE, "BrickContext too big");

	adc_channel_enable(BS->adc_channel);

	PIN_AD.type = PIO_INPUT;
	PIN_AD.attribute = PIO_DEFAULT;
    BA->PIO_Configure(&PIN_AD, 1);

    PIN_LED.type = PIO_OUTPUT_0;
    PIN_LED.attribute = PIO_DEFAULT;
    BA->PIO_Configure(&PIN_LED, 1);

    PIN_ENABLE.type = PIO_OUTPUT_1;
    PIN_ENABLE.attribute = PIO_DEFAULT;
    BA->PIO_Configure(&PIN_ENABLE, 1);

    PIN_TEST.type = PIO_OUTPUT_0;
    PIN_TEST.attribute = PIO_DEFAULT;
    BA->PIO_Configure(&PIN_TEST, 1);

    BC->moving_average_sum = 0;
    BC->moving_average_tick = 0;
    BC->moving_average_num = MOVING_AVERAGE_DEFAULT;
    for(uint8_t i = 0; i < MOVING_AVERAGE_MAX; i++) {
    	BC->moving_average[i] = 0;
    }

	BC->counter = 0;

	simple_constructor();
}

void destructor(void) {
	simple_destructor();

	adc_channel_disable(BS->adc_channel);
}

// 0.6V = 0mg/m^3, 3.5V = 0.5mg/m^3
// -> Resistor divider: 10/12
// -> 0.5V = 0mg/m^3, 2.916V = 0.5mg/m^3
// -> 12 bit analog
// -> 620 = 0mg/m^3, 3618 = 0.5mg/m^3
// -> 620 = 0µg/m^3, 3618 = 500µg/m^3
uint16_t analog_value_to_dust_density(uint16_t value) {
	if(value < 620) {
		return 0;
	}
	if(value > 3618) {
		return 500;
	}

	return SCALE(value, 620, 3618, 0, 500);
}

void new_dust_density(void) {
	uint16_t value = BA->adc_channel_get_data(BS->adc_channel);
	if (BC->moving_average_num == 0) {
		BC->last_value[SIMPLE_UNIT_DUST_DENSITY] = BC->value[SIMPLE_UNIT_DUST_DENSITY];
		BC->value[SIMPLE_UNIT_DUST_DENSITY] = analog_value_to_dust_density(value);
	}

	BC->moving_average_sum = BC->moving_average_sum -
	                         BC->moving_average[BC->moving_average_tick] +
	                         value;

	BC->moving_average[BC->moving_average_tick] = value;
	BC->moving_average_tick = (BC->moving_average_tick + 1) % BC->moving_average_num;

	BC->last_value[SIMPLE_UNIT_DUST_DENSITY] = BC->value[SIMPLE_UNIT_DUST_DENSITY];
	BC->value[SIMPLE_UNIT_DUST_DENSITY] =  analog_value_to_dust_density((BC->moving_average_sum + BC->moving_average_num/2)/BC->moving_average_num);
}

void set_moving_average(const ComType com, const SetMovingAverage *data) {
	BC->moving_average_num = data->average;
	if(BC->moving_average_num > MOVING_AVERAGE_MAX) {
		BC->moving_average_num = MOVING_AVERAGE_MAX;
	}

	BA->com_return_setter(com, data);
}

void get_moving_average(const ComType com, const GetMovingAverage *data) {
	GetMovingAverageReturn gmar;
	gmar.header        = data->header;
	gmar.header.length = sizeof(GetMovingAverageReturn);
	gmar.average       = BC->moving_average_num;

	BA->send_blocking_with_timeout(&gmar, sizeof(GetMovingAverageReturn), com);
}

void tick(const uint8_t tick_type) {
	simple_tick(tick_type);

	if(tick_type & TICK_TASK_TYPE_CALCULATION) {
		BC->counter += 1;
		if (BC->counter >= 10) {
//			PIN_TEST.pio->PIO_SODR = PIN_TEST.mask;
			uint32_t mode = ADC->ADC_MR;
			uint32_t channel_status = ADC->ADC_CHSR;
	
			ADC->ADC_MR = mode & ~(1<<7);
			SLEEP_MS(1);
			ADC->ADC_CHDR = 0xFFFF;
			ADC->ADC_CHER = (1 << BS->adc_channel);
			SLEEP_US(54);

			PIN_LED.pio->PIO_SODR = PIN_LED.mask;
			SLEEP_US(230);

			volatile uint32_t tmp  = ADC->ADC_CDR[BS->adc_channel];

//			PIN_TEST.pio->PIO_SODR = PIN_TEST.mask;
			adc_start_conversion();

			// Wait for 115us at most
			uint8_t i;
			for(i = 0; i < 115; i++) {
				if(adc_channel_has_new_data(BS->adc_channel)) {
					break;
				}
				SLEEP_US(1);
			}
//			PIN_TEST.pio->PIO_CODR = PIN_TEST.mask;

			PIN_LED.pio->PIO_CODR = PIN_LED.mask;
			BC->counter = 0;

			if(i < 115) {
				new_dust_density();
			}

			ADC->ADC_CHER = channel_status;
			ADC->ADC_MR = mode;
			SLEEP_MS(1);
//			PIN_TEST.pio->PIO_CODR = PIN_TEST.mask;
		}
	}
}
