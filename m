From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 02/16] scsi: OSD_TYPE
Date: Sun, 25 Jan 2009 16:51:33 +0200
Message-ID: <1232895093-17103-1-git-send-email-bharrosh@panasas.com>
References: <497C7B33.4080105@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:27837 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755099AbZAYOvi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Jan 2009 09:51:38 -0500
In-Reply-To: <497C7B33.4080105@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd ml <osd-dev@open-osd.org>

- Define the OSD_TYPE scsi device and let it show up in scans

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_scan.c |    1 +
 include/scsi/scsi.h      |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 66505bb..be01089 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -796,6 +796,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
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

