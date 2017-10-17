From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: scsi: Add TRY_VPD_PAGES to HITACHI OPEN-V blacklist entry
Date: Tue, 17 Oct 2017 17:02:19 +0200
Message-ID: <f6cee46c-38b4-58c8-2428-869c023be702@gmail.com>
References: <1508224233-129972-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:49505 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752508AbdJQPCY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2017 11:02:24 -0400
Received: by mail-wr0-f195.google.com with SMTP id g90so2020129wrd.6
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2017 08:02:23 -0700 (PDT)
In-Reply-To: <1508224233-129972-1-git-send-email-hare@suse.de>
Content-Language: en-GB
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 10/17/2017 09:10 AM, Hannes Reinecke wrote:

> HITACHI is always supporting VPD pages, even though it's claiming
> to support SCSI Revision 3 only.


"HP/OPEN-" is also affected. HP XP is a rebrand of HITACHI VSP.

{"HP", "OPEN-", "*", BLIST_REPORTLUN2}, /* HP XP Arrays */


> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/scsi_devinfo.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> index ae2ad84..a998585 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -174,7 +174,7 @@ struct scsi_dev_info_list_table {
>  	{"HITACHI", "DF500", "*", BLIST_REPORTLUN2},
>  	{"HITACHI", "DISK-SUBSYSTEM", "*", BLIST_REPORTLUN2},
>  	{"HITACHI", "HUS1530", "*", BLIST_NO_DIF},
> -	{"HITACHI", "OPEN-", "*", BLIST_REPORTLUN2},
> +	{"HITACHI", "OPEN-", "*", BLIST_REPORTLUN2 | BLIST_TRY_VPD_PAGES},
>  	{"HITACHI", "OP-C-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
>  	{"HITACHI", "3380-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
>  	{"HITACHI", "3390-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
> 
