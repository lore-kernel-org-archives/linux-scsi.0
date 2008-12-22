From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 02/18] scsi: OSD_TYPE
Date: Mon, 22 Dec 2008 14:39:50 +0200
Message-ID: <1229949590-15705-1-git-send-email-bharrosh@panasas.com>
References: <494F88C0.4070507@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:2792 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751453AbYLVMj5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Dec 2008 07:39:57 -0500
In-Reply-To: <494F88C0.4070507@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, linux-s
Cc: linux-kernel <linux-kernel@vger.kernel.org>

- Define the OSD_TYPE scsi device and let it show up in scans

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_scan.c |    1 +
 include/scsi/scsi.h      |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 18486b5..4db6e3e 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -794,6 +794,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	case TYPE_ENCLOSURE:
 	case TYPE_COMM:
 	case TYPE_RAID:
+	case TYPE_OSD:
 		sdev->writeable = 1;
 		break;
 	case TYPE_ROM:
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index a109165..de1cef2 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -263,6 +263,7 @@ static inline int scsi_status_is_good(int status)
 #define TYPE_RAID           0x0c
 #define TYPE_ENCLOSURE      0x0d    /* Enclosure Services Device */
 #define TYPE_RBC	    0x0e
+#define TYPE_OSD            0x11
 #define TYPE_NO_LUN         0x7f
 
 /* SCSI protocols; these are taken from SPC-3 section 7.5 */
-- 
1.6.0.1

