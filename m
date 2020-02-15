Return-Path: <SRS0=Nr3K=4D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB59C352A3
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Feb 2020 21:15:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD5F22084E
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Feb 2020 21:15:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgBOVPI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 15 Feb 2020 16:15:08 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:34808 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgBOVPI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Feb 2020 16:15:08 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 013E929ADF;
        Sat, 15 Feb 2020 16:15:05 -0500 (EST)
Date:   Sun, 16 Feb 2020 08:15:04 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     qiwuchen55@gmail.com
cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, chenqiwu <chenqiwu@xiaomi.com>
Subject: Re: [PATCH] scsi: core: fix a typo of coding format
In-Reply-To: <1581757095-11518-1-git-send-email-qiwuchen55@gmail.com>
Message-ID: <alpine.LNX.2.22.394.2002160808490.8@nippy.intranet>
References: <1581757095-11518-1-git-send-email-qiwuchen55@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 15 Feb 2020, qiwuchen55@gmail.com wrote:

> From: chenqiwu <chenqiwu@xiaomi.com>
> 
> Fix a typo of coding format.
> 

It isn't a 'typo' as it appears to be a deliberate choice.

git grep '^ [a-z_0-9]+:$' -- drivers/scsi/

I can't find anything in Documentation/process that bans indentation of 
goto labels. Am I missing something? What do you gain?

If there's nothing in the style guide to mandate churn like this patch, 
then we might expect more churn when someone else patches the whitespace 
back in (for consistency, taste, fame and fortune, whatever).

> Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>
> ---
>  drivers/scsi/scsi_lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 610ee41..a89cfaf 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1563,7 +1563,7 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>  	}
>  
>  	return rtn;
> - done:
> +done:
>  	cmd->scsi_done(cmd);
>  	return 0;
>  }
> 
