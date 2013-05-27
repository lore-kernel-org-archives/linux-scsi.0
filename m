From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH] ufshcd-pltfrm: add missing empty slot in ufs_of_match[]
Date: Mon, 27 May 2013 17:13:44 +0530
Message-ID: <CALMYJDs=L18BinOnqp_f9FUJaKZ=i8Z6TVFo5pc_N0AAWmXwQg@mail.gmail.com>
References: <1369567481-30685-1-git-send-email-mita@fixstars.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:50311 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757825Ab3E0LoG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 May 2013 07:44:06 -0400
Received: by mail-bk0-f54.google.com with SMTP id it16so3278698bkc.13
        for <linux-scsi@vger.kernel.org>; Mon, 27 May 2013 04:44:05 -0700 (PDT)
In-Reply-To: <1369567481-30685-1-git-send-email-mita@fixstars.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <mita@fixstars.com>
Cc: linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

On Sun, May 26, 2013 at 4:54 PM, Akinobu Mita <mita@fixstars.com> wrote:
> of_match_table member in struct device_driver must be terminated by
> empty slot as a sentinel.
>
> Signed-off-by: Akinobu Mita <mita@fixstars.com>
> Cc: Vinayak Holikatti <vinholikatti@gmail.com>
> Cc: Santosh Y <santoshsy@gmail.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/scsi/ufs/ufshcd-pltfrm.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
> index 03319ac..0014e28 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> @@ -190,6 +190,7 @@ static int ufshcd_pltfrm_remove(struct platform_device *pdev)
>
>  static const struct of_device_id ufs_of_match[] = {
>         { .compatible = "jedec,ufs-1.1"},
> +       {},
>  };
>
>  static const struct dev_pm_ops ufshcd_dev_pm_ops = {
> --
> 1.8.1.4
>

Acked-by: Santosh Y <santoshsy@gmail.com>

-- 
~Santosh
