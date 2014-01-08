From: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
Subject: RE: [PATCH] megaraid_sas: make the log message about rescanning
 more informative.
Date: Wed, 8 Jan 2014 12:28:15 +0000
Message-ID: <ed904388f93d4981a2bdefc6a622acdd@DM2PR07MB400.namprd07.prod.outlook.com>
References: <20131025122320.GA19111@spaans-e6500>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:35453
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755684AbaAHM2b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2014 07:28:31 -0500
In-Reply-To: <20131025122320.GA19111@spaans-e6500>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jasper Spaans <spaans@fox-it.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



>-----Original Message-----
>From: Jasper Spaans [mailto:spaans@fox-it.com]
>Sent: Friday, October 25, 2013 5:53 PM
>To: DL-MegaRAID Linux
>Cc: linux-scsi@vger.kernel.org
>Subject: [PATCH] megaraid_sas: make the log message about rescanning
>more informative.
>
>Hi,
>
>I was working on one of our servers, and saw the following interesting
>message in dmesg:
>
>[20961024.720972] scanning ...
>
>This scared me somewhat. Please find a patch to make it easier to see where
>this message is coming from.
>
>Cheers,
>Jasper
>
>---
> drivers/scsi/megaraid/megaraid_sas_base.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index 1f0ca68..3457289 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -5461,7 +5461,7 @@ megasas_aen_polling(struct work_struct *work)
> 	}
>
> 	if (doscan) {
>-		printk(KERN_INFO "scanning ...\n");
>+		printk(KERN_INFO "Rescanning MegaRAID devices ...\n");
> 		megasas_get_pd_list(instance);
> 		for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
> 			for (j = 0; j < MEGASAS_MAX_DEV_PER_CHANNEL;
>j++) {
>--
>1.7.9.5
Acked-by: Sumit Saxena <sumit.saxena@lsi.com>

Sumit
>
>
>--
> /\____/\   ir. Jasper Spaans // Lead Developer www.FoxDetACT.com
> \   (_)/   Fox-IT - For a more secure society!
>  \    X    T: +31-15-2847999
>   \  / \   M: +31-6-41588725
>    \/      KvK Haaglanden 27301624

