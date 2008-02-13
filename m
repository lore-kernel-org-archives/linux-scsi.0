From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] #if 0 ses_match_host()
Date: Wed, 13 Feb 2008 23:30:19 +0200
Message-ID: <20080213213018.GB3383@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:50813 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174AbYBMVaf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:35 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch #if 0's the unused ses_match_host()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/scsi/ses.c |    2 ++
 1 file changed, 2 insertions(+)

a9b8c5789924c15d23282da4b2e6bf8fa98449a2 diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 2a6e4f4..9125486 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -261,6 +261,7 @@ struct ses_host_edev {
 	struct enclosure_device *edev;
 };
 
+#if 0
 int ses_match_host(struct enclosure_device *edev, void *data)
 {
 	struct ses_host_edev *sed = data;
@@ -277,6 +278,7 @@ int ses_match_host(struct enclosure_device *edev, void *data)
 	sed->edev = edev;
 	return 1;
 }
+#endif  /*  0  */
 
 static void ses_process_descriptor(struct enclosure_component *ecomp,
 				   unsigned char *desc)

