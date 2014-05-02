From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Subject: RE: [patch] [SCSI] mpt3sas: tidy up output slightly
Date: Fri, 2 May 2014 11:44:42 +0000
Message-ID: <fa09e003610140d3940f5aafd431c3c9@DM2PR07MB302.namprd07.prod.outlook.com>
References: <20140328083901.GQ25192@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:55977
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751669AbaEBLo6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2014 07:44:58 -0400
In-Reply-To: <20140328083901.GQ25192@mwanda>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Cc: Support <support@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>

James,

This patch seem to be fine. Please consider this patch.

Regards,
Sreekanth

>-----Original Message-----
>From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
>Sent: Friday, March 28, 2014 2:09 PM
>To: Nandigama, Nagalakshmi
>Cc: Reddy, Sreekanth; Support; James E.J. Bottomley; DL-MPT Fusion Linux;
>linux-scsi@vger.kernel.org; kernel-janitors@vger.kernel.org
>Subject: [patch] [SCSI] mpt3sas: tidy up output slightly
>
>The indenting here for "pr_info("\n");" is not correct.  It's not part of the if
>condition.
>
>Also using pr_info() would put extra characters in the middle of the line.  I
>suppose that people could complain that pr_cont() is racy but at least it's
>better than the original code.
>
>Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
>diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c
>b/drivers/scsi/mpt3sas/mpt3sas_base.c
>index 0cf4f70..aa0e042 100644
>--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
>+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
>@@ -585,9 +585,9 @@ _base_display_event_data(struct MPT3SAS_ADAPTER
>*ioc,
> 		    (event_data->ReasonCode ==
>MPI2_EVENT_SAS_DISC_RC_STARTED) ?
> 		    "start" : "stop");
> 		if (event_data->DiscoveryStatus)
>-			pr_info("discovery_status(0x%08x)",
>+			pr_cont("discovery_status(0x%08x)",
> 			    le32_to_cpu(event_data->DiscoveryStatus));
>-			pr_info("\n");
>+		pr_cont("\n");
> 		return;
> 	}
> 	case MPI2_EVENT_SAS_BROADCAST_PRIMITIVE:

