From: akpm@linux-foundation.org
Subject: [patch 04/17] #if 0 ses_match_host()
Date: Mon, 22 Sep 2008 14:56:42 -0700
Message-ID: <200809222156.m8MLuhkJ032273@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753636AbYIVV5V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2008 17:57:21 -0400
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
