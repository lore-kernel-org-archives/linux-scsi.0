From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/constants.c: make 2 functions static
Date: Sun, 29 Jul 2007 17:02:12 +0200
Message-ID: <20070729150212.GT16817@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47916 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765066AbXG2PCf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jul 2007 11:02:35 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@SteelEye.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

This patch makes two needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch has been sent on:
- 24 Mar 2007

 drivers/scsi/constants.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.21-rc4-mm1/drivers/scsi/constants.c.old	2007-03-23 23:26:39.000000000 +0100
+++ linux-2.6.21-rc4-mm1/drivers/scsi/constants.c	2007-03-23 23:26:55.000000000 +0100
@@ -1235,7 +1235,7 @@
 }
 EXPORT_SYMBOL(scsi_print_sense_hdr);
 
-void
+static void
 scsi_decode_sense_buffer(const unsigned char *sense_buffer, int sense_len,
 		       struct scsi_sense_hdr *sshdr)
 {
@@ -1258,7 +1258,7 @@
 	}
 }
 
-void
+static void
 scsi_decode_sense_extras(const unsigned char *sense_buffer, int sense_len,
 			 struct scsi_sense_hdr *sshdr)
 {

