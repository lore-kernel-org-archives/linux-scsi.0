From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] scsi: update scsi_device_types
Date: Fri, 18 Jul 2014 17:17:16 +0200
Message-ID: <1405696638-23770-2-git-send-email-hch@lst.de>
References: <1405696638-23770-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45522 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761642AbaGRPPH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jul 2014 11:15:07 -0400
In-Reply-To: <1405696638-23770-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>

Add two new device types, most importantly the zoned block device
one.

Split from an earlier patch by Hannes Reinecke.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 013709f..33318f5 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -122,6 +122,8 @@ static const char *const scsi_device_types[] = {
 	"Bridge controller",
 	"Object storage   ",
 	"Automation/Drive ",
+	"Security Manager ",
+	"Direct-Access-ZBC",
 };
 
 /**
-- 
1.9.1

