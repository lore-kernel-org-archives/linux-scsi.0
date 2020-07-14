Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33EF2C433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 06:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19C06221E8
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 06:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgGNGuM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 02:50:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:56872 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgGNGuM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 02:50:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BCF68AEB2;
        Tue, 14 Jul 2020 06:50:12 +0000 (UTC)
Subject: Re: [PATCH v2 03/29] scsi: libfc: fc_disc: trivial: Fix spelling
 mistake of 'discovery'
To:     Lee Jones <lee.jones@linaro.org>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
References: <20200713074645.126138-1-lee.jones@linaro.org>
 <20200713074645.126138-4-lee.jones@linaro.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <3c643742-4fad-adfc-0f4d-703c80cd191f@suse.de>
Date:   Tue, 14 Jul 2020 08:50:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200713074645.126138-4-lee.jones@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/20 9:46 AM, Lee Jones wrote:
> This is my fault (can't even blame copy/paste).
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Reported-by: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/scsi/libfc/fc_disc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
> index 428f40cfd1c36..19721db232839 100644
> --- a/drivers/scsi/libfc/fc_disc.c
> +++ b/drivers/scsi/libfc/fc_disc.c
> @@ -370,7 +370,7 @@ static void fc_disc_gpn_ft_req(struct fc_disc *disc)
>   
>   /**
>    * fc_disc_gpn_ft_parse() - Parse the body of the dNS GPN_FT response.
> - * @disc:  The descovery context
> + * @disc:  The discovery context
>    * @buf:   The GPN_FT response buffer
>    * @len:   The size of response buffer
>    *
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
