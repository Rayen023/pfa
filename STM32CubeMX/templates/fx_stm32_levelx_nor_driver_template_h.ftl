[#ftl]
/**************************************************************************/
/*                                                                        */
/*       Copyright (c) Microsoft Corporation. All rights reserved.        */
/*                                                                        */
/*       This software is licensed under the Microsoft Software License   */
/*       Terms for Microsoft Azure RTOS. Full text of the license can be  */
/*       found in the LICENSE file at https://aka.ms/AzureRTOS_EULA       */
/*       and in the root directory of this software.                      */
/*                                                                        */
/**************************************************************************/

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef FX_STM32_LX_NOR_DRIVER_H
#define FX_STM32_LX_NOR_DRIVER_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "fx_api.h"
#include "lx_api.h"

/* enable the driver to be used */

[#assign  nor_custom_drv_id = "0xBBBB"]

[#if RTEdatas??]
[#list RTEdatas as define]
[#if define?contains("LX_NOR_SIMULATOR_DRIVER")]
#define LX_NOR_SIMULATOR_DRIVER
[/#if]
[#if define?contains("LX_NOR_QSPI_DRIVER")]
#define LX_NOR_QSPI_DRIVER
[/#if]
[#if define?contains("LX_NOR_USE_CUSTOM_DRIVER")]
#define LX_NOR_CUSTOM_DRIVER
[#compress]
[#list SWIPdatas as SWIP]
[#if SWIP.defines??]
  [#list SWIP.defines as definition]
    [#assign value = definition.value]
    [#assign name = definition.name]

    [#if name == "FX_LX_NOR_CUSTOM_DRIVER_ID"]
      [#assign nor_custom_drv_id = value]
    [/#if]

    [/#list]
[/#if]
[/#list]
[/#compress]
[/#if]
[/#list]
[/#if]

#ifdef LX_NOR_SIMULATOR_DRIVER
#include "lx_stm32_nor_simulator_driver.h"

#define LX_NOR_SIMULATOR_DRIVER_ID        0x01
#define LX_NOR_SIMULATOR_DRIVER_NAME      "FX Levelx NOR flash Simulator"
#endif

#ifdef LX_NOR_QSPI_DRIVER
#include "lx_stm32_qspi_driver.h"

#define LX_NOR_QSPI_DRIVER_ID           0x03
#define LX_NOR_QSPI_DRIVER_NAME         "FX Levelx QuadSPI driver"
#endif

#ifdef LX_NOR_CUSTOM_DRIVER
/*
 * define the Custom levelx nor drivers to be supported by the filex
 *  for example:
*/
#define CUSTOM_DRIVER_ID          ${nor_custom_drv_id}
#define NOR_CUSTOM_DRIVER_NAME    "NOR CUSTOM DRIVER"
#include "lx_stm32_nor_custom_driver.h"
#define LX_NOR_CUSTOM_DRIVERS   {.name = "NOR CUSTOM DRIVER", .id = CUSTOM_DRIVER_ID, .nor_driver_initialize = lx_stm32_nor_custom_driver_initialize}

/* USER CODE BEIGN NOR_CUSTOM_DRIVERS */

/* USER CODE END NOR_CUSTOM_DRIVERS */

#endif

#define MAX_LX_NOR_DRIVERS     8
#define UNKNOWN_DRIVER_ID      0xFFFFFFFF


/* to enable a default NOR driver:
  - define the flags LX_NOR_DEFAULT_DRIVER
  - Provide the driver ID in the NOR_DEFAULT_DRIVER for example
  #define NOR_DEFAULT_DRIVER LX_NOR_QSPI_DRIVER_ID
*/


/* USER CODE BEGIN DEFAULT_DRIVER */

/* USER CODE END DEFAULT_DRIVER */

#ifdef LX_NOR_DEFAULT_DRIVER

/* USER CODE BEGIN DEFAULT_DRIVER */

/* USER CODE END DEFAULT_DRIVER */
#endif

#if !defined(NOR_DEFAULT_DRIVER) && !defined(LX_NOR_CUSTOM_DRIVERS) && !defined(LX_NOR_SIMULATOR_DRIVER) && !defined(LX_NOR_QSPI_DRIVER)
#error "[This error was thrown on purpose] : No NOR lowlevel driver defined"
#endif

/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Exported types ------------------------------------------------------------*/
/* USER CODE BEGIN ET */

/* USER CODE END ET */

/* Exported constants --------------------------------------------------------*/



/* USER CODE BEGIN EC */

/* USER CODE END EC */

/* Exported macro ------------------------------------------------------------*/
/* USER CODE BEGIN EM */

/* USER CODE END EM */

/* Exported functions prototypes ---------------------------------------------*/
VOID  fx_stm32_levelx_nor_driver(FX_MEDIA *media_ptr);

/* USER CODE BEGIN EFP */

/* USER CODE END EFP */

/* Private defines -----------------------------------------------------------*/
/* USER CODE BEGIN PD */

/* USER CODE END PD */

/* USER CODE BEGIN 1 */

/* USER CODE END 1 */

#ifdef __cplusplus
}
#endif

#endif /*FX_STM32_LX_NOR_DRIVER_H*/
