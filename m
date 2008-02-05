From: akpm@linux-foundation.org
Subject: [patch 13/13] drivers/scsi/dc395x.c: fix uninitialized var warning
Date: Mon, 04 Feb 2008 23:53:26 -0800
Message-ID: <200802050753.m157r7XR010730@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43468 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754205AbYBEHxN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 02:53:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org

From: Andrew Morton <akpm@linux-foundation.org>

drivers/scsi/dc395x.c: In function 'dc395x_init_one':
drivers/scsi/dc395x.c:4270: warning: 'ptr' may be used uninitialized in this function

Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/dc395x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/dc395x.c~drivers-scsi-dc395xc-fix-uninitialized-var-warning drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c~drivers-scsi-dc395xc-fix-uninitialized-var-warning
+++ a/drivers/scsi/dc395x.c
@@ -4267,7 +4267,7 @@ static int __devinit adapter_sg_tables_a
 	const unsigned srbs_per_page = PAGE_SIZE/SEGMENTX_LEN;
 	int srb_idx = 0;
 	unsigned i = 0;
-	struct SGentry *ptr;
+	struct SGentry *uninitialized_var(ptr);
 
 	for (i = 0; i < DC395x_MAX_SRB_CNT; i++)
 		acb->srb_array[i].segment_x = NULL;
_
