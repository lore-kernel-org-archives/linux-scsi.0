From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 3/8] libata-scsi don't set max_phys_segments higher than scsi-ml
Date: Thu, 05 Jul 2007 16:43:35 +0300
Message-ID: <468CF587.4090102@panasas.com>
References: <468CDB3C.4060500@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:26947 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756407AbXGENnz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jul 2007 09:43:55 -0400
In-Reply-To: <468CDB3C.4060500@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>


- The set can actually be removed completely as suggested by Tomo

Boaz
---
 drivers/ata/libata-scsi.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index c228df2..13603a0 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -800,8 +800,6 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
 
 	ata_scsi_sdev_config(sdev);
 
-	blk_queue_max_phys_segments(sdev->request_queue, LIBATA_MAX_PRD);
-
 	sdev->manage_start_stop = 1;
 
 	if (dev)
-- 
1.5.2.2.249.g45fd


