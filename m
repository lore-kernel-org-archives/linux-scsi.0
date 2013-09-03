From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH] scsi: ufs: replace the deprecated flush_work_sync
Date: Tue, 3 Sep 2013 09:41:00 -0700
Message-ID: <CALMYJDuCkDcf1+OrVh4XL-=dSHc_u2R3Y6Ad_POTWXbnirdQjA@mail.gmail.com>
References: <60A4377E7BEE4B2EA7855F9701B34BF0@chingDT> <1377512423.20958.7.camel@dabdike>
 <005501cea87b$8cc5a550$a650eff0$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:36159 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab3ICQld (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Sep 2013 12:41:33 -0400
Received: by mail-bk0-f41.google.com with SMTP id na10so2333419bkb.0
        for <linux-scsi@vger.kernel.org>; Tue, 03 Sep 2013 09:41:30 -0700 (PDT)
In-Reply-To: <005501cea87b$8cc5a550$a650eff0$%jun@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, Vinayak Holikatti <vinholikatti@gmail.com>

On Tue, Sep 3, 2013 at 12:59 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> flush_work_sync is replaced by flush_work with commit
> 4382973(workqueue: deprecate flush[_delayed]_work_sync()).
>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index a0f5ac2..1b99c0a 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2737,7 +2737,7 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
>                         break;
>                 spin_unlock_irqrestore(hba->host->host_lock, flags);
>                 dev_dbg(hba->dev, "%s: reset in progress\n", __func__);
> -               flush_work_sync(&hba->eh_work);
> +               flush_work(&hba->eh_work);
>         } while (1);
>
>         hba->ufshcd_state = UFSHCD_STATE_RESET;
> --
> 1.7.0.4
>
>

Acked-by: Santosh Y <santoshsy@gmail.com>

-- 
~Santosh
