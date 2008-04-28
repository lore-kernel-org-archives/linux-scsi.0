From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: Rename ipr's state scsi host attribute to prevent collisions
Date: Mon, 28 Apr 2008 17:36:20 -0500
Message-ID: <45268.5011936866$1209422401@news.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41899 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965361AbYD1Wg0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Apr 2008 18:36:26 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3SMaNDt008492
	for <linux-scsi@vger.kernel.org>; Mon, 28 Apr 2008 18:36:24 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3SMaNZc176890
	for <linux-scsi@vger.kernel.org>; Mon, 28 Apr 2008 18:36:23 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3SMaNOG026649
	for <linux-scsi@vger.kernel.org>; Mon, 28 Apr 2008 18:36:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, wayneb@linux.vnet.ibm.com, pbadari@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Due to recent SCSI core changes which add a scsi host attribute
named "state", this now collides with an ipr driver scsi host attribute
with the same name, preventing ipr from loading. Rename the ipr driver
attribute to be more specific.


Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_host_state_rename drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_host_state_rename	2008-04-28 17:30:54.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2008-04-28 17:31:21.000000000 -0500
@@ -2791,7 +2791,7 @@ static ssize_t ipr_store_adapter_state(s
 
 static struct device_attribute ipr_ioa_state_attr = {
 	.attr = {
-		.name =		"state",
+		.name =		"online_state",
 		.mode =		S_IRUGO | S_IWUSR,
 	},
 	.show = ipr_show_adapter_state,
_
