From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [RESEND] [PATCH] [SCSI] libsas: Allow expander T-T attachments
Date: Thu, 22 Sep 2011 10:24:27 -0700 (PDT)
Message-ID: <1316712267.95370.YahooMailNeo@web31801.mail.mud.yahoo.com>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com> <1316691000.10571.6.camel@dabdike> <1316709696.61028.YahooMailNeo@web31812.mail.mud.yahoo.com> <20110922165014.GA12505@infradead.org>
Reply-To: Luben Tuikov <ltuikov@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm13-vm1.bullet.mail.ne1.yahoo.com ([98.138.91.62]:23721 "HELO
	nm13-vm1.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751668Ab1IVRYa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2011 13:24:30 -0400
In-Reply-To: <20110922165014.GA12505@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

I've noticed this recently as well. I'm not sure if it is Yahoo or Firefox, or my cutting and pasting from Emacs as opposed to Xterm.



----- Original Message -----
> From: Christoph Hellwig <hch@infradead.org>
> To: Luben Tuikov <ltuikov@yahoo.com>
> Cc: James Bottomley <jbottomley@parallels.com>; "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> Sent: Thursday, September 22, 2011 9:50 AM
> Subject: Re: [RESEND] [PATCH] [SCSI] libsas: Allow expander T-T attachments
> 
> On Thu, Sep 22, 2011 at 09:41:36AM -0700, Luben Tuikov wrote:
>>  Allow expander table-to-table attachments for
>>  expanders that support it.
>> 
>>  Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
>>  ---
>>  ?drivers/scsi/libsas/sas_expander.c |?? 20 ++++++++++++++------
>>  ?include/scsi/libsas.h????????????? |??? 3 +++
>>  ?include/scsi/sas.h???????????????? |?? 14 ++++++++++++--
>>  ?3 files changed, 29 insertions(+), 8 deletions(-)
>> 
>>  diff --git a/drivers/scsi/libsas/sas_expander.c 
> b/drivers/scsi/libsas/sas_expander.c
>>  index f84084b..e8d0115 100644
>>  --- a/drivers/scsi/libsas/sas_expander.c
>>  +++ b/drivers/scsi/libsas/sas_expander.c
>>  @@ -329,6 +329,7 @@ static void ex_assign_report_general(struct 
> domain_device *dev,
>>  ???? dev->ex_dev.ex_change_count = be16_to_cpu(rg->change_count);
>>  ???? dev->ex_dev.max_route_indexes = be16_to_cpu(rg->route_indexes);
>>  ???? dev->ex_dev.num_phys = min(rg->num_phys, (u8)MAX_EXPANDER_PHYS);
> 
> This looks completely garbled to me.
>
