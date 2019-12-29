Return-Path: <SRS0=ggzA=2T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D64C2D0C6
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Dec 2019 11:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72D5F20722
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Dec 2019 11:52:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfL2LwN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Dec 2019 06:52:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:50568 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbfL2LwN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 29 Dec 2019 06:52:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6424DAD22;
        Sun, 29 Dec 2019 11:52:11 +0000 (UTC)
Subject: Re: [PATCH 1/2] scsi: mylex: Use the correct style for SPDX License
 Identifier
To:     Nishad Kamdar <nishadkamdar@gmail.com>,
        Hannes Reinecke <hare@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1577511720.git.nishadkamdar@gmail.com>
 <88332ad390f985bdebb9f2adaf2d499b0a639753.1577511720.git.nishadkamdar@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9f811041-263d-269a-39f9-6ea3be10eff0@suse.de>
Date:   Sun, 29 Dec 2019 12:52:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <88332ad390f985bdebb9f2adaf2d499b0a639753.1577511720.git.nishadkamdar@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/28/19 6:55 AM, Nishad Kamdar wrote:
> This patch corrects the SPDX License Identifier style in
> header files related to Mylex DAC960/DAC1100 PCI RAID
> Controllers. It assigns explicit block comment to the
> SPDX License Identifier.
> 
> Changes made by using a script provided by Joe Perches here:
> https://lkml.org/lkml/2019/2/7/46.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
> ---
>   drivers/scsi/myrb.h | 4 ++--
>   drivers/scsi/myrs.h | 4 ++--
>   2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/myrb.h b/drivers/scsi/myrb.h
> index 9289c19fcb2f..fb8eacfceee8 100644
> --- a/drivers/scsi/myrb.h
> +++ b/drivers/scsi/myrb.h
> @@ -1,5 +1,5 @@
> -/* SPDX-License-Identifier: GPL-2.0
> - *
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
>    * Linux Driver for Mylex DAC960/AcceleRAID/eXtremeRAID PCI RAID Controllers
>    *
>    * Copyright 2017 Hannes Reinecke, SUSE Linux GmbH <hare@suse.com>
> diff --git a/drivers/scsi/myrs.h b/drivers/scsi/myrs.h
> index e6702ee85e9f..9f6696d0ddd5 100644
> --- a/drivers/scsi/myrs.h
> +++ b/drivers/scsi/myrs.h
> @@ -1,5 +1,5 @@
> -/* SPDX-License-Identifier: GPL-2.0
> - *
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
>    * Linux Driver for Mylex DAC960/AcceleRAID/eXtremeRAID PCI RAID Controllers
>    *
>    * This driver supports the newer, SCSI-based firmware interface only.
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
