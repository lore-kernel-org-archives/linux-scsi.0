From: akpm@linux-foundation.org
Subject: [patch 26/28] make mptspi_target_destroy() static
Date: Mon, 26 Mar 2007 21:59:46 -0800
Message-ID: <200703270559.l2R5xkPq008712@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41058 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965116AbXC0GDD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Mar 2007 02:03:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bunk@stusta.de, Eric.Moore@lsi.com

From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Eric Moore <Eric.Moore@lsi.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptspi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/message/fusion/mptspi.c~make-mptspi_target_destroy-static drivers/message/fusion/mptspi.c
--- a/drivers/message/fusion/mptspi.c~make-mptspi_target_destroy-static
+++ a/drivers/message/fusion/mptspi.c
@@ -445,7 +445,7 @@ static int mptspi_target_alloc(struct sc
 	return 0;
 }
 
-void
+static void
 mptspi_target_destroy(struct scsi_target *starget)
 {
 	if (starget->hostdata)
_
