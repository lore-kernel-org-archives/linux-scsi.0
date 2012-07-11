From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH 1/1] [SCSI] tcm_qla2xxx: Remove duplicate header file inclusion
Date: Wed, 11 Jul 2012 16:23:26 +0530
Message-ID: <CAK9yfHw=V3SHrAZD=wZkkG=ZgA9Dv+VWAm6uLtLBR1NZRpYt9g@mail.gmail.com>
References: <1340366038-12722-1-git-send-email-sachin.kamat@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44364 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab2GKKx1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jul 2012 06:53:27 -0400
Received: by vbbff1 with SMTP id ff1so646243vbb.19
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jul 2012 03:53:27 -0700 (PDT)
In-Reply-To: <1340366038-12722-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, nab@linux-iscsi.org, sachin.kamat@linaro.org, patches@linaro.org

Any comments about this patch?

On 22/06/2012, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> ctype.h and string.h header files were included more than once.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 6e64314..dd0a0df 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -38,8 +38,6 @@
>  #include <linux/string.h>
>  #include <linux/configfs.h>
>  #include <linux/ctype.h>
> -#include <linux/string.h>
> -#include <linux/ctype.h>
>  #include <asm/unaligned.h>
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_host.h>
> --
> 1.7.4.1
>
>


-- 
With warm regards,
Sachin
