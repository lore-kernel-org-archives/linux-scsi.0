From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 7/7] remove timeout from struct scsi_device
Date: Sun, 30 Nov 2008 10:39:01 -0600
Message-ID: <1228063141.4115.46.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40498 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751381AbYK3QjB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Nov 2008 11:39:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Jens Axboe <Jens.Axboe@oracle.com>

by removing the unused timeout parameter we ensure a compile failure if
anyone is accidentally still using it rather than the block timeout.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index a37a814..2a1c141 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -159,8 +159,6 @@ struct scsi_device {
 	atomic_t iodone_cnt;
 	atomic_t ioerr_cnt;
 
-	int timeout;
-
 	struct device		sdev_gendev,
 				sdev_dev;
 


