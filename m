From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH 1/1] [SCSI] fnic: Remove unneeded version.h header file include
Date: Tue, 19 Feb 2013 15:22:55 +0530
Message-ID: <CAK9yfHx-6+F_azVHowUUqZtY1PYmiSzfXy4a1Z3w9vuMhOhJeg@mail.gmail.com>
References: <1359965717-2615-1-git-send-email-sachin.kamat@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:58850 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3BSJw4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Feb 2013 04:52:56 -0500
Received: by mail-oa0-f50.google.com with SMTP id l20so6590435oag.23
        for <linux-scsi@vger.kernel.org>; Tue, 19 Feb 2013 01:52:56 -0800 (PST)
In-Reply-To: <1359965717-2615-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hiralpat@cisco.com, JBottomley@parallels.com, sramars@cisco.com, buchino@cisco.com, sachin.kamat@linaro.org

On 4 February 2013 13:45, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> version.h header file inclusion is not necessary.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/scsi/fnic/fnic_trace.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)

ping..

>
> diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
> index 0b18bf4..63f6f5b 100644
> --- a/drivers/scsi/fnic/fnic_trace.c
> +++ b/drivers/scsi/fnic/fnic_trace.c
> @@ -19,7 +19,6 @@
>  #include <linux/mempool.h>
>  #include <linux/errno.h>
>  #include <linux/spinlock.h>
> -#include <linux/version.h>
>  #include <linux/kallsyms.h>
>  #include "fnic_io.h"
>  #include "fnic.h"
> --
> 1.7.4.1
>



-- 
With warm regards,
Sachin
