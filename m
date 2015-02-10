From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: [PATCH] scsi: megaraid_sas: Prevent future %p disaster
Date: Tue, 10 Feb 2015 22:16:05 +0530
Message-ID: <bb45ec6cfa94612741a2eb355d0de566@mail.gmail.com>
References: <1423233221-27069-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:53265 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbbBJQqI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Feb 2015 11:46:08 -0500
Received: by mail-lb0-f170.google.com with SMTP id u14so13128401lbd.1
        for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2015 08:46:06 -0800 (PST)
In-Reply-To: <1423233221-27069-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Acked-by: Kashyap Desai <kashyap.desai@avagotech.com>

> -----Original Message-----
> From: Rasmus Villemoes [mailto:linux@rasmusvillemoes.dk]
> Sent: Friday, February 06, 2015 8:04 PM
> To: Kashyap Desai; Sumit Saxena; Uday Lingala; James E.J. Bottomley
> Cc: Rasmus Villemoes; megaraidlinux.pdl@avagotech.com; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] scsi: megaraid_sas: Prevent future %p disaster
>
> There is currently no %po format extension, so currently the letters
"on" are
> simply skipped and the pointer is printed as expected (while missing the
word
> on). However, it is probably only a matter of time before someone comes
up
> with a %po extension, at which point this is likely to fail
spectacularly.
>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> b/drivers/scsi/megaraid/megaraid_sas_base.c
> index ff283d23788a..e7c6b9c946d6 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -3105,7 +3105,7 @@ megasas_internal_reset_defer_cmds(struct
> megasas_instance *instance)
>  	for (i = 0; i < max_cmd; i++) {
>  		cmd = instance->cmd_list[i];
>  		if (cmd->sync_cmd == 1 || cmd->scmd) {
> -			printk(KERN_NOTICE "megasas: moving
> cmd[%d]:%p:%d:%p"
> +			printk(KERN_NOTICE "megasas: moving
> cmd[%d]:%p:%d:%p "
>  					"on the defer queue as
internal\n",
>  				defer_index, cmd, cmd->sync_cmd, cmd-
> >scmd);
>
> --
> 2.1.3
