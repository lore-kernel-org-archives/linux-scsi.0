From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: RE: mptNsas MSI-X fixes
Date: Wed, 25 Jun 2014 14:40:32 +0530
Message-ID: <26e11d455c662ede21a32d8dfe24e0f3@mail.gmail.com>
References: <1388794616-23560-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og120.obsmtp.com ([64.18.2.18]:50812 "EHLO
	exprod7og120.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbaFYJWQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 05:22:16 -0400
Received: by mail-qa0-f45.google.com with SMTP id v10so1291612qac.32
        for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2014 02:22:14 -0700 (PDT)
In-Reply-To: <1388794616-23560-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: sreekanth.reddy@avagotech.com

Hi James,

This Patch set seems to be fine. Please consider this patch set as
Acked-by:  Sreekanth Reddy <Sreekanth.reddy@avagotech.com>

Regards,
Sreekanth
>-----Original Message-----
>From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>owner@vger.kernel.org] On Behalf Of Martin K. Petersen
>Sent: Saturday, January 04, 2014 5:47 AM
>To: linux-scsi@vger.kernel.org
>Subject: mptNsas MSI-X fixes
>
>We found a couple of MSI-X related problems with mptNsas on very large
>systems. The patches below contain fixes for mpt2sas and mpt3sas
>respectively.
>
> drivers/scsi/mpt2sas/mpt2sas_base.c | 64 ++++++++++++++++++++----------
>------------------------
> drivers/scsi/mpt3sas/mpt3sas_base.c | 73 ++++++++++++++++++-------------
>-------------------------------
> 2 files changed, 44 insertions(+), 93 deletions(-)
>
>--
>Martin K. Petersen	Oracle Linux Engineering
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body
>of a message to majordomo@vger.kernel.org More majordomo info at
>http://vger.kernel.org/majordomo-info.html
