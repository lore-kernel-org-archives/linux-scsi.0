From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] scsi: add a symbolic name for the ZBC device type
Date: Fri, 18 Jul 2014 17:17:17 +0200
Message-ID: <1405696638-23770-3-git-send-email-hch@lst.de>
References: <1405696638-23770-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45524 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760304AbaGRPPH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jul 2014 11:15:07 -0400
In-Reply-To: <1405696638-23770-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>

Make sure we have a symbolic name for the ZBC type available,
so that e.g. patch for a SATA to translate ZAC commands can
make use of it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/scsi/scsi.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 91e2e42..e6df23c 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -332,6 +332,7 @@ static inline int scsi_status_is_good(int status)
 #define TYPE_ENCLOSURE      0x0d    /* Enclosure Services Device */
 #define TYPE_RBC	    0x0e
 #define TYPE_OSD            0x11
+#define TYPE_ZBC            0x14
 #define TYPE_NO_LUN         0x7f
 
 /* SCSI protocols; these are taken from SPC-3 section 7.5 */
-- 
1.9.1

