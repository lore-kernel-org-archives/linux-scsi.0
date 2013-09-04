From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Subject: RE: [PATCH] Allow MPT Fusion SAS 3.0 driver to be built into the
 kernel
Date: Wed, 4 Sep 2013 09:26:41 +0530
Message-ID: <DCD177647606E9419ED923E0C8C4AA723006D9AFCA@inbmail02.lsi.com>
References: <20130903220011.GA20840@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-db9lp0249.outbound.messaging.microsoft.com ([213.199.154.249]:26958
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760947Ab3IDD4x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Sep 2013 23:56:53 -0400
In-Reply-To: <20130903220011.GA20840@kroah.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, Support <support@lsi.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

Hi James,

This patch seem to be fine. Please consider this patch.

Regards,
Sreekanth.

>-----Original Message-----
>From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
>Sent: Wednesday, September 04, 2013 3:30 AM
>To: Nandigama, Nagalakshmi; Reddy, Sreekanth; Support;
>JBottomley@parallels.com
>Cc: linux-scsi@vger.kernel.org; DL-MPT Fusion Linux
>Subject: [PATCH] Allow MPT Fusion SAS 3.0 driver to be built into the kernel
>
>From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
>Right now the Makefile for the mpt3sas driver does not even allow the driver
>to be built into the kernel.  So fix that up, as there doesn't seem to be any
>obvious reason why this shouldn't be done.
>
>Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
>Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
>Cc: support@lsi.com
>Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
>
>diff --git a/drivers/scsi/mpt3sas/Makefile b/drivers/scsi/mpt3sas/Makefile
>index 4c1d2e7a..efb0c4c2 100644
>--- a/drivers/scsi/mpt3sas/Makefile
>+++ b/drivers/scsi/mpt3sas/Makefile
>@@ -1,5 +1,5 @@
> # mpt3sas makefile
>-obj-m += mpt3sas.o
>+obj-$(CONFIG_SCSI_MPT3SAS) += mpt3sas.o
> mpt3sas-y +=  mpt3sas_base.o     \
> 		mpt3sas_config.o \
> 		mpt3sas_scsih.o      \


