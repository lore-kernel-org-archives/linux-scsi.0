From: akpm@linux-foundation.org
Subject: [patch 2/9] #if 0 ses_match_host()
Date: Mon, 09 Jun 2008 16:36:19 -0700
Message-ID: <200806092336.m59NaKcp014816@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757485AbYFIXgh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2008 19:36:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bunk@kernel.org, James.Bottomley@steeleye.com

From: Adrian Bunk <bunk@kernel.org>

#if 0 the unused ses_match_host()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ses.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/scsi/ses.c~if-0-ses_match_host drivers/scsi/ses.c
--- a/drivers/scsi/ses.c~if-0-ses_match_host
+++ a/drivers/scsi/ses.c
@@ -264,6 +264,7 @@ struct ses_host_edev {
 	struct enclosure_device *edev;
 };
 
+#if 0
 int ses_match_host(struct enclosure_device *edev, void *data)
 {
 	struct ses_host_edev *sed = data;
@@ -280,6 +281,7 @@ int ses_match_host(struct enclosure_devi
 	sed->edev = edev;
 	return 1;
 }
+#endif  /*  0  */
 
 static void ses_process_descriptor(struct enclosure_component *ecomp,
 				   unsigned char *desc)
_
