From: Jasper Spaans <spaans@fox-it.com>
Subject: [PATCH] megaraid_sas: make the log message about rescanning more
 informative.
Date: Fri, 25 Oct 2013 14:23:20 +0200
Message-ID: <20131025122320.GA19111@spaans-e6500>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.fox-it.com ([178.250.144.131]:2364 "EHLO ns2.fox-it.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab3JYMb5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Oct 2013 08:31:57 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: megaraidlinux@lsi.com
Cc: linux-scsi@vger.kernel.org

Hi,

I was working on one of our servers, and saw the following interesting
message in dmesg:

[20961024.720972] scanning ...

This scared me somewhat. Please find a patch to make it easier to see where
this message is coming from.

Cheers,
Jasper

---
 drivers/scsi/megaraid/megaraid_sas_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 1f0ca68..3457289 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5461,7 +5461,7 @@ megasas_aen_polling(struct work_struct *work)
 	}
 
 	if (doscan) {
-		printk(KERN_INFO "scanning ...\n");
+		printk(KERN_INFO "Rescanning MegaRAID devices ...\n");
 		megasas_get_pd_list(instance);
 		for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
 			for (j = 0; j < MEGASAS_MAX_DEV_PER_CHANNEL; j++) {
-- 
1.7.9.5


-- 
 /\____/\   ir. Jasper Spaans // Lead Developer www.FoxDetACT.com
 \   (_)/   Fox-IT - For a more secure society!
  \    X    T: +31-15-2847999       
   \  / \   M: +31-6-41588725
    \/      KvK Haaglanden 27301624
