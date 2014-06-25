From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: RE: [PATCH 0/4] mpt2/mpt3 static checker fixups
Date: Wed, 25 Jun 2014 15:13:38 +0530
Message-ID: <c1f8fba633e272e8f50607c93050d19c@mail.gmail.com>
References: <1401719672-18352-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og119.obsmtp.com ([64.18.2.16]:56617 "EHLO
	exprod7og119.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbaFYJoE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 05:44:04 -0400
Received: by mail-qa0-f50.google.com with SMTP id m5so1295400qaj.23
        for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2014 02:44:02 -0700 (PDT)
In-Reply-To: <1401719672-18352-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>

James,

This Patch set seems to be fine. Please consider this patch set as
Acked-by:  Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Regards,
Sreekanth

>-----Original Message-----
>From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>owner@vger.kernel.org] On Behalf Of Joe Lawrence
>Sent: Monday, June 02, 2014 8:04 PM
>To: linux-scsi@vger.kernel.org
>Cc: Dan Carpenter; Sreekanth Reddy; Joe Lawrence
>Subject: [PATCH 0/4] mpt2/mpt3 static checker fixups
>
>Hello Sreekanth, Dan,
>
>These are a few minor smatch and sparse static checker fixes for the LSI
>mpt2 and mpt3 drivers.  The first three fix real potential bugs and the
last
>cleans up a noisy complaint from sparse.
>
>Joe Lawrence (4):
>  mpt2sas: correct scsi_{target,device} hostdata allocation
>  mpt3sas: correct scsi_{target,device} hostdata allocation
>  mpt3sas: fix possible memory leak in mpt3sas_send_trigger_data_event
>  mpt2sas: annotate ioc->reply_post_host_index as __iomem
>
> drivers/scsi/mpt2sas/mpt2sas_base.c  |    9 +++++----
> drivers/scsi/mpt2sas/mpt2sas_base.h  |    2 +-
> drivers/scsi/mpt2sas/mpt2sas_scsih.c |    6 ++++--
> drivers/scsi/mpt3sas/mpt3sas_scsih.c |   10 +++++++---
> 4 files changed, 17 insertions(+), 10 deletions(-)
>
>--
>1.7.10.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body
>of a message to majordomo@vger.kernel.org More majordomo info at
>http://vger.kernel.org/majordomo-info.html
