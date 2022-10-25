/* adc example

   This example code is in the Public Domain (or CC0 licensed, at your option.)

   Unless required by applicable law or agreed to in writing, this
   software is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
   CONDITIONS OF ANY KIND, either express or implied.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/adc.h"
#include "driver/gpio.h"
#include "esp_log.h"

#define SENSOR 4

static const char *TAG_ADC = "adc read";
static const char *TAG_DIGITAL = "digital read";


static void adc_task()
{
    int x;
    uint16_t adc_data[100];
    
    gpio_set_direction(SENSOR, GPIO_MODE_INPUT);
    

    while (1) {
    
        if (ESP_OK == adc_read(&adc_data[0])) {
            ESP_LOGI(TAG_ADC, "adc read A0 pin: %d\r\n", adc_data[0]);
        }

        ESP_LOGI(TAG_ADC, "adc read fast:\r\n");

        if (ESP_OK == adc_read_fast(adc_data, 100)) {
        
            for (x = 0; x < 100; x++) {
                printf("%d\n", adc_data[x]);
            }
        }
        
        ESP_LOGI(TAG_DIGITAL, "digital read D2 pin:\r\n");
        
        printf("%d\n", gpio_get_level(SENSOR));
        

        vTaskDelay(3000 / portTICK_RATE_MS);
    }
}

void app_main()
{
    // 1. init adc
    adc_config_t adc_config;

    // Depend on menuconfig->Component config->PHY->vdd33_const value
    // When measuring system voltage(ADC_READ_VDD_MODE), vdd33_const must be set to 255.
    adc_config.mode = ADC_READ_TOUT_MODE;
    adc_config.clk_div = 8; // ADC sample collection clock = 80MHz/clk_div = 10MHz
    ESP_ERROR_CHECK(adc_init(&adc_config));

    // 2. Create a adc task to read adc value
    xTaskCreate(adc_task, "adc_task", 1024, NULL, 5, NULL);
}