/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file    app_filex.c
  * @author  MCD Application Team
  * @brief   FileX applicative file
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2021 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */

/* Includes ------------------------------------------------------------------*/
#include "app_filex.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include "main.h"
#include "sail_junior.h"

/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
/* USER CODE BEGIN PV */
/* Buffer for FileX FX_MEDIA sector cache */
uint32_t media_memory[FX_STM32_SD_DEFAULT_SECTOR_SIZE / sizeof(uint32_t)];

/* Define FileX global data structures.  */
FX_MEDIA        sdio_disk;
FX_FILE         fx_file;
/* Define ThreadX global data structures.  */
TX_THREAD       fx_app_thread;
struct sail_image *image;

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
/* USER CODE BEGIN PFP */
void fx_thread_entry(ULONG thread_input);
void Error_Handler(void);
/* USER CODE END PFP */

/**
  * @brief  Application FileX Initialization.
  * @param memory_ptr: memory pointer
  * @retval int
  */
UINT MX_FileX_Init(VOID *memory_ptr)
{
  UINT ret = FX_SUCCESS;
  TX_BYTE_POOL *byte_pool = (TX_BYTE_POOL*)memory_ptr;

  /* USER CODE BEGIN MX_FileX_MEM_POOL */

  /* USER CODE END MX_FileX_MEM_POOL */

  /* USER CODE BEGIN MX_FileX_Init */
  VOID *pointer;

  /* Allocate memory for the main thread's stack */
  ret = tx_byte_allocate(byte_pool, &pointer, DEFAULT_STACK_SIZE, TX_NO_WAIT);

  if (ret != FX_SUCCESS)
  {
    /* Failed at allocating memory */
    Error_Handler();
  }

  /* Create the main thread.  */
  tx_thread_create(&fx_app_thread, "FileX App Thread", fx_thread_entry, 0, pointer, DEFAULT_STACK_SIZE,
                   DEFAULT_THREAD_PRIO, DEFAULT_PREEMPTION_THRESHOLD, TX_NO_TIME_SLICE, TX_AUTO_START);

  /* Initialize FileX.  */
  fx_system_initialize();

  /* USER CODE END MX_FileX_Init */
  return ret;
}

/* USER CODE BEGIN 1 */

void fx_thread_entry(ULONG thread_input)
{

  UINT status;

  /* Open the SD disk driver.  */
  status =  fx_media_open(&sdio_disk, "STM32_SDIO_DISK", fx_stm32_sd_driver, 0,(VOID *) media_memory, sizeof(media_memory));

  /* Check the media open status.  */
  if (status != FX_SUCCESS)
  {
    Error_Handler();
  }

  sail_load_image_from_file("image.bmp" , &image);
  /* Loop Forever indicating success state */
  while(1)
  {
    BSP_LED_Toggle(LED_GREEN);
    tx_thread_sleep(50);
  }
}

/* USER CODE END 1 */
