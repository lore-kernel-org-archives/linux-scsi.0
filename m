From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] megaraid_sas: make the log message about rescanning
 more informative.
Date: Thu, 13 Mar 2014 14:37:43 +0400
Message-ID: <1394707063.2192.17.camel@dabdike>
References: <20131025122320.GA19111@spaans-e6500>
	 <ed904388f93d4981a2bdefc6a622acdd@DM2PR07MB400.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43094 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753264AbaCMOR4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Mar 2014 10:17:56 -0400
In-Reply-To: <ed904388f93d4981a2bdefc6a622acdd@DM2PR07MB400.namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
Cc: Jasper Spaans <spaans@fox-it.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2014-01-08 at 12:28 +0000, Saxena, Sumit wrote:
> 
> >-----Original Message-----
> >From: Jasper Spaans [mailto:spaans@fox-it.com]
> >Sent: Friday, October 25, 2013 5:53 PM
> >To: DL-MegaRAID Linux
> >Cc: linux-scsi@vger.kernel.org
> >Subject: [PATCH] megaraid_sas: make the log message about rescanning
> >more informative.
> >
> >Hi,
> >
> >I was working on one of our servers, and saw the following interesting
> >message in dmesg:
> >
> >[20961024.720972] scanning ...
> >
> >This scared me somewhat. Please find a patch to make it easier to see where
> >this message is coming from.
> >
> >Cheers,
> >Jasper
> >
> >---
> > drivers/scsi/megaraid/megaraid_sas_base.c |    2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> >b/drivers/scsi/megaraid/megaraid_sas_base.c
> >index 1f0ca68..3457289 100644
> >--- a/drivers/scsi/megaraid/megaraid_sas_base.c
> >+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> >@@ -5461,7 +5461,7 @@ megasas_aen_polling(struct work_struct *work)
> > 	}
> >
> > 	if (doscan) {
> >-		printk(KERN_INFO "scanning ...\n");
> >+		printk(KERN_INFO "Rescanning MegaRAID devices ...\n");
> > 		megasas_get_pd_list(instance);
> > 		for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
> > 			for (j = 0; j < MEGASAS_MAX_DEV_PER_CHANNEL;
> >j++) {
> >--
> >1.7.9.5
> Acked-by: Sumit Saxena <sumit.saxena@lsi.com>

I'd prefer consistency for this: Most of the messages in this driver
have a megasas: prefix ... but there are quite a large number that don't
(and which probably should have).  If this is necessary, please use the
standard driver prefix.

Thanks,

James


