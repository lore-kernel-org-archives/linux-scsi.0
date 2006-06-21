From: "adam radford" <aradford@gmail.com>
Subject: Re: [Ubuntu PATCH] 3w-9xyz: add proc_name
Date: Wed, 21 Jun 2006 11:23:25 -0700
Message-ID: <b1bc6a000606211123h598ff564i5b8a25bb92e19a00@mail.gmail.com>
References: <4498D9EA.5090909@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:38296 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S932295AbWFUSX0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jun 2006 14:23:26 -0400
Received: by nf-out-0910.google.com with SMTP id o60so146295nfa
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2006 11:23:25 -0700 (PDT)
In-Reply-To: <4498D9EA.5090909@oracle.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>, jejb <James.Bottomley@steeleye.com>, linuxraid@amcc.com

Randy,

Is there any reason why any of these proc_name patches need to
go in after James Smart's explanation:

http://marc.theaimsgroup.com/?l=linux-scsi&m=115040210406375&w=2

in particular, the part about:

"- scsi_proc_hostdir_add() validates that sht->proc_info is non-null before
   attempting to use sht->proc_name."

proc_info is null for the 3w-9xxx driver.

-Adam

On 6/20/06, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Add .proc_name member to scsi_host_template for 3w-9xxx.
>
> http://www.kernel.org/git/?p=linux/kernel/git/bcollins/ubuntu-dapper.git;a=commitdiff;h=12fdf64086335ed596848cf17602e7a71e15ae9b
>
>
> ---
>  drivers/scsi/3w-9xxx.c |    1 +
>  1 file changed, 1 insertion(+)
>
> --- linux-2617-pv.orig/drivers/scsi/3w-9xxx.c
> +++ linux-2617-pv/drivers/scsi/3w-9xxx.c
> @@ -2011,6 +2011,7 @@ static void twa_unmap_scsi_data(TW_Devic
>  /* scsi_host_template initializer */
>  static struct scsi_host_template driver_template = {
>         .module                 = THIS_MODULE,
> +       .proc_name              = "3w-9xxx",
>         .name                   = "3ware 9000 Storage Controller",
>         .queuecommand           = twa_scsi_queue,
>         .eh_host_reset_handler  = twa_scsi_eh_reset,
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
