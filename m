Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42704C07E95
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 07:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 260D861CAA
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 07:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhGGHkn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 03:40:43 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:39397 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230349AbhGGHkm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Jul 2021 03:40:42 -0400
Received: from [192.168.0.3] (ip5f5aedf7.dynamic.kabel-deutschland.de [95.90.237.247])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 4BD5261E64860;
        Wed,  7 Jul 2021 09:38:01 +0200 (CEST)
Subject: Re: [smartpqi updates PATCH 6/9] smartpqi: add PCI-ID for new Norsi
 controller
To:     Don Brace <don.brace@microchip.com>, hch@infradead.org,
        martin.peterson@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Cc:     Kevin.Barnett@microchip.com, scott.teel@microchip.com,
        Justin.Lindley@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        mike.mcgowen@microchip.com, murthy.bhat@microchip.com,
        balsundar.p@microchip.com, joseph.szczypek@hpe.com,
        jeff@canonical.com, POSWALD@suse.com, john.p.donnelly@oracle.com,
        mwilck@suse.com, linux-kernel@vger.kernel.org
References: <20210706181618.27960-1-don.brace@microchip.com>
 <20210706181618.27960-7-don.brace@microchip.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <acaaf271-10dd-6dee-0d47-77d00e794103@molgen.mpg.de>
Date:   Wed, 7 Jul 2021 09:38:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706181618.27960-7-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear Don, dear Mike,


Am 06.07.21 um 20:16 schrieb Don Brace:
> From: Mike McGowen <mike.mcgowen@microchip.com>

Can you please mention the device ID and name in the git commit message, 
so it can be compared to the code change? See *[smartpqi updates PATCH 
1/9] smartpqi: add pci id for H3C controller* as an example.


Kind regards,

Paul


> Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Mike McGowen <mike.mcgowen@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>
> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index 1195e70b6ec3..a8dfb6101830 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -9178,6 +9178,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
>   		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
>   			       PCI_VENDOR_ID_GIGABYTE, 0x1000)
>   	},
> +	{
> +		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
> +			       0x1dfc, 0x3161)
> +	},
>   	{
>   		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
>   			       PCI_ANY_ID, PCI_ANY_ID)
> 
