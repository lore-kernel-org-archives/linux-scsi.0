From: akpm@linux-foundation.org
Subject: [patch 16/28] make seagate_st0x_detect() static
Date: Mon, 26 Mar 2007 21:59:33 -0800
Message-ID: <200703270559.l2R5xXIW008664@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41042 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965116AbXC0GCr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Mar 2007 02:02:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bunk@stusta.de

From: Adrian Bunk <bunk@stusta.de>

seagate_st0x_detect() can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/seagate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/seagate.c~make-seagate_st0x_detect-static drivers/scsi/seagate.c
--- a/drivers/scsi/seagate.c~make-seagate_st0x_detect-static
+++ a/drivers/scsi/seagate.c
@@ -420,7 +420,7 @@ static inline void borken_wait (void)
 #define ULOOP( i ) for (clock = i*8;;)
 #define TIMEOUT (!(clock--))
 
-int __init seagate_st0x_detect (struct scsi_host_template * tpnt)
+static int __init seagate_st0x_detect (struct scsi_host_template * tpnt)
 {
 	struct Scsi_Host *instance;
 	int i, j;
_
