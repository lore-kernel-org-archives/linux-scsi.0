From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] tmscsim: remove redundant code
Date: Wed, 29 Sep 2004 07:53:20 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0409290748460.1428@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:32703 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S268207AbUI2FzG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 01:55:06 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

hope it doesn't get corupted inline...

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

--- a/drivers/scsi/tmscsim.c	Wed Sep 29 07:44:11 2004
+++ b/drivers/scsi/tmscsim.c	Wed Sep 29 07:44:29 2004
@@ -1418,16 +1418,6 @@

  static int __init dc390_module_init(void)
  {
-	if (tmscsim[0] == -1 || tmscsim[0] > 15) {
-		tmscsim[0] = 7;
-		tmscsim[1] = 4;
-		tmscsim[2] = 0x09;
-		tmscsim[3] = 0x0f;
-		tmscsim[4] = 2;
-		tmscsim[5] = 10;
-		printk(KERN_INFO "DC390: Using safe settings.\n");
-	}
-
  	return pci_module_init(&dc390_driver);
  }


Thanks
Guennadi
---
Guennadi Liakhovetski

