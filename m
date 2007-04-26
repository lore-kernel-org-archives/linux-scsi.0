From: akpm@linux-foundation.org
Subject: [patch 14/30] make seagate_st0x_detect() static
Date: Thu, 26 Apr 2007 00:35:17 -0700
Message-ID: <200704260735.l3Q7ZHuR024247@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933498AbXDZH6F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Apr 2007 03:58:05 -0400
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
