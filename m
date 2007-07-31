From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [PATCH 54] drivers/scsi/mvme16x_scsi.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 23:23:36 +0200
Message-ID: <200707312323.36541.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3248 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756286AbXGaVXg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jul 2007 17:23:36 -0400
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, jongk@linux-m68k.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/mvme16x_scsi.c | 3740 -> 3678 (-62 bytes)

 drivers/scsi/mvme16x_scsi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/scsi/mvme16x_scsi.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/mvme16x_scsi.c	2007-07-31 11:02:11.000000000 +0200
@@ -48,13 +48,12 @@ mvme16x_probe(struct device *dev)
 		goto out;
 	}

-	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
+	hostdata = kzalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
 	if (hostdata == NULL) {
 		printk(KERN_ERR "mvme16x-scsi: "
 				"Failed to allocate host data\n");
 		goto out;
 	}
-	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));

 	/* Fill in the required pieces of hostdata */
 	hostdata->base = (void __iomem *)0xfff47000UL;
