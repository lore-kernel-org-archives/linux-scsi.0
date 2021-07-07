Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 275F5C07E9E
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 07:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 121AE61C92
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 07:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhGGHhv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 03:37:51 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:52797 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230480AbhGGHhu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Jul 2021 03:37:50 -0400
Received: from [192.168.0.3] (ip5f5aedf7.dynamic.kabel-deutschland.de [95.90.237.247])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id CD56761E64860;
        Wed,  7 Jul 2021 09:35:09 +0200 (CEST)
Subject: Re: [smartpqi updates PATCH 3/9] smartpqi: update copyright notices
To:     Don Brace <don.brace@microchip.com>,
        Kevin Barnett <kevin.barnett@microchip.com>
Cc:     scott.teel@microchip.com, Justin.Lindley@microchip.com,
        scott.benesh@microchip.com, gerry.morong@microchip.com,
        mahesh.rajashekhara@microchip.com, mike.mcgowen@microchip.com,
        murthy.bhat@microchip.com, balsundar.p@microchip.com,
        joseph.szczypek@hpe.com, jeff@canonical.com, POSWALD@suse.com,
        john.p.donnelly@oracle.com, mwilck@suse.com,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        martin.peterson@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
References: <20210706181618.27960-1-don.brace@microchip.com>
 <20210706181618.27960-4-don.brace@microchip.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <274bef24-bbcd-7edd-140f-38e662f67199@molgen.mpg.de>
Date:   Wed, 7 Jul 2021 09:35:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706181618.27960-4-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear Kevin, dear Don,


Am 06.07.21 um 20:16 schrieb Don Brace:
> From: Kevin Barnett <kevin.barnett@microchip.com>
> 
> Updated copyright notices and company name strings to reflect

… from Microsemi to Microchip …

> Microchip ownership.

You also change the driver name. Maybe do that in a separate commit with 
a dedicated commit messages summary.

Name changes affecting strings showing up in log messages are always 
confusing for people’s muscle memory. No idea, if it’d be better to 
include both names in the driver name until the next Linux LTS series is 
released.


Kind regards,

Paul


> Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>
> ---
>   drivers/scsi/smartpqi/smartpqi.h               |  6 +++---
>   drivers/scsi/smartpqi/smartpqi_init.c          | 12 ++++++------
>   drivers/scsi/smartpqi/smartpqi_sas_transport.c |  4 ++--
>   drivers/scsi/smartpqi/smartpqi_sis.c           |  4 ++--
>   drivers/scsi/smartpqi/smartpqi_sis.h           |  4 ++--
>   5 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
> index d7dac5572274..f340afc011b5 100644
> --- a/drivers/scsi/smartpqi/smartpqi.h
> +++ b/drivers/scsi/smartpqi/smartpqi.h
> @@ -1,7 +1,7 @@
>   /* SPDX-License-Identifier: GPL-2.0 */
>   /*
> - *    driver for Microsemi PQI-based storage controllers
> - *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
> + *    driver for Microchip PQI-based storage controllers
> + *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
>    *    Copyright (c) 2016-2018 Microsemi Corporation
>    *    Copyright (c) 2016 PMC-Sierra, Inc.
>    *
> @@ -59,7 +59,7 @@ struct pqi_device_registers {
>   /*
>    * controller registers
>    *
> - * These are defined by the Microsemi implementation.
> + * These are defined by the Microchip implementation.
>    *
>    * Some registers (those named sis_*) are only used when in
>    * legacy SIS mode before we transition the controller into
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index 7958316841a4..5ce1c41a758d 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -1,7 +1,7 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /*
> - *    driver for Microsemi PQI-based storage controllers
> - *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
> + *    driver for Microchip PQI-based storage controllers
> + *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
>    *    Copyright (c) 2016-2018 Microsemi Corporation
>    *    Copyright (c) 2016 PMC-Sierra, Inc.
>    *
> @@ -39,7 +39,7 @@
>   #define DRIVER_RELEASE		8
>   #define DRIVER_REVISION		45
>   
> -#define DRIVER_NAME		"Microsemi PQI Driver (v" \
> +#define DRIVER_NAME		"Microchip SmartPQI Driver (v" \
>   				DRIVER_VERSION BUILD_TIMESTAMP ")"
>   #define DRIVER_NAME_SHORT	"smartpqi"
>   
> @@ -48,8 +48,8 @@
>   #define PQI_POST_RESET_DELAY_SECS			5
>   #define PQI_POST_OFA_RESET_DELAY_UPON_TIMEOUT_SECS	10
>   
> -MODULE_AUTHOR("Microsemi");
> -MODULE_DESCRIPTION("Driver for Microsemi Smart Family Controller version "
> +MODULE_AUTHOR("Microchip");
> +MODULE_DESCRIPTION("Driver for Microchip Smart Family Controller version "
>   	DRIVER_VERSION);
>   MODULE_VERSION(DRIVER_VERSION);
>   MODULE_LICENSE("GPL");
> @@ -8448,7 +8448,7 @@ static void pqi_print_ctrl_info(struct pci_dev *pci_dev,
>   	if (id->driver_data)
>   		ctrl_description = (char *)id->driver_data;
>   	else
> -		ctrl_description = "Microsemi Smart Family Controller";
> +		ctrl_description = "Microchip Smart Family Controller";
>   
>   	dev_info(&pci_dev->dev, "%s found\n", ctrl_description);
>   }
> diff --git a/drivers/scsi/smartpqi/smartpqi_sas_transport.c b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
> index dd628cc87f78..afd9bafebd1d 100644
> --- a/drivers/scsi/smartpqi/smartpqi_sas_transport.c
> +++ b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
> @@ -1,7 +1,7 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /*
> - *    driver for Microsemi PQI-based storage controllers
> - *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
> + *    driver for Microchip PQI-based storage controllers
> + *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
>    *    Copyright (c) 2016-2018 Microsemi Corporation
>    *    Copyright (c) 2016 PMC-Sierra, Inc.
>    *
> diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
> index c954620628e0..d63c46a8e38b 100644
> --- a/drivers/scsi/smartpqi/smartpqi_sis.c
> +++ b/drivers/scsi/smartpqi/smartpqi_sis.c
> @@ -1,7 +1,7 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /*
> - *    driver for Microsemi PQI-based storage controllers
> - *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
> + *    driver for Microchip PQI-based storage controllers
> + *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
>    *    Copyright (c) 2016-2018 Microsemi Corporation
>    *    Copyright (c) 2016 PMC-Sierra, Inc.
>    *
> diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
> index 12cd2ab1aead..d29c1352a826 100644
> --- a/drivers/scsi/smartpqi/smartpqi_sis.h
> +++ b/drivers/scsi/smartpqi/smartpqi_sis.h
> @@ -1,7 +1,7 @@
>   /* SPDX-License-Identifier: GPL-2.0 */
>   /*
> - *    driver for Microsemi PQI-based storage controllers
> - *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
> + *    driver for Microchip PQI-based storage controllers
> + *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
>    *    Copyright (c) 2016-2018 Microsemi Corporation
>    *    Copyright (c) 2016 PMC-Sierra, Inc.
>    *
> 
