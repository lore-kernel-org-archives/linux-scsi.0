From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH 01/10] megaraid_sas: megasas_complete_outstanding_ioctls()
 can be static
Date: Tue, 13 Jan 2015 11:08:36 +0530
Message-ID: <05c5c693c900a89207d092c2040b6fa0@mail.gmail.com>
References: <1420909883-19479-1-git-send-email-hch@lst.de> <1420909883-19479-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og107.obsmtp.com ([64.18.2.167]:48689 "EHLO
	exprod7og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbbAMFii (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jan 2015 00:38:38 -0500
Received: by mail-qa0-f50.google.com with SMTP id k15so762996qaq.9
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2015 21:38:38 -0800 (PST)
In-Reply-To: <1420909883-19479-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Kashyap Desai <kashyap.desai@avagotech.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, kbuild test robot <fengguang.wu@intel.com>

>-----Original Message-----
>From: Christoph Hellwig [mailto:hch@lst.de]
>Sent: Saturday, January 10, 2015 10:41 PM
>To: Sumit.Saxena@avagotech.com; kashyap.desai@avagotech.com
>Cc: martin.petersen@oracle.com; linux-scsi@vger.kernel.org; kbuild test
>robot
>Subject: [PATCH 01/10] megaraid_sas:
>megasas_complete_outstanding_ioctls() can be static
>
>From: kbuild test robot <fengguang.wu@intel.com>
>
>drivers/scsi/megaraid/megaraid_sas_base.c:1701:6: sparse: symbol
>'megasas_complete_outstanding_ioctls' was not declared. Should it be
static?
>
>Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
>---
> drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index 890637f..2eb5233 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -1698,7 +1698,7 @@ static int megasas_slave_alloc(struct scsi_device
>*sdev)
> * @instance:				Adapter soft state
> *
> */
>-void megasas_complete_outstanding_ioctls(struct megasas_instance
>*instance)
>+static void megasas_complete_outstanding_ioctls(struct megasas_instance
>*instance)
> {
> 	int i;
> 	struct megasas_cmd *cmd_mfi;

Acked-by: Sumit Saxena <sumit.saxena@avagotech.com>

>--
>1.9.1
