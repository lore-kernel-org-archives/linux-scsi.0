Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A18CC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 23:05:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04C65205CB
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 23:05:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="Dk3lOutv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgEOXFm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 19:05:42 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:36988 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726183AbgEOXFm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 May 2020 19:05:42 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 959984C850;
        Fri, 15 May 2020 23:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1589583932;
         x=1591398333; bh=7gdtLQzQAnbmIMUMQRVEBwOBRmZb3nBrA2047dJiI8I=; b=
        Dk3lOutvNXk4HKvo/XeHy1S+CJJa1VE1UIymo/bKJLz5x0XYsY+Q9RqFwFx/976E
        5M1kOsQEk5nzLw5ZNcg2QMhrf0VsTCoa7pi2p4eWamE3a6az0UJIoFOKrSqlR8Oe
        2riGY358Ox8cyoaL9QkqS8vSx7Yxua5rD6IyuoW0494=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DeUexwjR8X6M; Sat, 16 May 2020 02:05:32 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 991034C845;
        Sat, 16 May 2020 02:05:31 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Sat, 16
 May 2020 02:05:33 +0300
Date:   Sat, 16 May 2020 02:05:32 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>, Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v6 01/15] qla2xxx: Fix spelling of a variable name
Message-ID: <20200515230532.GH98158@SPB-NB-133.local>
References: <20200514213516.25461-1-bvanassche@acm.org>
 <20200514213516.25461-2-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200514213516.25461-2-bvanassche@acm.org>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 14, 2020 at 02:35:02PM -0700, Bart Van Assche wrote:
> Reviewed-by: Daniel Wagner <dwagner@suse.de>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Arun Easi <aeasi@marvell.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_fw.h   | 2 +-
>  drivers/scsi/qla2xxx/qla_init.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
> index f9bad5bd7198..b364a497e33d 100644
> --- a/drivers/scsi/qla2xxx/qla_fw.h
> +++ b/drivers/scsi/qla2xxx/qla_fw.h
> @@ -1292,7 +1292,7 @@ struct device_reg_24xx {
>  };
>  /* RISC-RISC semaphore register PCI offet */
>  #define RISC_REGISTER_BASE_OFFSET	0x7010
> -#define RISC_REGISTER_WINDOW_OFFET	0x6
> +#define RISC_REGISTER_WINDOW_OFFSET	0x6
>  
>  /* RISC-RISC semaphore/flag register (risc address 0x7016) */
>  
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 95b6166ae0cc..f8fe0334571f 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2861,7 +2861,7 @@ qla25xx_read_risc_sema_reg(scsi_qla_host_t *vha, uint32_t *data)
>  	struct device_reg_24xx __iomem *reg = &vha->hw->iobase->isp24;
>  
>  	WRT_REG_DWORD(&reg->iobase_addr, RISC_REGISTER_BASE_OFFSET);
> -	*data = RD_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFET);
> +	*data = RD_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFSET);
>  
>  }
>  
> @@ -2871,7 +2871,7 @@ qla25xx_write_risc_sema_reg(scsi_qla_host_t *vha, uint32_t data)
>  	struct device_reg_24xx __iomem *reg = &vha->hw->iobase->isp24;
>  
>  	WRT_REG_DWORD(&reg->iobase_addr, RISC_REGISTER_BASE_OFFSET);
> -	WRT_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFET, data);
> +	WRT_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFSET, data);
>  }
>  
>  static void

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

Thanks,
Roman
