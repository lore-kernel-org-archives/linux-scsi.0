From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] scsi: fix kerneldoc comment for __scsi_put_command
Date: Sat, 15 Mar 2014 06:19:16 -0700
Message-ID: <20140315131916.GA13647@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.137.202.9] ([198.137.202.9]:45925 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754932AbaCONTh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Mar 2014 09:19:37 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

The dev argument was removed, so don't pretend to document it.

Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 843b4f1..2b12983 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -305,7 +305,6 @@ EXPORT_SYMBOL(scsi_get_command);
  * __scsi_put_command - Free a struct scsi_cmnd
  * @shost: dev->host
  * @cmd: Command to free
- * @dev: parent scsi device
  */
 void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 {
