From: Brian King <brking@us.ibm.com>
Subject: [PATCH 09/10] ipr: Make ipr_ioctl static
Date: Tue, 21 Nov 2006 10:28:48 -0600
Message-ID: <200611211628.kALGSn0T021340@d03av01.boulder.ibm.com>
References: <11641264771784-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:25832 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S1031068AbWKUQ2w
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Nov 2006 11:28:52 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kALGSom8028882
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 11:28:50 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kALGSoDc470834
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 09:28:50 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kALGSnjJ021378
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 09:28:50 -0700
In-Reply-To: <11641264771784-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com, bunk@stusta.de


From: Adrian Bunk <bunk@stusta.de>

This patch makes ipr_ioctl static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_static_ioctl drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_static_ioctl	2006-11-20 08:54:05.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2006-11-20 08:54:05.000000000 -0600
@@ -4837,7 +4837,7 @@ static int ipr_queuecommand(struct scsi_
  * Return value:
  * 	0 on success / other on failure
  **/
-int ipr_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
+static int ipr_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 {
 	struct ipr_resource_entry *res;
 
_
